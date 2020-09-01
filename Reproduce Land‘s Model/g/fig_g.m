% SMOOTH SYSTEM
% FIGURE G
% PSA = 1   VSA = 5   VSM = 0.8   

clc;
clear all;

% TIME & INPUT
% POSITION INPUT
N_temp = 534;
delta_t = 0.01;
t = 0:delta_t:2*N_temp*delta_t;
NT = 2*N_temp;
t1 = 0:delta_t:N_temp*delta_t;
I_p(1:N_temp+1) = -chirp(t1,0.5,N_temp*delta_t,1)+1;
I_p(N_temp+1:2*N_temp+1) = -chirp(t1,1,N_temp*delta_t,3)+1;
% VELOCITY INPUT
I_v = diff(I_p)/delta_t;
% TIME ALIGNMENT
I_p = I_p(1:NT);
t = t(1:NT);

% PARAMETERS
psm = 0;
vsm = 0.8;
psa = 1;
vsa = 0.05;
d = 0.1;
Nd = d/delta_t;

O_p = [];
O_v = [];
Osa_p = [];
Osa_v = [];
Osm_p = [];
Osm_v = [];

% SACCADIC SYSTEM
% TIME DIFFERENCE EQUATION
for i = 1:NT
    if i<=Nd
        Osa_p(i) = 0;
        Osa_v(i) = 0;
    else
        if mod(i,Nd)==0
            Osa_p(i) = psa*I_p(i-Nd) + vsa*I_v(i-Nd);
            Osa_v(i) = (Osa_p(i) - Osa_p(i-1))/delta_t;
        else
            Osa_p(i) = Osa_p(i-1);
            Osa_v(i) = (Osa_p(i) - Osa_p(i-1))/delta_t;
        end
    end
end

% SMOOTH SYSTEM
% TIME DIFFERENCE EQUATION
for i = 1:NT
    if i<=Nd 
        Osm_p(i) = 0;
        Osm_v(i) = 0;
    else
        Osm_p(i) = Osm_p(i-1) + psm*(I_p(i-Nd)-Osm_p(i-Nd))*delta_t + vsm*(I_v(i-Nd)-Osm_v(i-Nd))*delta_t;
        Osm_v(i) = (Osm_p(i)-Osm_p(i-1))/delta_t;
    end
end

% FINAL RESULT
O_p = Osm_p + Osa_p/2;
O_v = Osm_v;

% PERCENTAGE OF TRACKING ERROR
E_p = abs(I_p-O_p);
E_v = abs(I_v-O_v);

El_pos = cumsum(E_p(1:N_temp))/cumsum(I_p(1:N_temp));
Eh_pos = cumsum(E_p(N_temp+1:2*N_temp))/cumsum(I_p(N_temp+1:2*N_temp));
El_vel = cumsum(E_v(1:N_temp))/cumsum(abs(I_v(1:N_temp)));
Eh_vel = cumsum(E_v(N_temp+1:2*N_temp))/cumsum(abs(I_v(N_temp+1:2*N_temp)));

g_O_p = O_p;
g_E_p = E_p;
save('g_diff_data.mat','g_O_p','g_E_p');


% PLOT
figure('units','normalized','outerposition',[0 0 0.5 1])

subplot(3,1,1)
plot(t,E_p,'k')
xlim([0 NT*delta_t])
ylim([-1 3])
xlabel('time [sec]')
ylabel('Error')
title({'Figure G';
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

savefig(gcf,'g.fig')
saveas(gcf,'g.jpg')
close(gcf)