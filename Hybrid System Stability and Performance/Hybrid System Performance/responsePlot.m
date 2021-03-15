function [kpIndex,kiIndex,stIndex,fIndex] = responsePlot(Kp,Ki,switchThresh,sinfreqsDecimate,Kpselect,Kiselect,...
    switchThreshselect,frequencyselect,pureSinTime,sweepData)
    
    [~,kpIndex] = min(abs(Kp-Kpselect));
    Ki = Ki(kpIndex,:);
    [~,kiIndex] = min(abs(Ki-Kiselect));
    [~,stIndex] = min(abs(switchThresh-switchThreshselect));
    [~,fIndex] = min(abs(sinfreqsDecimate-frequencyselect));
    
    sinin = 50*sin(2*pi*sinfreqsDecimate(fIndex).*pureSinTime);
    figure
    subplot(1,3,1)
    plot(pureSinTime,sinin)
    hold on
    plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).smoothOut)
    subplot(1,3,2)
    plot(pureSinTime,sinin)
    hold on
    plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).hybridInfo(stIndex).hybridOut)
    subplot(1,3,3)
    plot(pureSinTime,sinin)
    hold on
    plot(pureSinTime,sweepData(kpIndex,kiIndex,fIndex).hybridInfo(stIndex).hFit)
end