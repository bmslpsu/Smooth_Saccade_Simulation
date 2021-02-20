% Seperate figures f&tau

load('result_e_np.mat');
n_kp = [21 51 81]
n_kv = 51;

figure('units','normalized','outerposition',[0 0 0.5 1])
for q = 1:3
% Steady State Error
temp_ess = reshape(e(:,:,n_kp(q),n_kv),N_f,N_tau);
% Plotting
s(q) = surf(f(1:N_f),1000*tau(1:N_tau),temp_ess','FaceAlpha',0.6)
shading faceted;
hold on
end

hold off

% Color
s(1).FaceColor = col(1,:)
s(2).FaceColor = col(2,:)
s(3).FaceColor = col(3,:)

% Title and Axis
title('Steady State Error of Saccadic System (with Plant)')
ylabel('f / Hz')
xlabel('\tau / ms')

% Legends
legend({['PSA ',num2str(kp(n_kp(1))),' VSM = ',num2str(kv(n_kv))];
    ['PSA ',num2str(kp(n_kp(2))),' VSM = ',num2str(kv(n_kv))];
    ['PSA ',num2str(kp(n_kp(3))),' VSM = ',num2str(kv(n_kv))]},'Location','northeast')

% savefig(gcf,'kv_kp_np.fig')
% saveas(gcf,'kv_kp_np.jpg')
% close(gcf)
