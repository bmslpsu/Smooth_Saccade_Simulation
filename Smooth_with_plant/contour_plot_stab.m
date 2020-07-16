load('result_stab.mat');

x = 1:N_kp;
y = 1:N_kd;

hold on
temp = reshape(result(1,:,:),N_kp,N_kd);
contour(kd(y),kp(x),temp(x,y),[1,1],'k');
temp = reshape(result(2,:,:),N_kp,N_kd);
contour(kd(y),kp(x),temp(x,y),[1,1],'m');
temp = reshape(result(3,:,:),N_kp,N_kd);
contour(kd(y),kp(x),temp(x,y),[1,1],'b');
temp = reshape(result(4,:,:),N_kp,N_kd);
contour(kd(y),kp(x),temp(x,y),[1,1],'c');
temp = reshape(result(5,:,:),N_kp,N_kd);
contour(kd(y),kp(x),temp(x,y),[1,1],'g');

title('Stability of Smooth System with Pade Approximation')
xlim([0 27])
xlabel('VSM')
ylabel('PSM')