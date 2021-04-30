function [kpIndex,kiIndex,fIndex] = responsePlotSwitch(Kp,Ki,switchThresh,sinfreqsDecimate,Kpselect,Kiselect,...
    frequencyselect,pureSinTime,sweepData)
    
    [~,kpIndex] = min(abs(Kp-Kpselect));
    Ki = Ki(kpIndex,:);
    [~,kiIndex] = min(abs(Ki-Kiselect));
    [~,fIndex] = min(abs(sinfreqsDecimate-frequencyselect));
    
%     figure    
%     tiledlayout(6,2)
%     for i = 1:10:length(switchThresh)
%         nexttile
%         sinin = 50*sin(2*pi*sinfreqsDecimate(fIndex).*pureSinTime);
%         plot(pureSinTime,sinin)
%         hold on
%         plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).smoothOut)
%         hold off
%         nexttile
%         plot(pureSinTime,sinin)
%         hold on
%         plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).hybridInfo(i).hybridOut)
%         hold off
%     end
    
    figure    
    tiledlayout(3,1)
    for i = [21 31 41]
        nexttile
        sinin = 50*sin(2*pi*sinfreqsDecimate(fIndex).*pureSinTime);
        plot(pureSinTime,sinin,'k')
        hold on
        plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).smoothOut,'b')
        plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).hybridInfo(i).hybridOut,'r')
        plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).hybridInfo(i).hFit)
        hold off
        xlim([0 1])
        
        sData = sweepData(kpIndex,kiIndex,fIndex);
        hData = sweepData(kpIndex,kiIndex,fIndex).hybridInfo(i);
        title(strcat('Input Frequency = ',num2str(sinfreqsDecimate(fIndex)),', Switching Threshold = ',num2str(switchThresh(i)),', K_P = ',num2str(Kpselect),...
            ', K_I = ',num2str(Kiselect),', [sGain = ',num2str(sData.sGain),', sPhase = ',num2str(sData.sPhase),...
            ', sError = ',num2str(sData.sError),'], [hGain = ',num2str(hData.hGain),', hPhase = ',num2str(hData.hPhase),...
        ', HybridError = ',num2str(hData.hError),']'))
        if i ==1
            legend('Input','Smooth Response','Hybrid Response','Hybrid Fit','Location','NorthOutside','Orientation','Horizontal');
        end
    end

end