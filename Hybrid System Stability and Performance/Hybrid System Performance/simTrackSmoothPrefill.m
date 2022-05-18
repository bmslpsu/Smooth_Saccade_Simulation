function [emptySinglePoint] = simTrackSmoothPrefill(Kp,Ki,d_tf,G_plant,pureSin,...
    pureSinTime,sinfreqs,emptySinglePoint,Fs,N,tLimSet,simName,switchThresh,td)

    C_tf = tf([Kp Ki],[1 0]);

    %Closed Loop Transfer Function
    num = C_tf*G_plant*d_tf;
    den = (1 + num);
    cl_tf = num/den;
    s = isstablemod(cl_tf);
    
    %Set up Parameters for hybrid simulation
    K_P = Kp;
    K_I = Ki;
    sac_time = 0.04;
    n_delay = td;
    T_lim_up = tLimSet.T_lim_up;
    T_lim_low = tLimSet.T_lim_low;
    
    %For each frequency
    for l = 1:length(sinfreqs)
        %If stable closed loop tf, run simulation for smooth system
        %(switching threshold = inf)
        if s == 1
            sinin = pureSin(l,:);
            switch_thresh=inf;
            V_in = [pureSinTime' sinin'];
            
            output = sim(simName,'SrcWorkspace','current');  
            sinout = output.V_out;
           
            %Get FRF for gain, phase data.  Calculate SAE
            emptySinglePoint(l).smoothOut = sinout;
            [emptySinglePoint(l).sGain, emptySinglePoint(l).sPhase, emptySinglePoint(l).sError] = ...
                trackingSimHybrid(sinin,sinout,sinfreqs(l),Fs,N);
            emptySinglePoint(l).sSAE = sum(abs(sinin-sinout'));
            emptySinglePoint(l).sIE = sum(abs(output.interror));
        end

        emptySinglePoint(l).Kp = Kp;
        emptySinglePoint(l).Ki = Ki;
        emptySinglePoint(l).inputFreq = sinfreqs(l);

        %Run hybrid simulation for each switching threshold
        for k = 1:length(switchThresh)
            sinin = pureSin(l,:);
            switch_thresh=switchThresh(k);
            V_in = [pureSinTime' sinin'];
            output = sim(simName,'SrcWorkspace','current');

            out = output.V_out';

            %Run sine fit and FRF 
            [sinout,rsquare] = sineFitMod(out,pureSinTime,sinfreqs(l));
            emptySinglePoint(l).hybridInfo(k).hybridOut = out;
            emptySinglePoint(l).hybridInfo(k).switchThresh = switchThresh(k);
            emptySinglePoint(l).hybridInfo(k).rsquare = rsquare;
            emptySinglePoint(l).hybridInfo(k).hFit = sinout;
            [emptySinglePoint(l).hybridInfo(k).hGain, emptySinglePoint(l).hybridInfo(k).hPhase,...
                emptySinglePoint(l).hybridInfo(k).hError] = trackingSimHybrid(sinin,sinout,sinfreqs(l),Fs,N);

            %Calculate SAES
            emptySinglePoint(l).hybridInfo(k).hFitSAE = sum(abs(sinin-sinout));
            emptySinglePoint(l).hybridInfo(k).hSAE = sum(abs(sinin-out));
            emptySinglePoint(l).hybridInfo(k).hIE = sum(abs(output.interror));
        end
    end    
end