function [bestSet,errorSet] = optimalSet(sweepData,commonPath,mode,eftoggle)
rat_I = 4.971;
%Interpolation grid
gx=0:.1:41;
gy=0:1:450;

for i=1:size(sweepData,3)
    sinfreqs(i) = sweepData(1,1,i).inputFreq;
end

if strcmp(mode,'sSAE')
    errorSet = zeros(size(sweepData,1)*size(sweepData,2),3);
    iter = 1;
    for i=1:size(sweepData,1)
        for j = 1:size(sweepData,2)
            errorsum = 0;
            for k = 1:size(sweepData,3)
                errorsum = errorsum + sweepData(i,j,k).sSAE;
            end
            errorSet(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki errorsum];
            iter = iter + 1;
        end
    end   
elseif strcmp(mode,'hSAE')
    errorSetFull = zeros(size(sweepData,1)*size(sweepData,2)*size(sweepData(1,1,1).hybridInfo,2),7);
    iter = 1;
    for i=1:size(sweepData,1)
        for j = 1:size(sweepData,2)
            for m = 1:size(sweepData(1,1,1).hybridInfo,2)
                errorsum = 0;
                for k = 1:size(sweepData,3)
                    errorsum = errorsum + sweepData(i,j,k).hybridInfo(m).hSAE;                    
                end
                errorSetFull(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).hybridInfo(m).switchThresh errorsum i j m];
                iter = iter + 1;
            end
        end
    end 
elseif strcmp(mode,'mixSAE')
    errorSet = zeros(size(sweepData,1)*size(sweepData,2),3);
    iter = 1;
    for i=1:size(sweepData,1)
        for j = 1:size(sweepData,2)
            errorsum = 0;
            for k = 1:size(sweepData,3)
                errorsum = errorsum + sweepData(i,j,k).sSAE;
            end
            errorSet(iter,:) = [(sweepData(i,j,k).Kp) (sweepData(i,j,k).Ki) errorsum];
            iter = iter + 1;
        end
    end
    
    errorSetFull = zeros(size(sweepData,1)*size(sweepData,2)*size(sweepData(1,1,1).hybridInfo,2),7);
    iter = 1;
    for i=1:size(sweepData,1)
        for j = 1:size(sweepData,2)
            for m = 1:size(sweepData(1,1,1).hybridInfo,2)
                errorsum = 0;
                for k = 1:size(sweepData,3)
                    errorsum = errorsum + sweepData(i,j,k).hybridInfo(m).hSAE;                    
                end
                errorSetFull(iter,:) = [(sweepData(i,j,k).Kp) (sweepData(i,j,k).Ki) sweepData(i,j,k).hybridInfo(m).switchThresh errorsum i j m];
                iter = iter + 1;
            end
        end
    end     
end

%Find best set
if strcmp(mode,'sSAE')
    best = inf;
    bestind = 1;
    for i=1:size(errorSet,1)
        if errorSet(i,3) < best
            best = errorSet(i,3);
            bestind = i;
        end
    end
    bestSet = errorSet(bestind,1:2);
elseif strcmp(mode,'hSAE')
    best = inf;
    bestind = 1;
    for i=1:size(errorSetFull,1)
        if errorSetFull(i,4) < best
            best = errorSetFull(i,4);
            bestind = i;
        end
    end
    bestSet = errorSetFull(bestind,1:3);
    bestSigma = errorSetFull(bestind,3);
    
    %Extra step for hybrid - pulling out all at that switching threshold
    %for plot
    iter = 1;
    for i=1:size(errorSetFull,1)
        if errorSetFull(i,3) == bestSigma
            errorSet(iter,:) = errorSetFull(i,:);
            iter = iter + 1;
        end
    end
elseif strcmp(mode,'mixSAE')    
    best = inf;
    bestind = 1;
    for i=1:size(errorSetFull,1)
        if errorSetFull(i,4) < best
            best = errorSetFull(i,4);
            bestind = i;
        end
    end
    bestSigma = errorSetFull(bestind,3);
    
    %Extra step for hybrid - pulling out all at that switching threshold
    %for plot
    iter = 1;
    for i=1:size(errorSetFull,1)
        if errorSetFull(i,3) == bestSigma
            errorSet2(iter,:) = errorSetFull(i,:);
            iter = iter + 1;
        end
    end
end

