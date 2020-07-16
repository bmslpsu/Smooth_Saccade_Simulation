clc;
clear

% Parameters
kpsa = 0:0.1:2;
kvsa = 0:0.01:0.2;
kpsm = 0:0.5:10;
kvsm = 0:0.1:2;
tau = 0.04;
f = 1;
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
                e(i,j,k,l) = errorh_np(f,tau,kpsa(i),kvsa(j),kpsm(k),kvsm(l));
            end
        end
    end
end


% Save Workspace
save('result_h_np_FT1.mat');