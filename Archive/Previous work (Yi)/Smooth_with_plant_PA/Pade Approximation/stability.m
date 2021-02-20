function stab = stability(tau,kp,kd)

% Parameters
Cu = 3.53e3;
Cw = 7.47e2;
I = 1.97e3;

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

% Stability
stab = isstable(G_cl);

end