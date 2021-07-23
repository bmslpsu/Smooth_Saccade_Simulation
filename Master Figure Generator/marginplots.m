function [] = marginplots(mag1,phase1,wout1,Gm1,Pm1,Wcg1,Wcp1,mag2,phase2,wout2,Gm2,Pm2,Wcg2,Wcp2,...
    insetg,insetp,commonPath,eftoggle)
%figure('Renderer', 'painters', 'Position', [10 10 1500 500])
figure('Renderer', 'painters','units','inches')
pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 7.25 2.8])
pos = get(gcf,'pos');

tl = tiledlayout(2,2,'Padding','none', 'TileSpacing', 'compact');
set(gcf, 'Color', 'w');

ax = nexttile;
semilogx(wout1,20*log10(squeeze(mag1)),'LineWidth',1,'Color','b')
ylim([-60 40])
xlim([1 1e4])
yline(0,'--k')
line([Wcp1,Wcp1],[0,-60],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcg1,Wcg1],[-60,-20*log10(Gm1)],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcg1,Wcg1],[-20*log10(Gm1),0],'LineStyle','-','Color','r','LineWidth',1)
ylabel('Magnitude (dB)','FontName','Helvetica','FontSize',18,'Color','k')
ax.FontSize = 8;
ax.XColor = 'k';
ax.YColor = 'k';

ax = nexttile;
semilogx(wout2,20*log10(squeeze(mag2)),'LineWidth',1,'Color','b')
ylim([-60 40])
yline(0,'--k')
line([Wcp2,Wcp2],[0,-60],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcg2,Wcg2],[-60,-20*log10(Gm2)],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcg2,Wcg2],[-20*log10(Gm2),0],'LineStyle','-','Color','r')
rectangle('Position',insetg,'LineStyle','-','EdgeColor','k','LineWidth',0.5)
ax.FontSize = 8;
ax.XColor = 'k';
ax.YColor = 'k';

ax = nexttile;
semilogx(wout1,squeeze(phase1),'LineWidth',1,'Color','b')
ylim([0 1080])
xlim([1 1e4])
yline(900,'--k')
line([Wcg1,Wcg1],[900,1080],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcp1,Wcp1],[1080,900+Pm1],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcp1,Wcp1],[900+Pm1,900],'LineStyle','-','Color','r','LineWidth',1)
ylabel('Phase (deg)','FontName','Helvetica','FontSize',18,'Color','k')
ax.FontSize = 8;
ax.XColor = 'k';
ax.YColor = 'k';

ax = nexttile;
semilogx(wout2,squeeze(phase2),'LineWidth',1,'Color','b')
ylim([0 1080])
yline(900,'--k')
line([Wcg2,Wcg2],[900,1080],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcp2,Wcp2],[1080,900+Pm2],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcp2,Wcp2],[900+Pm2,900],'LineStyle','-','Color','r')
rectangle('Position',insetp,'LineStyle','-','EdgeColor','k','LineWidth',0.5)
ax.FontSize = 8;
ax.XColor = 'k';
ax.YColor = 'k';

xlabel(tl,'Frequency (rad/s)','FontName','Helvetica','FontSize',10,'Color','k')

basepath = strcat(commonPath,'\Golden Figures\Discussion\');
savePath = strcat(basepath,'margins','.pdf');

set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

if eftoggle == 1
    %export_fig (savePath,'-pdf','-nocrop')
    exportgraphics(gcf,savePath)
end

%figure('Renderer', 'painters', 'Position', [10 10 1500/7 500/5])
figure('Renderer', 'painters','units','inches')
pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 1.5 0.8])
pos = get(gcf,'pos');

set(gcf, 'Color', 'w');
ax = axes;
semilogx(wout2,20*log10(squeeze(mag2)),'LineWidth',1,'Color','b')
yline(0,'--k')
line([Wcp2,Wcp2],[0,-60],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcg2,Wcg2],[-60,-20*log10(Gm2)],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcg2,Wcg2],[-20*log10(Gm2),0],'LineStyle','-','Color','r','LineWidth',1)
ax.FontSize = 7;
ax.XColor = 'k';
ax.YColor = 'k';

xlim([insetg(1),insetg(1)+insetg(3)])
ylim([insetg(2),insetg(2)+insetg(4)])

basepath = strcat(commonPath,'\Golden Figures\Discussion\');
savePath = strcat(basepath,'marginsi1','.pdf');

set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

if eftoggle == 1
    %export_fig (savePath,'-pdf')%,'-nocrop')
    exportgraphics(gcf,savePath)
end

%figure('Renderer', 'painters', 'Position', [10 10 1500/7 500/5])
figure('Renderer', 'painters','units','inches')
pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 1.5 0.8])
pos = get(gcf,'pos');

set(gcf, 'Color', 'w');
ax = axes;
semilogx(wout2,squeeze(phase2),'LineWidth',1,'Color','b')
ylim([0 1080])
yline(900,'--k')
line([Wcg2,Wcg2],[900,1080],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcp2,Wcp2],[1080,900+Pm2],'LineStyle','--','Color','k','LineWidth',0.75)
line([Wcp2,Wcp2],[900+Pm2,900],'LineStyle','-','Color','r','LineWidth',1)
ax.FontSize = 7;
ax.XColor = 'k';
ax.YColor = 'k';

xlim([insetp(1),insetp(1)+insetp(3)])
ylim([insetp(2),insetp(2)+insetp(4)])
basepath = strcat(commonPath,'\Golden Figures\Discussion\');
savePath = strcat(basepath,'marginsi2','.pdf');

set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

if eftoggle == 1
    %export_fig (savePath,'-pdf')%,'-nocrop')
    exportgraphics(gcf,savePath)
end
end

