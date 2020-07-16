% Seperate figures psm\vsm\psa\vsa

load('result_h_np_FT1.mat');

figure('units','normalized','outerposition',[0 0 0.5 1])

n_kpsa = 11;
n_kvsa = [6 11 21];
col = [0 0.6 1; 1 0.2 1; 1 0 0];

for q = 1:3
% Steady State Error
temp_ess = reshape(e(n_kpsa,n_kvsa(q),:,:),N_kpsm,N_kvsm);
% Remove Unstability
temp_ess(temp_ess > 5) = 5;
% Plotting
s(q) = surf(kpsm,kvsm,temp_ess,'FaceAlpha',0.6);
shading faceted;
hold on

end

hold off

% Color
s(1).FaceColor = col(1,:)
s(2).FaceColor = col(2,:)
s(3).FaceColor = col(3,:)

% Title and Axis
title({['Steady State Error of Hybrid System (with Plant)'];['f = 1Hz \tau = 40ms']})
xlabel('PSM')
ylabel('VSM')
zlim([0 5])

% Legends
legend({['PSA = ',num2str(kpsa(n_kpsa)),' VSA = ',num2str(kvsa(n_kvsa(1)))];
    ['PSA = ',num2str(kpsa(n_kpsa)),' VSA = ',num2str(kvsa(n_kvsa(2)))];
    ['PSA = ',num2str(kpsa(n_kpsa)),' VSA = ',num2str(kvsa(n_kvsa(3)))]},'Location','northeast')


savefig(gcf,'vsa_psa_p.fig')
saveas(gcf,'vsa_psa_p.jpg')
close(gcf)