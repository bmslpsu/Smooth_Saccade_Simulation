function [trackSweep] = simTrackSmoothPrefill(Kp,Ki,d_tf,G_plant,pureSin,...
    pureSinTime,sinfreqs,trackSweep,i,j,ksize,Fs,N)

    C_tf = tf([Kp Ki],[1 0]);

    %Closed Loop Transfer Function
    num = C_tf*G_plant;
    den = (1 + num*d_tf);
    cl_tf = num/den;
    s = isstablemod(cl_tf);
    
    if s == 1
        for l = 1:length(sinfreqs)
            sinin = pureSin(l,:);
            sinout = lsim(cl_tf,sinin,pureSinTime);
            for k = 1:ksize
                trackSweep(i,j,k,l).Kp = Kp;
                trackSweep(i,j,k,l).Ki = Ki;
                trackSweep(i,j,k,l).inputFreq = sinfreqs(l);
                trackSweep(i,j,k,l).smoothOut = sinout;
                [trackSweep(i,j,k,l).sGain, trackSweep(i,j,k,l).sPhase, trackSweep(i,j,k,l).sError] = ...
                trackingSimHybrid(sinin,sinout,sinfreqs(l),Fs,N);
            end     
        end    
    else
        for l = 1:length(sinfreqs)
            for k = 1:ksize
                trackSweep(i,j,k,l).Kp = Kp;
                trackSweep(i,j,k,l).Ki = Ki;
                trackSweep(i,j,k,l).inputFreq = sinfreqs(l);
            end     
        end            
    end
    

end