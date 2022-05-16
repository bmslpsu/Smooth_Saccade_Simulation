function [] = SlicePerformance(sweepData,commonPath,mode,sigmaIndex,eftoggle,sameThresh)

r2deg = 180/pi;

for i=1:size(sweepData,3)
    sinfreqs(i) = sweepData(1,1,i).inputFreq;
end

subc = 3;
subr = ceil(length(sinfreqs)/subc);

%Smooth Stability Data - Get max 04 Slice for displaying good points
slicePath = strcat(commonPath,'\Stability Sweep Data\');
latestSlice = latestTimeParse(slicePath,'04DelaySlice');
load(latestSlice)
clear slicePath latestSlice
xdata = stableSliceMax(:,1);
ydata = stableSliceMax(:,2);

%Interpolation grid
gx=0:.2:81;
gy=0:3:1500;

%figure('Renderer', 'painters', 'Position', [10 10 1500 700])
figure('Renderer', 'painters','units','inches')
pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 7.25 3.3833])
pos = get(gcf,'pos');
tl = tiledlayout(subr,subc, 'Padding', 'none', 'TileSpacing', 'compact');

for k = 1:length(sinfreqs)
    
    %Generate Tile
    nexttile
    %a = area(xdata,ydata);
    ax = gca;
    set(gcf, 'Color', 'w');
    ax.XAxis.FontSize = 8;
    ax.XAxis.FontName = 'Arial';
    ax.XAxis.Color = 'k';
    ax.YAxis.FontSize = 8;
    ax.YAxis.FontName = 'Arial';
    ax.YAxis.Color = 'k';
    grid on
    xlim([0 80])
    ylim([0 1500])
    %a.FaceAlpha = 1;
    %colororder('k')
    hold on
    
    %Collect kp,ki,error triplets for frequency
    if strcmp(mode,'sSAE')
        sSAEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                sSAEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).sSAE*r2deg];
                iter=iter+1;
            end
        end
        
        title(strcat('f_{in} =',num2str(sinfreqs(k)),' Hz'),...
            'FontName','Arial','FontSize',8,'FontWeight','Normal')   

        g=gridfit(sSAEdata(:,1),sSAEdata(:,2),sSAEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 3e4])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 80],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        plot3([0 0],[0 1500], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        plot3([0 80],[1500 1500], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        plot3([80 80],[0 1500], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        
        %Experimental data point
        plot3(10,0,max(max(g))+1,'.r','MarkerSize',15)
        
    elseif strcmp(mode,'hSigmaSAEPurp') 
        hSigmaSAEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        purpData = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        iterp = 1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                minerrorind = 1;
                minerror = inf;
                for m = 1:size(sweepData(1,1,1).hybridInfo,2)
                    temperror = sweepData(i,j,k).hybridInfo(m).hSAE;
                    if temperror < minerror
                        minerror = temperror;
                        minerrorind = m;
                    end
                end
                
                %Check for similarity to continuous result
                smoothTemp = sweepData(i,j,k).smoothOut;
                hybridTemp = sweepData(i,j,k).hybridInfo(minerrorind).hybridOut';
                sumdiff = sum(abs(smoothTemp-hybridTemp));
                
                if sumdiff < sameThresh
                    purpData(iterp,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki...
                        8]; 
                    iterp = iterp + 1;
                else
                end
                    hSigmaSAEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki...
                        sweepData(i,j,k).hybridInfo(minerrorind).switchThresh.*r2deg];                
                iter=iter+1;
            end
            
        end     
        title(strcat('f_{in} =',num2str(sinfreqs(k)),' Hz'),...
            'FontName','Arial','FontSize',8,'FontWeight','normal')
        
        g=gridfit(hSigmaSAEdata(:,1),hSigmaSAEdata(:,2),hSigmaSAEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 4])
        h1(1).LineStyle = 'none';
        box on
        
        %Purp points for smooth
        purpData = purpData(1:iterp-1,:);
        plot3(purpData(:,1),purpData(:,2),(max(max(g))+1)*ones(size(purpData(:,3))),'.m','MarkerSize',3.5)               
        
        
        %Box since surface covers it up
        plot3([0 80],[0 0], [max(max(g))+2 max(max(g))+2],'k','LineWidth',0.05)
        plot3([0 0],[0 1500], [max(max(g))+2 max(max(g))+2],'k','LineWidth',0.05)
        plot3([0 80],[1500 1500], [max(max(g))+2 max(max(g))+2],'k','LineWidth',0.05)
        plot3([80 80],[0 1500], [max(max(g))+2 max(max(g))+2],'k','LineWidth',0.05)
        
        %Experimental data point
        plot3(10,0,max(max(g))+2,'.r','MarkerSize',15) 
        
        %Plot pickoff points
        plot3(18,500,max(max(g))+2,'.','MarkerFaceColor',[0, 153, 51]./255,'MarkerEdgeColor','k','MarkerSize',15) 
        plot3(60,700,max(max(g))+2,'.y','MarkerSize',15) 
    end
    
    hold off
end

%For whole plot
cbar = colorbar;
cbar.FontName = 'Arial';
cbar.FontSize = 8;
cbar.Color = [0 0 0];

cbar.Label.FontName = 'Arial';
cbar.Label.FontSize = 8;
cbar.Label.Color = [0 0 0];
cbar.Layout.Tile = 'east';

xlabel(tl,'Proportional Gain','FontName','Arial','FontSize',10,'Color','k')
ylabel(tl,'Integral Gain','FontName','Arial','FontSize',10,'Color','k')

if strcmp(mode,'sSAE')
    cbar.Label.String = 'Sum-Abs Error (deg/s)';    
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'sSAE');   
elseif strcmp(mode,'hSAE')
    cbar.Label.String = 'Sum-Abs Error (rad/s)';    
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSAE');      
elseif strcmp(mode,'hSigmaSAE') || strcmp(mode,'hSigmaSAEPurp')
    cbar.Label.String = 'Switching Threshold, \sigma (deg)';    
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSigmaSAE');   
end

set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

if eftoggle == 1
    %export_fig (savePath,'-pdf','-nocrop')
    exportgraphics(gcf,strcat(savePath,'.pdf'))
end


end