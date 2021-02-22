function [tmags,tphases] = trackingPlotter(linecolors,selectedFreqIndices,trackSweep,array,titleText...
    ,sinfreqs)
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
        polarplot(tphases,tmags,'.-','MarkerEdgeColor','k','MarkerSize',6,'Color',cell2mat(linecolors(i)),'LineWidth',1.5)
        hold on
        lgd{i} = strcat(num2str(sinfreqs(selectedFreqIndices(i))),' Hz');
    end
    legend(lgd)
    rlim([0 4])
    title(titleText)

end