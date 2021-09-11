function [ax] = fsae2d(ftraces,saetraces,sigs,exptog)
if exptog
    ftraces = [ftraces(1,:);ftraces];
    saetraces = [saetraces(1:3,:);saetraces(3,:);saetraces(4,:)];
    sigs = [sigs(1:3) sigs(3) sigs(4)];
    colororder = ["b" "k" "m" "r" "g"];
else
    colororder = ["b" "k" "m" "g"];    
end

for i = 1:size(ftraces,1)
    dispname = strcat('\sigma = ',num2str(sigs(i)*(180/pi),'%.1f'),' deg');
    if i==4 && exptog
        dispname = strcat('\sigma = ',num2str(sigs(i)),' rad (experimental)');
        ax(i) = plot(ftraces(i,:),saetraces(i,:),'LineWidth',1.5,'DisplayName',dispname,'Color',colororder(i));  
    elseif i == size(ftraces,1)        
        ax(i) = plot(ftraces(i,:),saetraces(i,:),'LineWidth',1.5,'DisplayName',dispname,'LineStyle','--','Color',colororder(i));
    else
        ax(i) =  plot(ftraces(i,:),saetraces(i,:),'LineWidth',1.5,'DisplayName',dispname,'Color',colororder(i));
    end
    hold on
end
ax = gca;
set(gcf, 'Color', 'w');
ax.XAxis.FontSize = 8;
ax.XAxis.FontName = 'Arial';
ax.XAxis.Color = 'k';
ax.YAxis.FontSize = 8;
ax.YAxis.FontName = 'Arial'; 
ax.YAxis.Color = 'k';
ax.ZAxis.FontSize = 8;
ax.ZAxis.FontName = 'Arial';
ax.ZAxis.Color = 'k';
xlabel('f_{in} (Hz)','FontName','Arial','FontSize',8)
ylabel('SAE (deg x 10^4/s)','FontName','Arial','FontSize',8)
box on
grid on
% leg = legend('Location','NorthWest','FontName','Arial','FontSize',8,'EdgeColor','k');
ylim([0 6])
end

