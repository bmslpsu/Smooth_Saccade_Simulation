%This plots an entire sweep as a grid of subplots.  Not recommended
%for large sweeps.

function [] = plot_FullSweep(sweep_Results,gain_Range,freq_Range,gainName)
[imax,jmax] = size(sweep_Results);

figure

%Plot input curves along top row
for k = 1:jmax
   subplot(imax+1,jmax,k)
   plot(sweep_Results(1,k).tout,sweep_Results(1,k).P_in)
   title(strcat("Input Signal: Freq = ",num2str(freq_Range(k)), "Hz"));
end
k = k+1;
for i = 1:imax
    gain = gain_Range(i);
    for j = 1:jmax
        freq = freq_Range(j);
        sim_Results = sweep_Results(i,j);
        
        P_out = sim_Results.P_out;
        tout = sim_Results.tout;
        P_in = sim_Results.P_in;
        
        subplot(imax+1,jmax,k)
        plot(tout,P_out)
        title(strcat(gainName,"= ",num2str(gain),", Freq =",num2str(freq)))
        k = k +1;
    end


end