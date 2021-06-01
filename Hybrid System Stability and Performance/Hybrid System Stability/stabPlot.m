function [sigData] = stabPlot(stabData,sigs,sigma,commonPath,rat_I,eftoggle)

    
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
    xdata = stableSliceMax(:,1);
    ydata = stableSliceMax(:,2);
    
    for i = 1:length(sigs)
        nexttile
        plot(xdata/rat_I,ydata/rat_I,'k','LineWidth',4)
        hold on
        ax = gca;
        ax.XAxis.FontSize = 12;
        ax.XAxis.FontName = 'Helvetica';
        ax.XAxis.Color = 'k';
        ax.YAxis.FontSize = 12;
        ax.YAxis.FontName = 'Helvetica';
        ax.YAxis.Color = 'k';
        grid on
        grid minor
        xlim([0 101])
        ylim([0 1001])
        set(gcf, 'Color', 'w');
        
        title(strcat('(\sigma =',num2str(sigs(i)),' rad)'),...
            'FontName','Helvetica','FontSize',14)   
        c = sigData(:,4,i);
        caxis([0 1000])
        scatter(sigData(:,1,i),sigData(:,2,i),160,c,'.')          
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
    
    xlabel(tl,'K_P (Hz)','FontName','Helvetica','FontSize',22,'Color','k')
    ylabel(tl,'K_I (Hz^2)','FontName','Helvetica','FontSize',22,'Color','k')
    
    basepath = strcat(commonPath,'\Golden Figures\Hybrid Stability\');
    savePath = strcat(basepath,'hybridStability'); 
    if eftoggle == 1
        export_fig (savePath,'-pdf','-nocrop')
    end
end