if strcmp(mode,'mixSAE')
    bestSet = 0;
    cmax = 2e5;
    %Smooth Stability Data - Get max 04 Slice
    figure('Renderer', 'painters', 'Position', [10 10 1200 425])
    tl = tiledlayout(1,2, 'Padding', 'none', 'TileSpacing', 'compact');

    slicePath = strcat(commonPath,'\Stability Sweep Data\');
    latestSlice = latestTimeParse(slicePath,'04DelaySlice');
    load(latestSlice)
    clear slicePath latestSlice
    xdata = stableSliceMax(:,1)/rat_I;
    ydata = stableSliceMax(:,2)/rat_I;

    nexttile
    %a = area(xdata,ydata);
    hold on
    %a.FaceAlpha = 1;
    colororder('k')
    ax = gca;
    set(gcf, 'Color', 'w');
    ax.XAxis.FontSize = 18;
    ax.XAxis.FontName = 'Helvetica';
    ax.XAxis.Color = 'k';
    ax.YAxis.FontSize = 18;
    ax.YAxis.FontName = 'Helvetica';
    ax.YAxis.Color = 'k';
    grid on
    grid minor
    xlim([0 45])
    ylim([0 450])


    title('Smooth System','FontName','Helvetica','FontSize',18,'FontWeight','normal')
    
    g=gridfit(errorSet(:,1),errorSet(:,2),errorSet(:,3),gx,gy);
    [g] = gridNaNifier(g,gx,gy,xdata,ydata);
    h1 = surf(gx,gy,g);
    view(0,90)
    colormap(parula)
    caxis([0 2e5])
    h1(1).LineStyle = 'none';
    box on
    
    %Box since surface covers it up
    plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
    plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
    plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
    plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)

    %Experimental data point
    plot3(10,0,max(max(g))+1,'.r','MarkerSize',35) 
    clear g
    
    nexttile
    %a = area(xdata,ydata);
    hold on
    %a.FaceAlpha = 1;
    colororder('k')
    ax = gca;
    set(gcf, 'Color', 'w');
    ax.XAxis.FontSize = 18;
    ax.XAxis.FontName = 'Helvetica';
    ax.XAxis.Color = 'k';
    ax.YAxis.FontSize = 18;
    ax.YAxis.FontName = 'Helvetica';
    ax.YAxis.Color = 'k';
    grid on
    grid minor
    xlim([0 45])
    ylim([0 450])

    title(strcat('Hybrid System, \sigma = ',num2str(errorSet2(1,3)))...
        ,'FontName','Helvetica','FontSize',18,'FontWeight','normal')
    
    g=gridfit(errorSet2(:,1),errorSet2(:,2),errorSet2(:,4),gx,gy);
    [g] = gridNaNifier(g,gx,gy,xdata,ydata);
    h1 = surf(gx,gy,g);
    view(0,90)
    colormap(parula)
    caxis([0 2e5])
    h1(1).LineStyle = 'none';
    box on
    
    %Box since surface covers it up
    plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
    plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
    plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
    plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)

    %Experimental data point
    plot3(10,0,max(max(g))+1,'.r','MarkerSize',35) 
    
    %For whole plot
    xlabel(tl,'K_P^*','FontName','Helvetica','FontSize',20,'Color','k')
    ylabel(tl,'K_I^*','FontName','Helvetica','FontSize',20,'Color','k')
    cbar = colorbar;
    cbar.Label.String = {'Sum-Abs Error','Over all Frequencies (rad/s)'};  
    cbar.FontName = 'Helvetica';
    cbar.FontSize = 18;
    cbar.Color = [0 0 0];
    cbar.Label.FontName = 'Helvetica';
    cbar.Label.FontSize = 18;
    cbar.Label.Color = [0 0 0];
    cbar.Layout.Tile = 'east';
    %title(tl,'Sum-Abs Error across all frequencies','FontName','Helvetica','FontSize',22,'Color','k')
    
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'mixOptimalSAE');
    if eftoggle == 1
        export_fig (savePath,'-pdf','-nocrop')
    end    
    
else
    %Smooth Stability Data - Get max 04 Slice
    slicePath = strcat(commonPath,'\Stability Sweep Data\');
    latestSlice = latestTimeParse(slicePath,'04DelaySlice');
    load(latestSlice)
    clear slicePath latestSlice
    xdata = stableSliceMax(:,1);
    ydata = stableSliceMax(:,2);

    figure('Renderer', 'painters', 'Position', [10 10 1000 700])
    a = area(xdata,ydata);
    hold on
    a.FaceAlpha = 0.2;
    ax = gca;
    set(gcf, 'Color', 'w');
    ax.XAxis.FontSize = 18;
    ax.XAxis.FontName = 'Helvetica';
    ax.XAxis.Color = 'k';
    ax.YAxis.FontSize = 18;
    ax.YAxis.FontName = 'Helvetica';
    ax.YAxis.Color = 'k';
    xlabel('K_P (pNms)','FontName','Helvetica','FontSize',22,'FontWeight','bold')
    ylabel('K_I (pNm)','FontName','Helvetica','FontSize',22,'FontWeight','bold')
    grid on
    grid minor
    xlim([0 250])
    ylim([0 2500])

    if strcmp(mode,'sSAE')
        a.FaceAlpha = 1;
        colororder('k')
        title('Smooth Sum-Abs Error sum over all frequencies.','FontName','Helvetica','FontSize',22,'FontWeight','bold')
        c = errorSet(:,3);
        caxis([0 2e5])
        bar = colorbar;
        bar.FontName = 'Helvetica';
        bar.FontSize = 22;
        bar.FontWeight = 'bold';
        bar.Label.String = 'Sum-Abs Error Sum';
        scatter(errorSet(:,1),errorSet(:,2),320,c,'.')   
    elseif strcmp(mode,'hSAE')
        a.FaceAlpha = 1;
        colororder('k')
        title({'Hybrid Sum-Abs Error sum over all frequencies', strcat('(\sigma = ',num2str(errorSet(1,3)),')')}...
            ,'FontName','Helvetica','FontSize',22,'FontWeight','bold')
        c = errorSet(:,4);
        caxis([0 2e5])
        bar = colorbar;
        bar.FontName = 'Helvetica';
        bar.FontSize = 22;
        bar.FontWeight = 'bold';
        bar.Label.String = 'Sum-Abs Error Sum';
        scatter(errorSet(:,1),errorSet(:,2),320,c,'.')   
    end    
end



end