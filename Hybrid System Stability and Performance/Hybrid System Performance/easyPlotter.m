function [] = easyPlotter(mode,fixedParam1Name,fixedParam1,fixedParam2Name,fixedParam2,sweepData,...
    Kp,Ki,switchThresh,sinfreqsDecimate,pureSinTime,numCurves)
    figure('Renderer', 'painters', 'Position', [10 10 1000 700])
    
    
    
    if strcmp(mode,'increasingSwitchThresh')
        curveDecimate = ceil(length(switchThresh)/numCurves);
        if strcmp(fixedParam1Name,'Kp') && strcmp(fixedParam2Name,'Ki')
            [~,kpIndex] = min(abs(Kp-fixedParam1));
            [~,kiIndex] = min(abs(Ki-fixedParam2));
            
            for j = 1:length(sinfreqsDecimate)
                   tempData(j) = sweepData(kpIndex,kiIndex,1,j).sError;
            end
            plot(sinfreqsDecimate,tempData)
            lgd{1} = 'Smooth';
            hold on
            
            iter = 1;
            for i = 1:curveDecimate:length(switchThresh)
                for j = 1:length(sinfreqsDecimate)
                   tempData(j) = sweepData(kpIndex,kiIndex,i,j).hError;
                end
                plot(sinfreqsDecimate,tempData)
                lgd{iter+1} = strcat('Hybrid. ST = ',num2str(switchThresh(i)));
                iter = iter + 1;
            end
            
            kpused = sweepData(kpIndex,kiIndex,1,1).Kp;
            kiused = sweepData(kpIndex,kiIndex,1,1).Ki;
            
            legend(lgd,'FontName','Helvetica','FontSize',18,'FontWeight','bold')
            ax = gca;
            set(gcf, 'Color', 'w');
            ax.XAxis.FontSize = 18;
            ax.XAxis.FontName = 'Helvetica';
            ax.XAxis.Color = 'k';
            ax.YAxis.FontSize = 18;
            ax.YAxis.FontName = 'Helvetica';
            ax.YAxis.Color = 'k';
            xlabel('Frequency (Hz)','FontName','Helvetica','FontSize',22,'FontWeight','bold')
            ylabel('Tracking Error','FontName','Helvetica','FontSize',22,'FontWeight','bold')
            title({'Tracking Error as a function of switching threshold',...
                strcat('K_p = ',num2str(kpused),', K_i = ',num2str(kiused))},...
                'FontName','Helvetica','FontSize',22,'FontWeight','bold')
            
        end
    end
end