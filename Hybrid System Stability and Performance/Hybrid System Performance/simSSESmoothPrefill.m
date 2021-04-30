function [emptySinglePoint] = simSSESmoothPrefill(Kp,Ki,d_tf,G_plant,pureSin,...
    pureSinTime,sinfreqs,emptySinglePoint,Fs,N,tLimSet,simName,switchThresh,td)

    C_tf = tf([Kp Ki],[1 0]);

    %Closed Loop Transfer Function
    num = C_tf*G_plant;
    den = (1 + num*d_tf);
    cl_tf = num/den;
    s = isstablemod(cl_tf);
    
    %Set up Parameters for hybrid
    K_P = Kp;
    K_I = Ki;
    sac_time = td;
    n_delay = td;
    T_lim_up = tLimSet.T_lim_up;
    T_lim_low = tLimSet.T_lim_low;
    
    
    for l = 1:length(sinfreqs)
        %smooth first (if stable)
        if s == 1
            sinin = pureSin(l,:);
            sinout = lsim(cl_tf,sinin,pureSinTime);   
            emptySinglePoint(l).smoothOut = sinout;
            [emptySinglePoint(l).sGain, emptySinglePoint(l).sPhase, emptySinglePoint(l).sError] = ...
                trackingSimHybrid(sinin,sinout,sinfreqs(l),Fs,N);
        end

        emptySinglePoint(l).Kp = Kp;
        emptySinglePoint(l).Ki = Ki;
        emptySinglePoint(l).inputFreq = sinfreqs(l);

        
        for k = 1:length(switchThresh)
            sinin = pureSin(l,:);
            switch_thresh=switchThresh(k);
            V_in = [pureSinTime' sinin'];
            output = sim(simName,'SrcWorkspace','current');

            out = output.V_out';
            [sinout,rsquare] = sineFitMod(out,pureSinTime,sinfreqs(l));
            emptySinglePoint(l).hybridInfo(k).hybridOut = out;
            emptySinglePoint(l).hybridInfo(k).switchThresh = switchThresh(k);
            emptySinglePoint(l).hybridInfo(k).rsquare = rsquare;
            emptySinglePoint(l).hybridInfo(k).hFit = sinout;
            [emptySinglePoint(l).hybridInfo(k).hGain, emptySinglePoint(l).hybridInfo(k).hPhase,...
                emptySinglePoint(l).hybridInfo(k).hError] = trackingSimHybrid(sinin,sinout,sinfreqs(l),Fs,N);
        end
    end    
end