function [bestSet,errorSet] = optimalSet(sweepData,commonPath,mode,eftoggle)

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
elseif strcmp(mode,'sTE')
    errorSet = zeros(size(sweepData,1)*size(sweepData,2),3);
    iter = 1;
    for i=1:size(sweepData,1)
        for j = 1:size(sweepData,2)
            errorsum = 0;
            for k = 1:size(sweepData,3)
                errorsum = errorsum + sweepData(i,j,k).sError;
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
            errorSet(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki errorsum];
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
                errorSetFull(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).hybridInfo(m).switchThresh errorsum i j m];
                iter = iter + 1;
            end
        end
    end     
end

%Find best set
if strcmp(mode,'sSAE') || strcmp(mode,'sTE')
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
    figure('Renderer', 'painters', 'Position', [10 10 1200 500])
    tl = tiledlayout(1,2, 'Padding', 'none', 'TileSpacing', 'compact');

    slicePath = strcat(commonPath,'\Stability Sweep Data\');
    latestSlice = latestTimeParse(slicePath,'04DelaySlice');
    load(latestSlice)
    clear slicePath latestSlice
    xdata = stableSliceMax(:,1);
    ydata = stableSliceMax(:,2);

    nexttile
    a = area(xdata,ydata);
    hold on
    a.FaceAlpha = 1;
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
    xlim([0 250])
    ylim([0 2500])


    title('Smooth System','FontName','Helvetica','FontSize',18,'FontWeight','normal')
    c = errorSet(:,3);
    caxis([0 cmax])
    scatter(errorSet(:,1),errorSet(:,2),160,c,'.')
    hold off

    nexttile
    a = area(xdata,ydata);
    hold on
    a.FaceAlpha = 1;
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
    xlim([0 250])
    ylim([0 2500])

    title(strcat('Hybrid System, \sigma = ',num2str(errorSet2(1,3)))...
        ,'FontName','Helvetica','FontSize',18,'FontWeight','normal')
    c = errorSet2(:,4);
    caxis([0 cmax])
    scatter(errorSet2(:,1),errorSet2(:,2),160,c,'.') 
    hold off

    %For whole plot
    xlabel(tl,'K_P (pNms)','FontName','Helvetica','FontSize',22,'Color','k')
    ylabel(tl,'K_I (pNm)','FontName','Helvetica','FontSize',22,'Color','k')
    cbar = colorbar;
    cbar.Label.String = 'Sum-Abs Error (rad/s)';  
    cbar.FontName = 'Helvetica';
    cbar.FontSize = 18;
    cbar.Color = [0 0 0];
    cbar.Label.FontName = 'Helvetica';
    cbar.Label.FontSize = 22;
    cbar.Label.Color = [0 0 0];
    cbar.Layout.Tile = 'east';
    title(tl,'Sum-Abs Error across all frequencies','FontName','Helvetica','FontSize',22,'Color','k')
    
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
    elseif strcmp(mode,'sTE')
        a.FaceAlpha = 1;
        colororder('k')
        title('Smooth Tracking Error sum over all frequencies.','FontName','Helvetica','FontSize',22,'FontWeight','bold')
        c = errorSet(:,3);
        caxis([0 6])
        bar = colorbar;
        bar.FontName = 'Helvetica';
        bar.FontSize = 22;
        bar.FontWeight = 'bold';
        bar.Label.String = 'Tracking Error Sum';
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