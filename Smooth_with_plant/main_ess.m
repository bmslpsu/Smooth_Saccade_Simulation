clc;
clear

% Parameters
kp = 0:2:30;
kd = 0:1:10;
tau = 0.:0.01:0.1;
f = 0.1:0.1:10;
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
save('result_ess_f&tau.mat');



