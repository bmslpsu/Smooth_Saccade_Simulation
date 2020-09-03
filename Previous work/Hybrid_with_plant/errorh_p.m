% Hybrid System
% No Dynamics

function e = errorh_p(f,tau,kpsa,kvsa,kpsm,kvsm)
% Parameters
Cu = 3.53e3;
Cw = 7.47e2;
I = 1.97e3;
% Plant
G_p = tf(Cu,[I Cw 0]);


% Input: [u,v]=[position,velocity]
u = [];
v = [];
t = [];
u_0 = 0;
v_0 = 1;
N_k = 5000;
ts = tau/10;
k_tau = 10;

% Time and Input
for i = 1:N_k+1
    t(i) = (i-1)*ts;
    u(i) = sin(2*pi*f*t(i));
    v(i) = cos(2*pi*f*t(i));
end

% Saccadic part of the system
y_sa_c = [];
for i = 1:N_k+1
    if i < k_tau
        y_sa_c(i) = 0;
    else if i == k_tau
            y_sa_c(i) = kpsa*u_0 + kvsa*v_0;
        else if mod(i,k_tau)==0
                y_sa_c(i) = kpsa*u(i - k_tau) + kvsa*v(i - k_tau);
            else y_sa_c(i) = y_sa_c(i-1);
            end
        end
    end
end
% Plant
y_sa = y_sa_c;

% Smooth part of the system
y_sm = [];

% Smooth Controller
G_sm_c = tf([kvsm kpsm],1);
G_tau = tf(1,1,'InputDelay',tau);
G_op = G_sm_c*G_p;

% Closed-Loop TF
G_cl = feedback(G_op,1);

% Time Response
y_sm = lsim(G_cl,u,t);

% Hybrid Output
y = y_sa + y_sm;
error = abs(y'-u);
e = max(error(0.8*N_k:N_k));
end



