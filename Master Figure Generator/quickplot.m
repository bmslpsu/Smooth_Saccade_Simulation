function [closestKp,kpi,closestKi,kii,closestsig,sigi,closestf,freqi] = quickplot(sweepData,Ki,Kp,switchThresh,sinfreqsDecimate,pureSinTime,KPsel,KIsel,sigSel,fSel,sae)
[kpi,closestKp] = min(abs(Kp-KPsel));
[kii,closestKi] = min(abs(Ki(closestKp,:)-KIsel));
[sigi,closestsig] = min(abs(switchThresh-sigSel));
[freqi,closestf] = min(abs(sinfreqsDecimate-fSel));
r2deg = 180/pi;

fin = 50*sin(2*pi*sinfreqsDecimate(closestf)*pureSinTime);
smooth = sweepData(closestKp,closestKi,closestf).smoothOut.*r2deg;
hybrid = sweepData(closestKp,closestKi,closestf).hybridInfo(closestsig).hybridOut'.*r2deg;
plot(pureSinTime,fin,'k')
hold on
plot(pureSinTime,hybrid,'b','LineWidth',1)
plot(pureSinTime,smooth,'m','LineWidth',1)
grid on
ax = gca;
ax.XAxis.FontSize = 8;
ax.XAxis.FontName = 'Arial';
ax.XAxis.Color = 'k';
ax.YAxis.FontSize = 8;
ax.YAxis.FontName = 'Arial';
ax.YAxis.Color = 'k';

if sae
    title({strcat('sSAE = ',num2str(sweepData(closestKp,closestKi,closestf).sSAE))...
        strcat('hSAE = ',num2str(sweepData(closestKp,closestKi,closestf).hybridInfo(closestsig).hSAE))})
end
end