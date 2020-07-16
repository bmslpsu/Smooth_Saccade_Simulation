clc;
clear

% Parameters
kp = 0:0.1:2;
kv = 0:0.01:0.2;
tau = 0.01:0.01:0.1;
f = 0.1:0.1:5;
N_kp = length(kp);
N_kv = length(kv);
N_tau = length(tau);
N_f = length(f);

% Result Saving
e = zeros(N_f,N_tau,N_kp,N_kv);


% Stability Confirmation
for i = 1:N_f
    for j = 1:N_tau
        for h = 1:N_kp
            for m = 1:N_kv
                e(i,j,h,m) = errorsa_np(f(i),tau(j),kp(h),kv(m));
            end
        end
    end
end


% Save Workspace
save('result_e_np.mat');