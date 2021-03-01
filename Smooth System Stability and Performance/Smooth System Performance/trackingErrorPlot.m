function [tmags,tphases] = trackingErrorPlot(G_plant,Kp,Ki,td,mode,pureSinTime,pureSin,sinfreqs,lineColors,...
    selectedFreqIndices,selectedArrayIndices)
    %FFT Params
    Fs = 1/(pureSinTime(2)-pureSinTime(1));
    N = 10000;
    
    if mode == 0
        %Mode is 0 = Kp sweep
        %Delay
        [nump,denp]=padeWrap(td);
        d_tf = tf(nump,denp);

        %Data Array
        tracksweep = repmat(struct('gain',-1,'phase',-1,'error',-1),length(Kp),length(sinfreqs));   
        
        for i = 1:length(Kp)
            C_tf = tf([Kp(i) Ki],[1 0]);

            %Closed Loop Transfer Function
            num = C_tf*G_plant;
            den = (1 + num*d_tf);
            cl_tf = num/den;

            %Stability check
            s = isstablemod(cl_tf);
            if s == 1
               for j = 1:length(sinfreqs)
                   tracksweep(i,j) = trackingSim(j,cl_tf,pureSin,pureSinTime,sinfreqs,Fs,N); 
               end
            else
               for j = 1:length(sinfreqs)
                   tracksweep(i,j).gain = -1; 
                   tracksweep(i,j).phase = -1; 
                   tracksweep(i,j).error = -1; 
               end 
            end
        end

       [tmags,tphases] = trackingPlotter(lineColors,selectedFreqIndices,tracksweep,Kp,...
            strcat('Tracking error for changing K_p.  K_I = ',num2str(Ki)),sinfreqs,'Kp',selectedArrayIndices);
        
    elseif mode == 1
        %Mode is 1 = Ki sweep
        %Delay
        [nump,denp]=padeWrap(td);
        d_tf = tf(nump,denp);

        %Data Array
        tracksweep = repmat(struct('gain',-1,'phase',-1,'error',-1),length(Ki),length(sinfreqs));   
        
        for i = 1:length(Ki)
            C_tf = tf([Kp Ki(i)],[1 0]);

            %Closed Loop Transfer Function
            num = C_tf*G_plant;
            den = (1 + num*d_tf);
            cl_tf = num/den;

            %Stability check
            s = isstablemod(cl_tf);
            if s == 1
               for j = 1:length(sinfreqs)
                   tracksweep(i,j) = trackingSim(j,cl_tf,pureSin,pureSinTime,sinfreqs,Fs,N); 
               end 
            else
               for j = 1:length(sinfreqs)
                   tracksweep(i,j).gain = -1; 
                   tracksweep(i,j).phase = -1; 
                   tracksweep(i,j).error = -1; 
               end 
            end
        end

        [tmags,tphases] = trackingPlotter(lineColors,selectedFreqIndices,tracksweep,Ki,...
            strcat('Tracking error for changing K_i. K_P = ',num2str(Kp)),sinfreqs,'Ki',selectedArrayIndices);
    end
end