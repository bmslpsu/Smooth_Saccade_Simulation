% Hybrid System
% No Dynamics

function e = errorh_np(f,tau,kpsa,kvsa,kpsm,kvsm)
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
N_k = 1000;
ts = tau/10;
k_tau = 10;

for i = 1:N_k
    t(i) = i*ts;
    u(i) = sin(2*pi*f*t(i));
    v(i) = cos(2*pi*f*t(i));
end

% Saccadic part of the system
y_sa = [];
for i = 1:N_k
    if i < k_tau
        y_sa(i) = 0;
    else if i == k_tau
            y_sa(i) = kpsa*u_0 + kvsa*v_0;
        else if mod(i,k_tau)==0
                y_sa(i) = kpsa*u(i - k_tau) + kvsa*v(i - k_tau);
            else y_sa(i) = y_sa(i-1);
            end
        end
    end
end

% Smooth part of the system
y_sm = [];
v_sm = [];
% TIME DIFFERENCE EQUATION
for i = 1:N_k
    if i<=k_tau 
        y_sm(i) = 0;
        v_sm(i) = 0;
    else
        y_sm(i) = y_sm(i-1) + kpsm*(u(i-k_tau)-y_sm(i-k_tau))*ts + kvsm*(v(i-k_tau)-v_sm(i-k_tau))*ts;
        v_sm(i) = (y_sm(i)-y_sm(i-1))/ts;
    end
end
% Hybrid Output
y = y_sa + y_sm;
% 
% figure
% plot(t,y)
% hold on
% plot(t,u)
% plot(t,y_sm)
% plot(t,y_sa)
% xlim([N_k*ts-500*ts N_k*ts])
% % xlim([0,500*ts])
% legend('Output','Input','Smooth','Saccadic')

% Hybrid Output
y = y_sa + y_sm;
error = abs(y-u);
e = max(error(0.5*N_k:N_k));


