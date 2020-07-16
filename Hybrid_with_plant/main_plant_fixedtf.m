clc;
clear

% Parameters
kpsa = 0:0.2:2;
kvsa = 0:0.01:0.1;
kpsm = 0:0.1:1;
kvsm = 0:0.02:0.2;
tau = 0.02;
f = 5;
N_kpsa = length(kpsa);
N_kvsa = length(kvsa);
N_kpsm = length(kpsm);
N_kvsm = length(kvsm);
% N_tau = length(tau);
% N_f = length(f);

% Result Saving
e = zeros(N_kpsa,N_kvsa,N_kpsm,N_kvsm);


% Tracking Error
for i = 1:N_kpsa
    for j = 1:N_kvsa
        for k = 1:N_kpsm
            for l = 1:N_kvsm
                e(i,j,k,l) = errorh_p(f,tau,kpsa(i),kvsa(j),kpsm(k),kvsm(l));
            end
        end
    end
end


% Save Workspace
save('result_h_p_1Hz-40ms.mat');