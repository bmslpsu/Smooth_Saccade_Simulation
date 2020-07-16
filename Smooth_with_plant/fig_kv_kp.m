% Seperate figures f&tau

load('result_ess_f&tau.mat');
kv = kd;
N_kv = N_kd;

n_kp = 11;
n_kv = [4 6 8];

col = [0 0.6 1; 1 0.2 1; 1 0 0];

figure('units','normalized','outerposition',[0 0 0.5 1])
for q = 1:3
% Steady State Error
temp_ess = reshape(ess(:,:,n_kp,n_kv(q)),N_f,N_tau);
% Plotting
s(q) = surf(f(1:N_f),1000*tau(1:N_tau),temp_ess','FaceAlpha',0.5);
shading faceted;
hold on
end

hold off

% Color
s(1).FaceColor = col(1,:)
s(2).FaceColor = col(2,:)
s(3).FaceColor = col(3,:)

% Title and Axis
% title({['Steady State Error of Saccadic System (without Plant)'];
%    ['PSA = ',num2str(kp(n_kp)),'   VSA = ',num2str(kv(n_kv))]})
title('Steady State Error of Smooth System')
xlabel('f / Hz')
ylabel('\tau / ms')
zlim([0 15])

% Legends
legend({['PSM ',num2str(kp(n_kp)),' VSM = ',num2str(kv(n_kv(1)))];
    ['PSM ',num2str(kp(n_kp)),' VSM = ',num2str(kv(n_kv(2)))];
    ['PSM ',num2str(kp(n_kp)),' VSM = ',num2str(kv(n_kv(3)))]},'Location','northeast')

savefig(gcf,'kv_kp.fig')
saveas(gcf,'kv_kp.jpg')
close(gcf)
