function [closestKp,kpi,closestKi,kii,closestsig,closestf] = quickplot(sweepData,Ki,Kp,switchThresh,sinfreqsDecimate,pureSinTime,KPsel,KIsel,sigSel,fSel)
rat_I = 4.971;
[kpi,closestKp] = min(abs(Kp-KPsel*rat_I));
[kii,closestKi] = min(abs(Ki(closestKp,:)-KIsel*rat_I));
[~,closestsig] = min(abs(switchThresh-sigSel));
[~,closestf] = min(abs(sinfreqsDecimate-fSel));

fin = 50*sin((1/2*pi)*sinfreqsDecimate(closestf)*pureSinTime);
smooth = sweepData(closestKp,closestKi,closestf).smoothOut;
hybrid = sweepData(closestKp,closestKi,closestf).hybridInfo(closestsig).hybridOut';
figure
plot(pureSinTime,fin,pureSinTime,smooth,pureSinTime,hybrid)
legend
end