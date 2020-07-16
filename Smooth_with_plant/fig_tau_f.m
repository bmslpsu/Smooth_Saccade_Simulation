% Seperate figures f&tau

load('result_ess_f&tau.mat');
n_f = 30;
n_tau = [1 6 11];

kv = kd;
N_kv = N_kd;

col = [0 0.6 1; 1 0.2 1; 1 0 0];

figure('units','normalized','outerposition',[0 0 0.5 1])
for q = 1:3
% Steady State Error
temp_ess = reshape(ess(n_f,n_tau(q),:,:),N_kp,N_kv);
% Plotting
s(q) = surf(kp(1:N_kp),kv(1:N_kv),temp_ess','FaceAlpha',0.5);
shading faceted;
hold on
end

hold off

% Color
s(1).FaceColor = col(1,:)
s(2).FaceColor = col(2,:)
s(3).FaceColor = col(3,:)
zlim([0,20])

% Title and Axis
% title({['Steady State Error of Smooth System'];
%    ['PSA = ',num2str(kp(n_kp)),'   VSA = ',num2str(kv(n_kv))]})
title('Steady State Error of Smooth System')
ylabel('VSM')
xlabel('PSM')

% Legends
legend({['f = ',num2str(f(n_f)),'Hz \tau = ',num2str(1000*tau(n_tau(1))),'ms'];
    ['f = ',num2str(f(n_f)),'Hz \tau = ',num2str(1000*tau(n_tau(2))),'ms'];
    ['f = ',num2str(f(n_f)),'Hz \tau = ',num2str(1000*tau(n_tau(3))),'ms']},'Location','northeast')

savefig(gcf,'f_tau_np.fig')
saveas(gcf,'f_tau_np.jpg')
close(gcf)