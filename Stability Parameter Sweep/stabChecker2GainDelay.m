%This function takes in an array of sim outputs from the simulink model and
%determines the stability of each of them.  It then organizes them into
%two arrays of gain,freq pairs - one for stable points, and one for
%unstable points.

function [unstable,stable] = stabChecker2GainDelay(sweep_Results,gain_Range1,gain_Range2,delay_Range)
[imax,jmax,kmax] = size(sweep_Results);

%Initialize three outputs
unstable = [];
u = 1;

stable = [];
s = 1;

for i = 1:imax
    gain1 = gain_Range1(i);
    
    for j = 1:jmax
        gain2 = gain_Range2(j);
        
        for k = 1:kmax
            
            delay = delay_Range(k);
            sim_Results = sweep_Results(i,j,k);

            P_out = sim_Results.P_out;
            tout = sim_Results.tout;

            %Get peaks
            [peaks,inds] = findpeaks(P_out);

            %First check - if max is > 1e10
            if max(peaks) > 1e2
                unstable(u,:) = [gain1 gain2 delay];
                u = u + 1;
            else
                stable(s,:) = [gain1 gain2 delay];
                s = s + 1;
    %             %Get last 50% of peaks and indices (to avoid transients)
    %             numPeaks = size(peaks,1);
    %             if numPeaks == 0 || numPeaks == 1
    %                 stable(s,:) = [gain freq 0];
    %                 s = s + 1;
    %             else
    %                 peaks50per = double(idivide(int16(numPeaks),int16(2)));
    %                 lastPeaks = peaks((numPeaks-peaks50per):numPeaks);
    % 
    %                 numInds = size(inds,1);
    %                 inds50per = double(idivide(int16(numInds),int16(2)));
    %                 lastInds = inds((numInds-inds50per):numInds);
    % 
    %                 %Turn indices into time
    %                 lastTimes = tout(lastInds);
    % 
    %                 %Exponential fit to last half peaks - save b value
    %                 fo = fitoptions('exp1','lower',[-1e50 -1e50],'upper',[1e50 1e50]);
    %                 expFit = fit(lastTimes,lastPeaks,'exp1',fo); 
    % 
    %                 %Binary stability criteria
    % 
    %                 if expFit.b >0.05
    %                     unstable(u,:) = [gain freq expFit.b];
    %                     u = u + 1;
    %                 else
    %                     stable(s,:) = [gain freq expFit.b];
    %                     s = s + 1;
    %                 end
    %             end
    
            end
        end

    end


end


end