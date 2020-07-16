clc;
clear

% Parameters
kp = 0:0.1:60;
kd = 0:0.1:30;
tau = 0.02;
f = 0.5;
N_kp = length(kp);
N_kd = length(kd);
N_tau = length(tau);
N_f = length(f);

% Result Saving
ess = zeros(N_f,N_tau,N_kp,N_kd);
emax = zeros(N_f,N_tau,N_kp,N_kd);

% Stability Confirmation
for i = 1:N_f
    for j = 1:N_tau
        for k = 1:N_kp
            for m = 1:N_kd
                [ess(i,j,k,m),emax(i,j,k,m)] = errors(f(i),tau(j),kp(k),kd(m));
            end
        end
    end
end


% Save Workspace
save('result_ess_kp&kd.mat');



