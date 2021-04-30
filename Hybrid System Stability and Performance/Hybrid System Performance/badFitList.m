function [badList,goodList,bestList,totalij,totalijk,totalijkl] = badFitList(sweepData,threshold)
    kpLength = size(sweepData,1);
    kiLength = size(sweepData,2);
    fLength = size(sweepData,3);
    stLength = length(sweepData(1,1,1).hybridInfo);
    totalij = kpLength*kiLength;
    totalijk = kpLength*kiLength*fLength;
    totalijkl = kpLength*kiLength*fLength*stLength;
    
    maxsize = totalijkl;
    badFitList = zeros(maxsize,9);
    betterList = zeros(maxsize,10);
    bestList = zeros(kpLength*kiLength*fLength,10);
    
    iterbad = 1;
    itergood = 1;
    iterbest = 1;
    for i = 1:kpLength
        for j = 1:kiLength
            for k = 1:fLength
                tempError = Inf;
                templ = 1;
                for l = 1:stLength
                    r2 = sweepData(i,j,k).hybridInfo(l).rsquare;
                    if r2 < threshold
                        badFitList(iterbad,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
                            sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(l).switchThresh l...
                            r2];
                        iterbad = iterbad + 1;
                    else
%                        if sweepData(i,j,k).sError - sweepData(i,j,k).hybridInfo(l).hError >= 0
%                             betterList(itergood,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
%                                 sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(l).switchThresh l...
%                                 sweepData(i,j,k).hybridInfo(l).hError sweepData(i,j,k).sError];
                        if sweepData(i,j,k).sSAE - sweepData(i,j,k).hybridInfo(l).hFitSAE >= 0
                            betterList(itergood,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
                                sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(l).switchThresh l...
                                sweepData(i,j,k).hybridInfo(l).hFitSAE sweepData(i,j,k).sSAE];

                            itergood = itergood + 1;
%                             if sweepData(i,j,k).hybridInfo(l).hError < tempError
%                                 tempError = sweepData(i,j,k).hybridInfo(l).hError;
                             if sweepData(i,j,k).hybridInfo(l).hFitSAE < tempError
                                 tempError = sweepData(i,j,k).hybridInfo(l).hFitSAE;
                                templ = l;
                            end
                        end
                    end
                end
                if tempError == inf
%                     bestList(iterbest,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
%                         sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(l).switchThresh l...
%                         sweepData(i,j,k).sError 0];
                    bestList(iterbest,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
                        sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(l).switchThresh l...
                        sweepData(i,j,k).sSAE 0];

                else
%                     bestList(iterbest,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
%                         sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(templ).switchThresh templ...
%                         sweepData(i,j,k).hybridInfo(l).hError 1];
                    bestList(iterbest,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
                        sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(templ).switchThresh templ...
                        sweepData(i,j,k).hybridInfo(l).hFitSAE 1];
                end
                iterbest = iterbest + 1;
            end
        end
    end
    
 badList = badFitList(1:iterbad,:);
 goodList = betterList(1:itergood,:); 
end