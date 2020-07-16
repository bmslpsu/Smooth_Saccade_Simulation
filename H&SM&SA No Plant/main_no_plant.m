clc;
clear

% Parameters
kpsa = 0:0.05:2;
kvsa = 0:0.01:0.4;
kpsm = 0:0.25:10;
kvsm = 0:0.05:2;
% tau = 0.01:0.01:0.1;
% f = 0.1:0.1:5;
tau = 0.04;
f = 1;
N_kpsa = length(kpsa);
N_kvsa = length(kvsa);
N_kpsm = length(kpsm);
N_kvsm = length(kvsm);
% N_tau = length(tau);
% N_f = length(f);

% Result Saving
e_h = zeros(N_kpsa,N_kvsa,N_kpsm,N_kvsm);
e_sa = zeros(N_kpsa,N_kvsa);
e_sm = zeros(N_kpsm,N_kvsm);
% Error Cauculation
for i = 1:N_kpsa
    for j = 1:N_kvsa
        for k = 1:N_kpsm
            for l = 1:N_kvsm
                e_h(i,j,k,l) = errorh_np(f,tau,kpsa(i),kvsa(j),kpsm(k),kvsm(l));
                e_sa(i,j) = errorh_np(f,tau,kpsa(i),kvsa(j),0,0);
                e_sm(k,l) = errorh_np(f,tau,0,0,kpsm(k),kvsm(l));
            end
        end
    end
end

% Save Workspace
save('H&SM&SA_1.mat');