function [] = SlicePerformance(sweepData,commonPath,mode,sigmaIndex,eftoggle)
rat_I = 4.971;

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
xdata = stableSliceMax(:,1)/rat_I;
ydata = stableSliceMax(:,2)/rat_I;

%Interpolation grid
gx=0:.1:41;
gy=0:1:450;

figure('Renderer', 'painters', 'Position', [10 10 1500 700])
tl = tiledlayout(subr,subc, 'Padding', 'none', 'TileSpacing', 'compact');

for k = 1:length(sinfreqs)
    
    %Generate Tile
    nexttile
    %a = area(xdata,ydata);
    ax = gca;
    set(gcf, 'Color', 'w');
    ax.XAxis.FontSize = 12;
    ax.XAxis.FontName = 'Helvetica';
    ax.XAxis.Color = 'k';
    ax.YAxis.FontSize = 12;
    ax.YAxis.FontName = 'Helvetica';
    ax.YAxis.Color = 'k';
    grid on
    grid minor
    xlim([0 45])
    ylim([0 450])
    %a.FaceAlpha = 1;
    %colororder('k')
    hold on
    
    %Collect kp,ki,error triplets for frequency
    if strcmp(mode,'sSAE')
        sSAEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                sSAEdata(iter,:) = [sweepData(i,j,k).Kp/rat_I sweepData(i,j,k).Ki/rat_I sweepData(i,j,k).sSAE];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14)   

        g=gridfit(sSAEdata(:,1),sSAEdata(:,2),sSAEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 3.5e4])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        
        %Experimental data point
        plot3(10,0,max(max(g))+1,'.r','MarkerSize',30)
        
        %plot3(xdata,ydata,(max(max(g))+1)*ones(size(ydata)),'k','LineWidth',1.5)
        
    elseif strcmp(mode,'sTE')
        sTEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                sTEdata(iter,:) = [sweepData(i,j,k).Kp/rat_I sweepData(i,j,k).Ki/rat_I sweepData(i,j,k).sError];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14)   
        
        g=gridfit(sTEdata(:,1),sTEdata(:,2),sTEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 1])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        
        %Experimental data point
        scatter3(10,0,max(max(g))+1,'r')  
        
    elseif strcmp(mode,'hSAE')
        hSAEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                hSAEdata(iter,:) = [sweepData(i,j,k).Kp/rat_I sweepData(i,j,k).Ki/rat_I sweepData(i,j,k).hybridInfo(sigmaIndex).hSAE];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14)   

        g=gridfit(hSAEdata(:,1),hSAEdata(:,2),hSAEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 3.5e4])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        
        %Experimental data point
        plot3(10,0,max(max(g))+1,'.r','MarkerSize',30) 
        
    elseif strcmp(mode,'hTE')
        hTEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                hTEdata(iter,:) = [sweepData(i,j,k).Kp/rat_I sweepData(i,j,k).Ki/rat_I sweepData(i,j,k).hybridInfo(sigmaIndex).hError];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14) 
        
        g=gridfit(hTEdata(:,1),hTEdata(:,2),hTEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 1])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        
        %Experimental data point
        scatter3(10,0,max(max(g))+1,'r')   
        
    elseif strcmp(mode,'hSigmaSAE')
        hSigmaSAEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
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
                hSigmaSAEdata(iter,:) = [sweepData(i,j,k).Kp/rat_I sweepData(i,j,k).Ki/rat_I sweepData(i,j,k).hybridInfo(minerrorind).switchThresh];
                iter=iter+1;
            end
        end     
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14,'FontWeight','bold')
        
        g=gridfit(hSigmaSAEdata(:,1),hSigmaSAEdata(:,2),hSigmaSAEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 5])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        
        %Experimental data point
        plot3(10,0,max(max(g))+1,'.r','MarkerSize',30) 
        
    elseif strcmp(mode,'hSigmaTE')
        hSigmaTEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                minerrorind = 1;
                minerror = inf;
                for m = 1:size(sweepData(1,1,1).hybridInfo,2)
                    temperror = sweepData(i,j,k).hybridInfo(m).hError;
                    if temperror < minerror
                        minerror = temperror;
                        minerrorind = m;
                    end
                end
                hSigmaTEdata(iter,:) = [sweepData(i,j,k).Kp/rat_I sweepData(i,j,k).Ki/rat_I sweepData(i,j,k).hybridInfo(minerrorind).switchThresh];
                iter=iter+1;
            end
        end 
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',24,'FontWeight','bold')
        
        g=gridfit(hSigmaTEdata(:,1),hSigmaTEdata(:,2),hSigmaTEdata(:,3),gx,gy);
        [g] = gridNaNifier(g,gx,gy,xdata,ydata);
        h1 = surf(gx,gy,g);
        view(0,90)
        colormap(parula)
        caxis([0 5])
        h1(1).LineStyle = 'none';
        box on
        
        %Box since surface covers it up
        plot3([0 45],[0 0], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 0],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([0 45],[450 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        plot3([45 45],[0 450], [max(max(g))+1 max(max(g))+1],'k','LineWidth',0.01)
        
        %Experimental data point
        scatter3(10,0,max(max(g))+1,'r') 
        
    end
    
    hold off
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

xlabel(tl,'K_P^*','FontName','Helvetica','FontSize',22,'Color','k')
ylabel(tl,'K_I^*','FontName','Helvetica','FontSize',22,'Color','k')

if strcmp(mode,'sSAE')
    cbar.Label.String = 'Sum-Abs Error (rad/s)';    
    %title(tl,'Sum-Abs Error of Smooth System','FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'sSAE');
elseif strcmp(mode,'sTE')
    cbar.Label.String = 'Tracking Error';    
    %title(tl,'Tracking Error of Smooth System','FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'sTE');   
elseif strcmp(mode,'hSAE')
    cbar.Label.String = 'Sum-Abs Error (rad/s)';    
%     title(tl,strcat('Sum-Abs Error of Hybrid System, \sigma =',...
%             num2str(sweepData(1,1,1).hybridInfo(sigmaIndex).switchThresh),' rad)'),...
%         'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSAE');   
elseif strcmp(mode,'hTE')
    cbar.Label.String = 'Tracking Error';    
%     title(tl,strcat('Tracking Error of Hybrid System, \sigma =',...
%             num2str(sweepData(1,1,1).hybridInfo(sigmaIndex).switchThresh),' rad)'),...
%         'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hTE');     
elseif strcmp(mode,'hSigmaSAE')
    cbar.Label.String = 'Switching Threshold, \sigma (rad)';    
%     title(tl,'Optimal Switching Threshold (SAE)',...
%         'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSigmaSAE');   
elseif strcmp(mode,'hSigmaTE')
    cbar.Label.String = 'Switching Threshold, \sigma (rad)';    
%     title(tl,'Optimal Switching Threshold (TE)',...
%         'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSigmaTE'); 
end
if eftoggle == 1
    export_fig (savePath,'-pdf','-nocrop')
end


end