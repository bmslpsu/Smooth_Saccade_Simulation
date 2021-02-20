% Smooth System with Pade Approximation
% Test

% Parameters
kp = 4;
kd = 2;
Cu = 3.53e3;
Cw = 7.47e2;
I = 1.97e3;
tau = 0.02;

% PLANT tf
G_p = tf(Cu,[I Cw 0]);

% PADE APPROXIMATION delay tf
% 3rd Order
[num,den] = pade(tau,3);
G_tao = tf(num,den);

% CONTROLLER tf
G_c = tf([kd kp],1);

% CL tf
G_cl = feedback(G_tao*G_c*G_p,1);

% Sinusoidal Signal Input
f = 0.3;
t = 0:0.001/f:10/f;
u = sin(2*pi*f*t);
plot(t,u)

% CL Response
y = lsim(G_cl,u,t);
hold on
plot(t,y)
hold off

% Tracking Error
e = abs(y-u');
figure(2)
plot(t,e)
max(e)
max(e(8001:10001))



