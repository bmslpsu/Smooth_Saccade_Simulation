function [] = SlicePerformance(sweepData,commonPath,mode,sigmaIndex,eftoggle)

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

figure('Renderer', 'painters', 'Position', [10 10 1500 700])
tl = tiledlayout(subr,subc, 'Padding', 'none', 'TileSpacing', 'compact');

for k = 1:length(sinfreqs)
    
    %Generate Tile
    nexttile
    a = area(xdata,ydata);
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
    xlim([0 250])
    ylim([0 2500])
    a.FaceAlpha = 1;
    colororder('k')
    hold on
    
    %Collect kp,ki,error triplets for frequency
    if strcmp(mode,'sSAE')
        sSAEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                sSAEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).sSAE];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14)   
        c = sSAEdata(:,3);
        caxis([0 3.5e4])
        scatter(sSAEdata(:,1),sSAEdata(:,2),160,c,'.')         
    elseif strcmp(mode,'sTE')
        sTEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                sTEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).sError];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14)   
        c = sTEdata(:,3);
        caxis([0 1])
        scatter(sTEdata(:,1),sTEdata(:,2),160,c,'.')     
    elseif strcmp(mode,'hSAE')
        hSAEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                hSAEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).hybridInfo(sigmaIndex).hSAE];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14)   
        c = hSAEdata(:,3);
        caxis([0 3.5e4])
        scatter(hSAEdata(:,1),hSAEdata(:,2),160,c,'.')     
    elseif strcmp(mode,'hTE')
        hTEdata = zeros(size(sweepData,1)*size(sweepData,2),3);
        iter =1;
        for i = 1:size(sweepData,1)
            for j = 1:size(sweepData,2)
                hTEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).hybridInfo(sigmaIndex).hError];
                iter=iter+1;
            end
        end
        
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14)   
        c = hTEdata(:,3);
        caxis([0 1])
        scatter(hTEdata(:,1),hTEdata(:,2),160,c,'.')     
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
                hSigmaSAEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).hybridInfo(minerrorind).switchThresh];
                iter=iter+1;
            end
        end     
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',14,'FontWeight','bold')
        c = hSigmaSAEdata(:,3);
        caxis([0 5])
        scatter(hSigmaSAEdata(:,1),hSigmaSAEdata(:,2),160,c,'.')  
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
                hSigmaTEdata(iter,:) = [sweepData(i,j,k).Kp sweepData(i,j,k).Ki sweepData(i,j,k).hybridInfo(minerrorind).switchThresh];
                iter=iter+1;
            end
        end 
        title(strcat('(f_{in} =',num2str(sinfreqs(k)),' Hz)'),...
            'FontName','Helvetica','FontSize',24,'FontWeight','bold')
        c = hSigmaTEdata(:,3);
        caxis([0 5])
        scatter(hSigmaTEdata(:,1),hSigmaTEdata(:,2),160,c,'.')  
       
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

xlabel(tl,'K_P (pNms)','FontName','Helvetica','FontSize',22,'Color','k')
ylabel(tl,'K_I (pNm)','FontName','Helvetica','FontSize',22,'Color','k')

if strcmp(mode,'sSAE')
    cbar.Label.String = 'Sum-Abs Error (rad/s)';    
    title(tl,'Sum-Abs Error of Smooth System','FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'sSAE');
elseif strcmp(mode,'sTE')
    cbar.Label.String = 'Tracking Error';    
    title(tl,'Tracking Error of Smooth System','FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'sTE');   
elseif strcmp(mode,'hSAE')
    cbar.Label.String = 'Sum-Abs Error (rad/s)';    
    title(tl,strcat('Sum-Abs Error of Hybrid System, \sigma =',...
            num2str(sweepData(1,1,1).hybridInfo(sigmaIndex).switchThresh),' rad)'),...
        'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSAE');   
elseif strcmp(mode,'hTE')
    cbar.Label.String = 'Tracking Error';    
    title(tl,strcat('Tracking Error of Hybrid System, \sigma =',...
            num2str(sweepData(1,1,1).hybridInfo(sigmaIndex).switchThresh),' rad)'),...
        'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hTE');     
elseif strcmp(mode,'hSigmaSAE')
    cbar.Label.String = 'Switching Threshold, \sigma (rad)';    
    title(tl,'Optimal Switching Threshold (SAE)',...
        'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSigmaSAE');   
elseif strcmp(mode,'hSigmaTE')
    cbar.Label.String = 'Switching Threshold, \sigma (rad)';    
    title(tl,'Optimal Switching Threshold (TE)',...
        'FontName','Helvetica','FontSize',22,'Color','k')
    basepath = strcat(commonPath,'\Golden Figures\Smooth Performance\New Stability\');
    savePath = strcat(basepath,'hSigmaTE'); 
end
if eftoggle == 1
    export_fig (savePath,'-pdf','-nocrop')
end


end