function [sigData] = stabPlot(stabData,sigs,sigma,commonPath,rat_I,eftoggle)
warning('off','GRIDFIT:extend')
%Interpolation grid
gx=0:.4:101;
gy=0:4:1001;
    
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
    figure('Renderer', 'painters', 'Position', [10 10 1500 700])
    tl = tiledlayout(2,3, 'Padding', 'none', 'TileSpacing', 'compact');
    
    %Smooth Stability Data - Get max 04 Slice for displaying good points
    slicePath = strcat(commonPath,'\Stability Sweep Data\');
    latestSlice = latestTimeParse(slicePath,'04DelaySlice');
    load(latestSlice)
    clear slicePath latestSlice
    xdata = stableSliceMax(:,1)/rat_I;
    ydata = stableSliceMax(:,2)/rat_I;
    
    for i = 1:length(sigs)
        nexttile
        ax = gca;
        hold on
        ax.XAxis.FontSize = 12;
        ax.XAxis.FontName = 'Helvetica';
        ax.XAxis.Color = 'k';
        ax.YAxis.FontSize = 12;
        ax.YAxis.FontName = 'Helvetica';
        ax.YAxis.Color = 'k';
        grid on
        grid minor
        set(gcf, 'Color', 'w');
        
        title(strcat('(\sigma =',num2str(sigs(i)),' rad)'),...
            'FontName','Helvetica','FontSize',14)   
%         c = sigData(:,4,i);
%         caxis([0 1000])
%         scatter(sigData(:,1,i),sigData(:,2,i),160,c,'.')

        g=gridfit(sigData(:,1,i),sigData(:,2,i),sigData(:,4,i),gx,gy);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 1000])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 101],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 0],[0 1001], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 101],[1001 1001], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([101 101],[0 1001], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        
        %Experimental data point
        plot3(10,0,max(max(g))+1,'.r','MarkerSize',30) 
        
        plot3(xdata,ydata,(max(max(g))+1)*ones(size(ydata)),'k','LineWidth',2)
        clear g
        xlim([0 101])
        ylim([0 1001])
    end
    %For whole plot
    cbar = colorbar;
    cbar.FontName = 'Helvetica';
    cbar.FontSize = 18;
    cbar.Color = [0 0 0];

    cbar.Label.FontName = 'Helvetica';
    cbar.Label.FontSize = 22;
    %cbar.Label.FontWeight = 'bold';
    cbar.Label.Color = [0 0 0];
    cbar.Layout.Tile = 'east';
    cbar.Label.String = 'Response Bounds (rad/s)';
    
    xlabel(tl,'K_P^*','FontName','Helvetica','FontSize',22,'Color','k')
    ylabel(tl,'K_I^*','FontName','Helvetica','FontSize',22,'Color','k')
    
    basepath = strcat(commonPath,'\Golden Figures\Hybrid Stability\');
    savePath = strcat(basepath,'hybridStability'); 
    if eftoggle == 1
        export_fig (savePath,'-pdf','-nocrop')
    end
end