% Seperate figures psm\vsm\psa\vsa

load('result_h_np_FT1.mat');

figure('units','normalized','outerposition',[0 0 0.5 1])

n_kpsa = [11 16 21];
n_kvsa = 11;
col = [0 0.6 1; 1 0.2 1; 1 0 0];

for q = 1:3
% Steady State Error
temp_ess = reshape(e(n_kpsa(q),n_kvsa,:,:),N_kpsm,N_kvsm);
% Remove Unstability
temp_ess(temp_ess > 5) = 5;
% Plotting
s(q) = surf(kpsm,kvsm,temp_ess','FaceAlpha',0.6);
shading faceted;
hold on

end

hold off

% Color
s(1).FaceColor = col(1,:)
s(2).FaceColor = col(2,:)
s(3).FaceColor = col(3,:)

% Title and Axis
title({['Steady State Error of Hybrid System (without Plant)'];['f = 1Hz \tau = 40ms']})
xlabel('PSM')
ylabel('VSM')
zlim([0 5])

% Legends
legend({['PSA = ',num2str(kpsa(n_kpsa(1))),' VSA = ',num2str(kvsa(n_kvsa))];
    ['PSA = ',num2str(kpsa(n_kpsa(2))),' VSA = ',num2str(kvsa(n_kvsa))];
    ['PSA = ',num2str(kpsa(n_kpsa(3))),' VSA = ',num2str(kvsa(n_kvsa))]},'Location','northeast')


savefig(gcf,'psa_vsa_np_2.fig')
saveas(gcf,'psa_vsa_np_2.jpg')
close(gcf)