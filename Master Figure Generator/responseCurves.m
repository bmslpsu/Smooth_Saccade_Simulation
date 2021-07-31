function [pos] = responseCurves(sweepData,...
    Ki,Kp,switchThresh,sinfreqsDecimate,pureSinTime,KPsel,KIsel,sigSel,fSel)
    if all(diff([length(KPsel),length(KIsel),length(sigSel),length(fSel)]) == 0)
    else
        error('All selection vectors must be the same length')
    end


    numplots = length(KPsel);

    rowrem = rem(numplots,2);
    rowquo = (numplots-rowrem)/2;
    
    if rowrem == 1
        numrows = rowquo + 1;
    else
        numrows = rowquo;
    end
    
    
    %figure('Renderer', 'painters', 'Position', [10 10 1500 460*numrows])
    figure('Renderer', 'painters','units','inches')
    pos = get(gcf,'pos');
    set(gcf,'pos',[pos(1) pos(2) 7.25 2.22])
    pos = get(gcf,'pos');
    set(gcf, 'Color', 'w');    
    tl = tiledlayout(numrows,2, 'Padding', 'none', 'TileSpacing', 'compact');
    ticks = [-50 -25 0 25 50 ; -500 -250 0 250 500];
    for i = 1:numplots
        ax = nexttile;
        [closestKp,kpi,closestKi,kii,closestsig,sigi,closestf,freqi] = ...
            quickplot(sweepData,Ki,Kp,switchThresh,sinfreqsDecimate,pureSinTime,KPsel(i),KIsel(i),sigSel(i),fSel(i),0);
        xlim([0 2.5])
        ax.FontSize = 8;
        ax.XColor = 'k';
        ax.YColor = 'k';
        yticks(ticks(i,:))
    end
    leg = legend('Input Velocity','Hybrid Response','Continuous Response','FontName','Arial','FontSize',8,'EdgeColor','k');
    leg.Layout.Tile = 'South';
    leg.Orientation = 'Horizontal';
    xlabel(tl,'Time (s)','FontName','Arial','FontSize',10,'Color','k')
    ylabel(tl,'Angular Velocity (rad/s)','FontName','Arial','FontSize',10,'Color','k')

end