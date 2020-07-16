% Seperate figures psm\vsm\psa\vsa
clc
clear all

load('H&SM&SA.mat');

% f = 1 Hz
% tau = 40 ms
n_kpsa = 21;
n_kvsa = 6;
n_kpsm = 1;
n_kvsm = 9;

col = [0 0.6 1; 1 0 0];

% Steady State Error
e_h2sa= reshape(e_h(:,:,n_kpsm,n_kvsm),N_kpsa,N_kvsa);
e_h2sm= reshape(e_h(n_kpsa,n_kvsa,:,:),N_kpsm,N_kvsm);

% Remove Unstability
e_h2sa(e_h2sa > 5) = 5;
e_h2sm(e_h2sm > 5) = 5;
e_sm(e_sm > 5) = 5;

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
title({['Hybrid System & Saccadic System (without Plant)'];['f = 1Hz \tau = 40ms'];
    ['PSA = ',num2str(kpsm(n_kpsm)),'  VSM = ',num2str(kvsm(n_kvsm)),'  PSA = ',num2str(kpsa(n_kpsa)),'  VSA = ',num2str(kvsa(n_kvsa))]})
xlabel('PSA')
ylabel('VSA')

% Legends
legend('Hybrid','Saccadic','Location','northeast')
savefig(gcf,'h&sa_np.fig')
saveas(gcf,'h&sa_np.jpg')
close(gcf)

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
title({['Hybrid System & Smooth System (without Plant)'];['f = 1Hz \tau = 40ms'];
    ['PSA = ',num2str(kpsm(n_kpsm)),'  VSM = ',num2str(kvsm(n_kvsm)),'  PSA = ',num2str(kpsa(n_kpsa)),'  VSA = ',num2str(kvsa(n_kvsa))]})
xlabel('PSM')
ylabel('VSM')
% Legends
legend('Hybrid','Smooth','Location','northeast')

savefig(gcf,'h&sm_np.fig')
saveas(gcf,'h&sm_np.jpg')
close(gcf)