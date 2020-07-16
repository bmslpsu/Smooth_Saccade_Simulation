clc;
clear

% Parameters
kp = 0:0.1:60;
kd = 0:0.1:30;
tau = 0.02:0.02:0.1;
N_kp = length(kp);
N_kd = length(kd);
N_tau = length(tau);

% Result Saving
result = zeros(N_tau,N_kp,N_kd);

% Stability Confirmation
for j = 1:N_tau
    for k = 1:N_kp
        for m = 1:N_kd
            result(j,k,m) = stability(tau(j),kp(k),kd(m));
        end
    end
end

% Save Workspace
save('result_stab.mat');

