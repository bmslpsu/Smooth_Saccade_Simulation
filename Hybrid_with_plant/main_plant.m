clc;
clear

% Parameters
kpsa = 1;
kvsa = 0.05;
kpsm = 0;
kvsm = 0.8;
tau = 0.01:0.01:0.1;
f = 0.1:0.1:5;
% N_kpsa = length(kpsa);
% N_kvsa = length(kvsa);
% N_kpsm = length(kpsm);
% N_kvsm = length(kvsm);
N_tau = length(tau);
N_f = length(f);

% Result Saving
e = zeros(N_f,N_tau);


% Stability Confirmation
for i = 1:N_f
    for j = 1:N_tau
        e(i,j) = errorh_np(f(i),tau(j),kpsa,kvsa,kpsm,kvsm);
    end
end


% Save Workspace
save('result_h_np_G2.mat');