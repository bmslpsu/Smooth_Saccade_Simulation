function [rmse] = simRMSE(Kp,Ki,td,switchThresh,mode,G_plant,pureSin,...
    pureSinTime,sinfreqs,tLimSet,modelName)
    if mode == 0 %0 Indicates Smooth
        C_tf = tf([Kp Ki],[1 0]);

        %Delay (Pade approximation)
        [nump,denp]=padeWrap(td);
        d_tf = tf(nump,denp);

        %Closed Loop Transfer Function
        num = C_tf*G_plant;
        den = (1 + num*d_tf);
        cl_tf = num/den;

        rmse = zeros(1,length(sinfreqs));
        for i = 1:length(sinfreqs)
            sinin = pureSin(i,:);
            sinout = lsim(cl_tf,sinin,pureSinTime);
            rmse(i) = sqrt(mean((sinout-sinin').^2));
        end
    else %Anything other than 0 (should be 1) indicates Hybrid simulation
        %Set up Parameters
        K_P = Kp;
        K_I = Ki;
        sac_time = td;
        n_delay = td;
        T_lim_up = tLimSet.T_lim_up;
        T_lim_low = tLimSet.T_lim_low;
        switch_thresh=switchThresh;
        
        
        %Run Simulations
        rmse = zeros(1,length(sinfreqs));
        for i = 1:length(sinfreqs)
            V_in = [pureSinTime' pureSin(i,:)'];
            out = sim(modelName,'SrcWorkspace','current');
            rmse(i) = sqrt(mean((out.V_out-pureSin(i,:)').^2));
        end   
    end
end