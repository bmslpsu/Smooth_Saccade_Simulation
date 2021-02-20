load('result_ess.mat');

n_f = 3;
n_tau = 2;

x = 1:N_kp;
y = 1:N_kd;

temp_ess = reshape(ess(n_f,n_tau,:,:),N_kp,N_kd);
temp_emax = reshape(emax(n_f,n_tau,:,:),N_kp,N_kd);
temp_eOS = (temp_emax-temp_ess)./temp_ess;

% ESS
figure(1);
surf(kd(y),kp(x),temp_ess)
colorbar
caxis([0 10])
lim = caxis;
shading interp
% view(2)
colormap('parula')
% xlim([0,10])
% ylim([0,40])

title({['Steady State Error of Smooth System'];
['f = ',num2str(f(n_f)),' Hz   \tau = ',num2str(tau(n_tau)),'s']})
xlabel('VSM')
ylabel('PSM')

saveas(1,['ess_',num2str(f(n_f)),' Hz_',num2str(tau(n_tau)),'s.fig']);
saveas(1,['ess_',num2str(f(n_f)),' Hz_',num2str(tau(n_tau)),'s.png']);

% % EMAX
% figure(2);
% surf(kd(y),kp(x),temp_emax)
% colorbar
% caxis([0 1])
% lim = caxis;
% shading interp
% view(2)
% colormap('jet')
% % xlim([0,10])
% % ylim([0,40])
% 
% 
% title({['Maximum Error of Smooth System'];
% ['f = ',num2str(f(n_f)),' Hz   \tau = ',num2str(tau(n_tau)),'s']})
% xlabel('VSM')
% ylabel('PSM')
% 
% saveas(2,['emax_',num2str(f(n_f)),' Hz_',num2str(tau(n_tau)),'s.fig']);
% saveas(2,['emax_',num2str(f(n_f)),' Hz_',num2str(tau(n_tau)),'s.png']);
% 
% % EOS
% figure(3);
% surf(kd(y),kp(x),temp_eOS)
% colorbar
% caxis([0 10])
% lim = caxis;
% shading interp
% view(2)
% colormap('jet')
% % xlim([0,10])
% % ylim([0,40])
% 
% title({['Overshoot of Smooth System'];
% ['f = ',num2str(f(n_f)),' Hz   \tau = ',num2str(tau(n_tau)),'s']})
% xlabel('VSM')
% ylabel('PSM')
% 
% % saveas(3,['eOS_',num2str(f(n_f)),' Hz_',num2str(tau(n_tau)),'s.fig']);
% % saveas(3,['eOS_',num2str(f(n_f)),' Hz_',num2str(tau(n_tau)),'s.png']);
% 
% 
