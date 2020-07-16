% Seperate figures tau&f

load('result_e_np.mat');
n_f = [5 15 50];
n_tau = 5;
col = [0 0.6 1; 1 0.2 1; 1 0 0];

figure('units','normalized','outerposition',[0 0 0.5 1])
for q = 1:3
% Steady State Error
temp_ess = reshape(e(n_f(q),n_tau,:,:),N_kp,N_kv);
% Plotting
s(q) = surf(kp(1:N_kp),kv(1:N_kv),temp_ess,'FaceAlpha',0.6)
shading faceted;
hold on
end

hold off

% Color
s(1).FaceColor = col(1,:)
s(2).FaceColor = col(2,:)
s(3).FaceColor = col(3,:)

% Title and Axis
title('Steady State Error of Saccadic System (without Plant)')
ylabel('VSA')
xlabel('PSA')

% Legends
legend({['f = ',num2str(f(n_f(1))),'Hz \tau = ',num2str(1000*tau(n_tau)),'ms'];
    ['f = ',num2str(f(n_f(2))),'Hz \tau = ',num2str(1000*tau(n_tau)),'ms'];
    ['f = ',num2str(f(n_f(3))),'Hz \tau = ',num2str(1000*tau(n_tau)),'ms']},'Location','northeast')

% savefig(gcf,'tau_f_np.fig')
% saveas(gcf,'tau_f_np.jpg')
% close(gcf)