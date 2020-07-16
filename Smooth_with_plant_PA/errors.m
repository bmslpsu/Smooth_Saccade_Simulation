function [e_ss,e_max] = errors(f,tau,kp,kd)

% Parameters
Cu = 3.53e3;
Cw = 7.47e2;
I = 1.97e3;

% PLANT tf
G_p = tf(Cu,[I Cw 0]);

% PADE APPROXIMATION delay tf
% 3rd Order
[num,den] = pade(tau,3);
G_tau = tf(num,den);

% CONTROLLER tf
G_c = tf([kd kp],1);

% CL tf
G_cl = feedback(G_tau*G_c*G_p,1);

% Stability Check
if isstable(G_cl)==0 
    e_max = 100;
    e_ss = 100;
    return
end

% Sinusoidal Signal Input
t = 0:0.001/f:10/f;
u = sin(2*pi*f*t);

% CL Response
y = lsim(G_cl,u,t);

% Tracking Error
e = abs(y-u');
e_max = max(e);
e_ss = max(e(8001:10001));
end
