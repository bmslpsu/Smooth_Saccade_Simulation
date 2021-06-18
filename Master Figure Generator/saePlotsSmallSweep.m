function [] = saePlotsSmallSweep(sweepData,Kp,Ki,flag,commonPath)
figure('Renderer', 'painters', 'Position', [10 10 1200 425])
tl = tiledlayout(1,2, 'Padding', 'none', 'TileSpacing', 'compact');
rat_I = 4.971;

nexttile
slicePath = strcat(commonPath,'\Stability Sweep Data\');
latestSlice = latestTimeParse(slicePath,'04DelaySlice');
load(latestSlice)
clear slicePath latestSlice
xdata = stableSliceMax(:,1)/rat_I;
ydata = stableSliceMax(:,2)/rat_I;

plot(xdata,ydata,'k')
hold on
if length(Kp) == 1
    Kp = repmat(Kp,1,length(Ki));
end
plot(Kp,Ki,'.-k')

ax = gca;
set(gcf, 'Color', 'w');
ax.XAxis.FontSize = 18;
ax.XAxis.FontName = 'Helvetica';
ax.XAxis.Color = 'k';
ax.YAxis.FontSize = 18;
ax.YAxis.FontName = 'Helvetica';
ax.YAxis.Color = 'k';
xlabel('K_P','FontName','Helvetica','FontSize',20,'Color','k')
ylabel('K_I','FontName','Helvetica','FontSize',20,'Color','k')

for i=1:size(sweepData,2)
    sinfreqs(i) = sweepData(1,i).inputFreq;
end

nexttile
if strcmp(flag,'i')
    sigma = zeros(length(sweepData(1,1,1).hybridInfo),length(Kp));
    sae = zeros(length(sweepData(1,1,1).hybridInfo),length(Kp));
    for i = 1:length(sweepData(1,1,1).hybridInfo)

        for j = 1:length(Kp)
            sigma(i,j) = sweepData(j,1,1).hybridInfo(i).switchThresh;

            saeTemp = 0;
            for k = 1:size(sweepData,3)
                saeTemp = saeTemp + sweepData(j,1,k).hybridInfo(i).hSAE;
            end
            sae(i,j) = saeTemp;
        end
    end

    for j =1:length(sinfreqs)
        plot(sigma(:,j),sae(:,j),'DisplayName',strcat('K_{p} =',num2str(Kp(j))))
        hold on
    end
    lim = [0 15];    
elseif strcmp(flag,'p')
    sigma = zeros(length(sweepData(1,1).hybridInfo),length(Ki));
    sae = zeros(length(sweepData(1,1).hybridInfo),length(Ki));
    for i = 1:length(sweepData(1,1).hybridInfo)

        for j = 1:length(Ki)
            sigma(i,j) = sweepData(j,1).hybridInfo(i).switchThresh;

            saeTemp = 0;
            for k = 1:size(sweepData,2)
                saeTemp = saeTemp + sweepData(j,k).hybridInfo(i).hSAE;
            end
            sae(i,j) = saeTemp;
        end
    end

    for j =1:length(sinfreqs)
        plot(sigma(:,j),sae(:,j),'DisplayName',strcat('K_{i} =',num2str(Ki(j))))
        hold on
    end   
    lim = [0 15];
end
lgd = legend('NumColumns',2);
lgd.FontSize = 11;
ax = gca;
set(gcf, 'Color', 'w');
ax.XAxis.FontSize = 18;
ax.XAxis.FontName = 'Helvetica';
ax.XAxis.Color = 'k';
ax.YAxis.FontSize = 18;
ax.YAxis.FontName = 'Helvetica';
ax.YAxis.Color = 'k';
xlabel('\sigma (rad)','FontName','Helvetica','FontSize',20,'Color','k')
ylabel('SAE (rad/s)','FontName','Helvetica','FontSize',20,'Color','k')
grid on
grid minor
xlim(lim)
ylim([0 2.5e5])

end