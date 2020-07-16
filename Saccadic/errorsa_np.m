% Saccadic System
% No Dynamics

function e = errorsa_np(f,tau,kp,kv)
% Parameters
% Cu = 3.53e3;
% Cw = 7.47e2;
% I = 1.97e3;

% Input: [u,v]=[position,velocity]
u = [];
v = [];
t = [];
u_0 = 0;
v_0 = 1;
N_k = 2000;
ts = 0.01;
k_tau = int32(tau/ts);

for k = 1:N_k
    t(k) = k*ts;
    u(k) = sin(2*pi*f*t(k));
    v(k) = cos(2*pi*f*t(k));
end

% Deal with Delay
y = [];
for k = 1:N_k
    if k < k_tau
        y(k) = 0;
    else if k == k_tau
            y(k) = kp*u_0 + kv*v_0;
        else if mod(k,k_tau)==0
                y(k) = kp*u(k - k_tau) + kv*v(k - k_tau);
            else y(k) = y(k-1);
            end
        end
    end
end

error = abs(y-u);
e = max(error(0.5*N_k:N_k));


