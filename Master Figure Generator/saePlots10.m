function [] = saePlots10(sweepData)

%Pull out error data at Kp = 10, Ki = 0 for all 6 frequencies
for i=1:size(sweepData,2)
    sinfreqs(i) = sweepData(1,i).inputFreq;
end

sigma = zeros(length(sweepData(1,1).hybridInfo),length(sinfreqs));
sae = zeros(length(sweepData(1,1).hybridInfo),length(sinfreqs));
for i = 1:length(sweepData(1,1).hybridInfo)
    for j = 1:length(sinfreqs)
        sigma(i,j) = sweepData(1,j).hybridInfo(i).switchThresh;
        sae(i,j) = sweepData(1,j).hybridInfo(i).hSAE;
    end
end

figure('Renderer', 'painters', 'Position', [10 10 1000 700])

for j =1:length(sinfreqs)
    plot(sigma(:,j),sae(:,j),'DisplayName',strcat('f_{in} =',num2str(sinfreqs(j)),' Hz'))
    hold on
end
plot(sigma(:,1),sum(sae,2)','DisplayName',strcat('Sum of all f_{in}'))
lgd = legend('NumColumns',2);
lgd.FontSize = 14;
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
xlim([0 15])
ylim([0 2.5e5])

end