%This is a function that will sweep the system through a single gain
%and across a range of frequencies, checking each response for stability.
%It returns a 2D array of simulation results, with rows corresponding to
%gain values, and columns to frequency values.

function [sweepResults] = GainFreq2ParamSweep(gain_Identifier,gain_Range,...
    freq_Range,t,delta_t,sim_Set)

%Extract items from struct
PSM = sim_Set.PSM;
VSM = sim_Set.VSM;
PSA = sim_Set.PSA;
VSA = sim_Set.VSA;

delay = sim_Set.delay;

PSA_sat_up = sim_Set.PSA_sat_up;
PSA_sat_low = sim_Set.PSA_sat_low;
VSA_sat_up = sim_Set.VSA_sat_up;
VSA_sat_low = sim_Set.VSA_sat_low;
PSM_sat_up = sim_Set.PSM_sat_up;
PSM_sat_low = sim_Set.PSM_sat_low;
VSM_sat_up = sim_Set.VSM_sat_up;
VSM_sat_low = sim_Set.VSM_sat_low;
vout_up = sim_Set.vout_up;
vout_low = sim_Set.vout_low;

imax = size(gain_Range,2);
jmax = size(freq_Range,2);
N = imax*jmax;

k = 1;
for i = 1:imax
    
    %Assign new gain value to appropriate gain
    if strcmp(gain_Identifier,"PSM") == 1
        PSM = gain_Range(i);
    elseif strcmp(gain_Identifier,"VSM") == 1
        VSM = gain_Range(i);
    elseif strcmp(gain_Identifier,"PSA") == 1
        PSA = gain_Range(i);
    elseif strcmp(gain_Identifier,"VSA") == 1
        VSA = gain_Range(i);
    end
    
   for j = 1:jmax
       
       %Set up input signals
       Ip = sin(2*pi*freq_Range(j)*t);
       Iv = [0 diff(Ip)/delta_t];
       P_in = [t;Ip]';
       V_in = [t;Iv]';
       
       options = simset('SrcWorkspace','current');
       
       out = sim('CombinedModel.slx',[],options);
       sweepResults(i,j) = out;
       k = k+1;
   end

end
