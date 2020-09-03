%This plots a gain sweep for a single input as a grid of subplots.
%Not recommended for large sweeps.

function [] = plot_GainSweep(sweep_Results,gain_Range,freq,gainName)
[imax,jmax] = size(sweep_Results);

Nplots = imax*jmax +1;

cols = idivide(int16(Nplots),int16(10));
cols = double(cols);
if cols == 0
    rows = mod(Nplots,10);
else
    rows = 10;
end
cols = double(cols)+1;

figure

%Plot input curve first
subplot(rows,cols,1)
plot(sweep_Results(1,1).tout,sweep_Results(1,1).P_in)
title(strcat("Input Signal: Freq = ",num2str(freq), "Hz"));
   
k = 2;
for i = 1:imax
    gain = gain_Range(i);
    sim_Results = sweep_Results(i,1);

    P_out = sim_Results.P_out;
    tout = sim_Results.tout;

    subplot(rows,cols,k)
    plot(tout,P_out)
    title(strcat(gainName,"= ",num2str(gain)))
    k = k +1;


end