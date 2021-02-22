function [] = performanceSurfacePlot(error,subn,subp,i,Kp,Ki,td)
errort = zerostrip(error(:,:,i));
subplot(subn,subp,i)
sf = fit([errort(:,1),errort(:,2)],errort(:,3),'cubicinterp');
plot(sf)
xlabel('K_P')
ylabel('K_I')
zlabel('SSE')
title(['t_d = ', num2str(td(i),2)])
xlim([Kp(1) Kp(end)])
ylim([Ki(1) Ki(end)])
end