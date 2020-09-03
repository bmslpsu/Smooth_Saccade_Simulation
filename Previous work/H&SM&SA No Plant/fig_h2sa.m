
clc
clear all

load('H&SM&SA.mat');

% f = 1 Hz
% tau = 40 ms

col = [0 0.6 1; 1 0 0];
e_h2sa = zeros(N_kpsa, N_kvsa);

% Minimum Steady State Error of Hybrid System
for i = 1:N_kpsa
    for j = 1:N_kvsa
        temp = reshape(e_h(i,j,:,:),N_kpsm,N_kvsm);
        e_h2sa(i,j) = min(temp,[],'all');
    end
end


% Remove Unstability
e_h2sa(e_h2sa > 5) = 5;
e_sa(e_sa > 5) = 5;

% Hybrid & Saccadic Systems
% Plotting
figure('units','normalized','outerposition',[0 0 0.5 1])
s1 = surf(kpsa,kvsa,e_h2sa','FaceAlpha',0.6);
shading faceted;
hold on
s2 = surf(kpsa,kvsa,e_sa','FaceAlpha',0.6);
hold off
% Color
s1.FaceColor = col(1,:);
s2.FaceColor = col(2,:);
% Title and Axis
title({['Hybrid System & Saccadic System (without Plant)'];['f = 1Hz \tau = 40ms']})
xlabel('PSA')
ylabel('VSA')

% Legends
legend('Hybrid (Min)','Saccadic','Location','northeast')

% savefig(gcf,'hMiin&sa_np.fig')
% saveas(gcf,'hMin&sa_np.jpg')
% close(gcf)