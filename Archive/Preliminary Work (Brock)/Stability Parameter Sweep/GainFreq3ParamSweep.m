%This is a function that will sweep the system through two gains
%and across a range of frequencies, checking each response for stability.
%It returns a 3D array of simulation results, with rows and columns corresponding to
%gain values, and pages to frequency values.

function [sweepResults] = GainFreq3ParamSweep(gain_Identifier1,gain_Range1,...
    gain_Identifier2,gain_Range2,freq_Range,t,delta_t,sim_Set)

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

imax = size(gain_Range1,2);
jmax = size(gain_Range2,2);
kmax = size(freq_Range,2);
N = imax*jmax*kmax;

m = 1;
for i = 1:imax
    
    %Assign new gain value to appropriate gain
    if strcmp(gain_Identifier1,"PSM") == 1
        PSM = gain_Range1(i);
    elseif strcmp(gain_Identifier1,"VSM") == 1
        VSM = gain_Range1(i);
    elseif strcmp(gain_Identifier1,"PSA") == 1
        PSA = gain_Range1(i);
    elseif strcmp(gain_Identifier1,"VSA") == 1
        VSA = gain_Range1(i);
    end
    
   for j = 1:jmax    
        %Assign new gain value to appropriate gain
        if strcmp(gain_Identifier2,"PSM") == 1
            PSM = gain_Range2(j);
        elseif strcmp(gain_Identifier2,"VSM") == 1
            VSM = gain_Range2(j);
        elseif strcmp(gain_Identifier2,"PSA") == 1
            PSA = gain_Range2(j);
        elseif strcmp(gain_Identifier2,"VSA") == 1
            VSA = gain_Range2(j);
        end
        
        for k = 1:kmax
       
           %Set up input signals
           Ip = sin(2*pi*freq_Range(k)*t);
           Iv = [0 diff(Ip)/delta_t];
           P_in = [t;Ip]';
           V_in = [t;Iv]';

           options = simset('SrcWorkspace','current');

           out = sim('CombinedModel.slx',[],options);
           sweepResults(i,j,k) = out;
           m = m+1;
        end
   end
end
