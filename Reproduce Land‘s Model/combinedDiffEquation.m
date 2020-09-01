function [pout,vout] = combinedDiffEquation(psm,vsm,psa,vsa,delay,...
    PSM_sat_up,PSM_sat_low,VSM_sat_up,VSM_sat_low,PSA_sat_up,PSA_sat_low,...
    VSA_sat_up,VSA_sat_low,vout_up,vout_low,NT,I_p,I_v,delta_t,divisor)

Nd = delay/delta_t;

Osm_p = zeros(1,NT);
Osm_v = zeros(1,NT);
Osa_p = zeros(1,NT);
Osa_v = zeros(1,NT);

%Smooth Component
for i = 1:NT
    if i<=Nd 
        Osm_p(i) = 0;
        Osm_v(i) = 0;
    else
        PSM_branch = coerce(psm*(I_p(i-Nd)-Osm_p(i-Nd)),...
            PSM_sat_up,PSM_sat_low);
        VSM_branch = coerce(vsm*(I_v(i-Nd)-Osm_v(i-Nd)),...
            VSM_sat_up,VSM_sat_low);
        
        Osm_p(i) = Osm_p(i-1) + ...
            coerce(PSM_branch + VSM_branch,vout_up,vout_low)*delta_t;
        Osm_v(i) = coerce((Osm_p(i)-Osm_p(i-1))/delta_t,vout_up,vout_low);
    end
end

%Saccadic Component
for i = 1:NT
    if i<=Nd
        Osa_p(i) = 0;
        Osa_v(i) = 0;
    else
        if mod(i,Nd)==0
            Osa_p(i) = psa*I_p(i-Nd) + vsa*I_v(i-Nd);
            Osa_v(i) = (Osa_p(i) - Osa_p(i-1))/delta_t;
        else
            Osa_p(i) = Osa_p(i-1);
            Osa_v(i) = (Osa_p(i) - Osa_p(i-1))/delta_t;
        end
    end
end

% FINAL RESULT
pout = Osm_p + Osa_p/divisor;
vout = Osm_v;

end