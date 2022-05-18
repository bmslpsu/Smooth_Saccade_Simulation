function [sigData] = stabPlot(stabData,sigs,sigma,commonPath,eftoggle)
warning('off','GRIDFIT:extend')

r2deg = 180/pi;

%Interpolation grid
gx=0:2:161;
gy=0:25:2501;
    
    %Parse data for given sigs
    tic
    sigData = zeros((size(stabData,1)/length(sigma)),size(stabData,2),length(sigs));
    for i = 1:length(sigs)
        iter = 1;
        for j = 1:size(stabData,1)
            if stabData(j,3) == sigs(i)
                sigData(iter,:,i) = stabData(j,:);
                iter = iter + 1;
            end
        end
    end
    toc

    %Plotting time
    figure('Renderer', 'painters','units','inches')
    pos = get(gcf,'pos');
    set(gcf,'pos',[pos(1) pos(2) 7.25 3.3833])
    pos = get(gcf,'pos');
    
    tl = tiledlayout(2,3, 'Padding', 'none', 'TileSpacing', 'compact');
    
    %Smooth Stability Data - Get max 04 Slice for displaying good points
    slicePath = strcat(commonPath,'\Stability Sweep Data\');
    latestSlice = latestTimeParse(slicePath,'04DelaySlice');
    load(latestSlice)
    clear slicePath latestSlice
    xdata = stableSliceMax(:,1);
    ydata = stableSliceMax(:,2);
    
    for i = 1:length(sigs)
        nexttile
        ax = gca;
        hold on
        ax.XAxis.FontSize = 8;
        ax.XAxis.FontName = 'Arial';
        ax.XAxis.Color = 'k';
        ax.YAxis.FontSize = 8;
        ax.YAxis.FontName = 'Arial';
        ax.YAxis.Color = 'k';
        grid on
        grid minor
        set(gcf, 'Color', 'w');
        
        title(strcat('\sigma =',num2str(sigs(i)*r2deg,'%.0f'),' deg'),...
            'FontName','Arial','FontSize',8,'FontWeight','normal')   
        
        %Interpolation grid for heat map
        g=gridfit(sigData(:,1,i),sigData(:,2,i),sigData(:,4,i).*r2deg,gx,gy);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 9000])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 161],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        plot3([0 0],[0 2501], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        plot3([0 161],[2501 2501], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        plot3([161 161],[0 2501], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.05)
        
        %Experimental data point
        plot3(10,0,max(max(g))+1,'.r','MarkerSize',12) 
        
        plot3(xdata,ydata,(max(max(g))+1)*ones(size(ydata)),'k','LineWidth',1)
        clear g
        xlim([0 161])
        ylim([0 2501])
        xticks([0 32 64 96 128 160])
        yticks([0 500 1000 1500 2000 2500])
    end
    %For whole plot
    cbar = colorbar;
    cbar.FontName = 'Arial';
    cbar.FontSize = 8;
    cbar.Color = [0 0 0];

    cbar.Label.FontName = 'Arial';
    cbar.Label.FontSize = 8;
    %cbar.Label.FontWeight = 'bold';
    cbar.Label.Color = [0 0 0];
    cbar.Layout.Tile = 'east';
    cbar.Label.String = 'Response Bounds (deg/s)';

    xlabel(tl,'Proportional Gain','FontName','Arial','FontSize',10,'Color','k')
    ylabel(tl,'Integral Gain','FontName','Arial','FontSize',10,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Hybrid Stability\');
    savePath = strcat(basepath,'hybridStability'); 
    
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    
    if eftoggle == 1
        export_fig (savePath,'-pdf','-nocrop')
        exportgraphics(gcf,strcat(savePath,'.pdf'))
    end
end