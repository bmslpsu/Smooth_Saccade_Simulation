clear;
clc;

% Load Data
load('input_p.mat');
t = Ip(1,:);
I_p = Ip(2,:);
load('input_v.mat');
I_v = Iv(2,:);
load('output_p.mat');
O_p0 = ans(2,:);
% load('output_v.mat');
% O_v = ans(2,:);


% TIME ALIGNMENT
NT = length(t);
delta_t = 0.01;
N_temp = NT/2;

for i= 1:NT
    O_p(i) = O_p0(floor(i/10+1));
end

O_v = zeros(1,NT);

% PERCENTAGE OF TRACKING ERROR
E_p = abs(I_p-O_p);
% E_v = abs(I_v-O_v);

El_pos = cumsum(E_p(1:N_temp))/cumsum(I_p(1:N_temp));
Eh_pos = cumsum(E_p(N_temp+1:2*N_temp))/cumsum(I_p(N_temp+1:2*N_temp));
% El_vel = cumsum(E_v(1:N_temp))/cumsum(I_v(1:N_temp));
% Eh_vel = cumsum(E_v(N_temp+1:2*N_temp))/cumsum(I_v(N_temp+1:2*N_temp));
El_vel = 1;
Eh_vel = 1;

% PLOT
figure('units','normalized','outerposition',[0 0 0.5 1])

subplot(3,1,1)
plot(t,E_p,'k')
xlim([0 NT*delta_t])
ylim([-1 3])
xlabel('time [sec]')
ylabel('Error')
title({'Figure E Simulink';
    ['0.5-1Hz E_{pos} = ',num2str(int16(100*El_pos)),' E_{vel} = ',num2str(int16(100*El_vel))];
    ['  1-3Hz E_{pos} = ',num2str(int16(100*Eh_pos)),' E_{vel} = ',num2str(int16(100*Eh_vel))]} )

subplot(3,1,2)
plot(t,O_p,'k')
xlim([0 NT*delta_t])
ylim([-1 3])
xlabel('time [sec]')
ylabel('Output')

subplot(3,1,3)
plot(t,I_p,'k')
xlim([0 NT*delta_t])
ylim([-1 3])
xlabel('time [sec]')
ylabel('Input')

savefig(gcf,'e_sim.fig')
saveas(gcf,'e_sim.jpg')
close(gcf)