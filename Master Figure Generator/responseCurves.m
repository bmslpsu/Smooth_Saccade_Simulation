%This function creates a grid of plots for a chosen number of sampling
%points from the hybrid performance data
function [pos] = responseCurves(sweepData,...
    Ki,Kp,switchThresh,sinfreqsDecimate,pureSinTime,KPsel,KIsel,sigSel,fSel)

    %Error catch
    if all(diff([length(KPsel),length(KIsel),length(sigSel),length(fSel)]) == 0)
    else
        error('All selection vectors must be the same length')
    end

    %Calculating grid parameters
    numplots = length(KPsel);

    rowrem = rem(numplots,2);
    rowquo = (numplots-rowrem)/2;
    
    if rowrem == 1
        numrows = rowquo + 1;
    else
        numrows = rowquo;
    end
    
    
    figure('Renderer', 'painters','units','inches')
    pos = get(gcf,'pos');
    set(gcf,'pos',[pos(1) pos(2) 7.25 2.22])
    pos = get(gcf,'pos');
    set(gcf, 'Color', 'w');    
    tl = tiledlayout(numrows,2, 'Padding', 'none', 'TileSpacing', 'compact');
    ticks = [-60 -30 0 30 60 ; -200 -100 0 100 200];
    ylims = [-60 60 ; -200 200];
    %Create plots
    for i = 1:numplots
        ax = nexttile;
        [~] = ...
            quickplot(sweepData,Ki,Kp,switchThresh,sinfreqsDecimate,pureSinTime,KPsel(i),KIsel(i),sigSel(i),fSel(i),0);
        xlim([0 1])
        ylim(ylims(i,:))
        ax.FontSize = 8;
        ax.XColor = 'k';
        ax.YColor = 'k';
        yticks(ticks(i,:))
    end
    leg = legend('Input Velocity','Hybrid Response','Continuous Response','FontName','Arial','FontSize',8,'EdgeColor','k');
    leg.Layout.Tile = 'South';
    leg.Orientation = 'Horizontal';
    xlabel(tl,'Time (s)','FontName','Arial','FontSize',10,'Color','k')
    ylabel(tl,'Angular Velocity (deg/s)','FontName','Arial','FontSize',10,'Color','k')

end