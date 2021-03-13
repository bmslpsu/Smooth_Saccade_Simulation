function [trackSweep] = simTrack(Kp,Ki,td,switchThresh,G_plant,pureSin,...
    pureSinTime,sinfreqs,tLimSet,modelName,trackSweep,i,j,k,Fs,N)
 
    

    %Set up Parameters for hybrid
    K_P = Kp;
    K_I = Ki;
    sac_time = td;
    n_delay = td;
    T_lim_up = tLimSet.T_lim_up;
    T_lim_low = tLimSet.T_lim_low;
    switch_thresh=switchThresh;


    %Run Simulations
    for l = 1:length(sinfreqs)
        sinin = pureSin(l,:);
        V_in = [pureSinTime' sinin'];
        output = sim(modelName,'SrcWorkspace','current');

        out = output.V_out';
        [sinout,rsquare] = sineFitMod(out,pureSinTime,sinfreqs(l));
        trackSweep(i,j,k,l).hybridOut = out;
        trackSweep(i,j,k,l).switchThresh = switchThresh;
        trackSweep(i,j,k,l).rsquare = rsquare;
        trackSweep(i,j,k,l).hFit = sinout;
        [trackSweep(i,j,k,l).hGain, trackSweep(i,j,k,l).hPhase, trackSweep(i,j,k,l).hError] = ...
            trackingSimHybrid(sinin,sinout,sinfreqs(l),Fs,N);
    end   

end