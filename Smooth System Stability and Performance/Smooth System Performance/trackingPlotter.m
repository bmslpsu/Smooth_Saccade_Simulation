function [tmagfull,tphasefull] = trackingPlotter(linecolors,selectedFreqIndices,trackSweep,array,titleText...
    ,sinfreqs,arrayName,selectedArrayIndices)
    tmagfull = zeros(length(selectedFreqIndices),length(array));
    tphasefull = zeros(length(selectedFreqIndices),length(array));
    figure
    for i = 1:length(selectedFreqIndices)
        %Repack data
        tmags = zeros(1,length(array));
        tphases = zeros(1,length(array));
        iter = 1;
        for j = 1:length(array)
            if trackSweep(j,selectedFreqIndices(i)).gain ~= -1
                tmags(iter) = trackSweep(j,selectedFreqIndices(i)).gain;
                tphases(iter) = trackSweep(j,selectedFreqIndices(i)).phase;
                if tphases(iter) < 0
                    %Not necessary, but makes it easier to see trends in data
                    tphases(iter) = tphases(iter) + 2*pi;
                end
                iter = iter+1;
            end
        end
        tmags = zerostrip1d(tmags);
        tphases = zerostrip1d(tphases);
        tmagfull(i,:) = tmags;
        tphasefull(i,:) = tphases;
        polarplot(tphases,tmags,'Color',cell2mat(linecolors(i)),'LineWidth',1.5) %'.-','MarkerEdgeColor','k','MarkerSize',6,
        hold on
        lgd{i} = strcat(num2str(sinfreqs(selectedFreqIndices(i))),' Hz');
    end
    legend(lgd)
    rlim([0 4])
    title(titleText)
    clear lgd
    
    figure('Renderer', 'painters', 'Position', [10 10 1000 700])
    for i = 1:length(selectedArrayIndices)
        errors = zeros(1,length(sinfreqs));
        for j = 1:length(sinfreqs)
            if trackSweep(selectedArrayIndices(i),j).error == -1
                if j == 1
                    errors(j) = 1;
                else    
                    errors(j) = trackSweep(selectedArrayIndices(i),j-1).error;
                end
            else
                errors(j) = trackSweep(selectedArrayIndices(i),j).error;
            end
        end
        plot(sinfreqs,errors)
        hold on
        lgd{i} = strcat(arrayName,' = ',num2str(array(selectedArrayIndices(i))));
    end
    legend(lgd,'FontName','Helvetica','FontSize',18,'EdgeColor','k')
    ax = gca;
    set(gcf, 'Color', 'w');
    ax.XAxis.FontSize = 18;
    ax.XAxis.FontName = 'Helvetica';
    ax.XAxis.Color = 'k';
    ax.YAxis.FontSize = 18;
    ax.YAxis.FontName = 'Helvetica';
    ax.YAxis.Color = 'k';
    xlabel('Frequency (Hz)','FontName','Helvetica','FontSize',22,'FontWeight','bold')
    ylabel('Tracking Error','FontName','Helvetica','FontSize',22,'FontWeight','bold')
end