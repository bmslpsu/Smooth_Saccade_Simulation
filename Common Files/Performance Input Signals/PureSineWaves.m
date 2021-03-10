scale = 50;
pureSinTime = 0:0.005:5;
sinfreqs = 0.1:0.1:5; %Hz
pureSin = zeros(length(sinfreqs),length(pureSinTime));
for i = 1:length(sinfreqs)
    for j = 1:length(pureSinTime)
        pureSin(i,j) = scale*sin(2*pi*sinfreqs(i)*pureSinTime(j));
    end
end

figure
plot(pureSinTime,pureSin(1,:),pureSinTime,pureSin(end,:),pureSinTime,pureSin(round(end/2),:))


basepath = strcat(commonPath,'\Performance Input Signals');
savePath = genFileName(basepath,'pureSin');
save(savePath,'scale','pureSinTime','pureSin','sinfreqs')              
clearvars -except commonPath