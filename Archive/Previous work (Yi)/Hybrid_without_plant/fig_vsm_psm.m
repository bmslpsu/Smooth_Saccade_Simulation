% Seperate figures psm\vsm\psa\vsa

load('result_h_np_FT1.mat');

figure('units','normalized','outerposition',[0 0 0.5 1])

n_kpsm = 6;
n_kvsm = [1 6 11];
col = [0 0.6 1; 1 0.2 1; 1 0 0];

for q = 1:3
% Steady State Error
temp_ess = reshape(e(:,:,n_kpsm,n_kvsm(q)),N_kpsa,N_kvsa);
% Remove Unstability
temp_ess(temp_ess > 10) = 10;
% Plotting
s(q) = surf(kpsa,kvsa,temp_ess','FaceAlpha',0.6);
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
xlabel('PSA')
ylabel('VSA')

% Legends
legend({['PSM = ',num2str(kpsm(n_kpsm)),' VSM = ',num2str(kvsm(n_kvsm(1)))];
    ['PSM = ',num2str(kpsm(n_kpsm)),' VSM = ',num2str(kvsm(n_kvsm(2)))];
    ['PSM = ',num2str(kpsm(n_kpsm)),' VSM = ',num2str(kvsm(n_kvsm(3)))]},'Location','northeast')


savefig(gcf,'vsm_psm_np.fig')
saveas(gcf,'vsm_psm_np.jpg')
close(gcf)