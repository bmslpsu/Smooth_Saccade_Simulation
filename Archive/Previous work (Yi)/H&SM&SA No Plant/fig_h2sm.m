
clc
clear all

load('H&SM&SA.mat');

% f = 1 Hz
% tau = 40 ms

col = [0 0.6 1; 1 0 0];
e_h2sm = zeros(N_kpsm, N_kvsm);

% Minimum Steady State Error of Hybrid System
for i = 1:N_kpsm
    for j = 1:N_kvsm
        temp = reshape(e_h(:,:,i,j),N_kpsa,N_kvsa);
        e_h2sm(i,j) = min(temp,[],'all');
    end
end


% Remove Unstability
e_h2sm(e_h2sm > 5) = 5;
e_sm(e_sm > 5) = 5;

% Hybrid & Smooth Systems
% Plotting
figure('units','normalized','outerposition',[0.5 0 0.5 1])
s3 = surf(kpsm,kvsm,e_h2sm','FaceAlpha',0.6);
shading faceted;
hold on
s4 = surf(kpsm,kvsm,e_sm','FaceAlpha',0.6);
hold off
% Color
s3.FaceColor = col(1,:);
s4.FaceColor = col(2,:);
% Title and Axis
title({['Hybrid System & Smooth System (without Plant)'];['f = 1Hz \tau = 40ms']})
xlabel('PSM')
ylabel('VSM')
% Legends
legend('Hybrid (Min)','Smooth','Location','northeast')

savefig(gcf,'hMin&sm_np.fig')
saveas(gcf,'hMin&sm_np.jpg')
close(gcf)