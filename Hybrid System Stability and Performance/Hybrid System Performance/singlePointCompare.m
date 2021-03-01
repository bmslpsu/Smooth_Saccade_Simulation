function [smoothOut, hybridOut] = singlePointCompare(Kp,Ki,td,switchThresh,freqindex,sinfreqs,pureSinTime,pureSin,G_plant,...
    T_lim_up,T_lim_low,simName)
    
    tLimSet = struct('T_lim_up',T_lim_up,'T_lim_low',T_lim_low);
    [smoothOut,srmse] = simRMSE(Kp,Ki,td,switchThresh,0,G_plant,pureSin,pureSinTime,sinfreqs,tLimSet,simName);
    [hybridOut,hrmse] = simRMSE(Kp,Ki,td,switchThresh,1,G_plant,pureSin,pureSinTime,sinfreqs,tLimSet,simName); 
    
    fig=figure('Position', [100, 100, 1100, 500]);
    subplot(1,2,1)
    plot(pureSinTime,pureSin(freqindex,:),pureSinTime,smoothOut(freqindex,:))
    title({strcat('Smooth Control: K_p = ',num2str(Kp),', K_i = ',num2str(Ki)),...
        strcat('Freq = ',num2str(sinfreqs(freqindex)),'Hz, ','RMSE = ',num2str(srmse(freqindex)))})
    xlabel('Time (s)')
    ylabel('Angular Velocity (deg/s)')

    subplot(1,2,2)
    plot(pureSinTime,pureSin(freqindex,:),pureSinTime,hybridOut(freqindex,:))
    title({strcat('Hybrid Control: K_p = ',num2str(Kp),', K_i = ',num2str(Ki),', Switch Thresh. = ',num2str(switchThresh)),...
        strcat('Freq = ',num2str(sinfreqs(freqindex)),'Hz, ','RMSE = ',num2str(srmse(freqindex)))})
    xlabel('Time (s)')
    ylabel('Angular Velocity (deg/s)') 
end