function [sweepData] = reconstruct(Kp,Ki,sinfreqsDecimate,hybridOut,hFit,hGain,hPhase,hError,...
    smoothOut,sGain,sPhase,sError)

timeLength = size(hybridOut,5);
kpLength = size(hybridOut,1);
kiLength = size(hybridOut,2);
fLength = size(hybridOut,3);
stLength = size(hybridOut,4);


emptyarray = -1000*ones(1,timeLength);
hybridStruct = repmat(struct('switchThresh',-1,'hybridOut',emptyarray,'hFit',emptyarray,'hGain',-1,'hPhase',-1,'hError',-1),...
    1,stLength);
fullStruct = struct('Kp',-1,'Ki',-1,'inputFreq',-1,'smoothOut',emptyarray,'sGain',-1,'sPhase',-1,'sError',-1,...
    'hybridInfo',hybridStruct);
sweepData = repmat(fullStruct,kpLength,kiLength,fLength);

for i = 1:kpLength
    for j = 1:kiLength
        for k = 1:fLength
            sweepData(i,j,k).Kp = Kp(i);
            sweepData(i,j,k).Ki = Ki(j);
            sweepData(i,j,k).inputFreq = sinfreqsDecimate(k);
            sweepData(i,j,k).smoothOut = squeeze(smoothOut(i,j,k,:));
            sweepData(i,j,k).sGain = sGain(i,j,k);
            sweepData(i,j,k).sPhase = sPhase(i,j,k);
            sweepData(i,j,k).sError = sError(i,j,k);
            
            for l = 1:stLength
                sweepData(i,j,k).hybridInfo(l).hybridOut = squeeze(hybridOut(i,j,k,l,:));
                sweepData(i,j,k).hybridInfo(l).hFit = squeeze(hFit(i,j,k,l,:));
                sweepData(i,j,k).hybridInfo(l).hGain = hGain(i,j,k,l);
                sweepData(i,j,k).hybridInfo(l).hPhase = hPhase(i,j,k,l);
                sweepData(i,j,k).hybridInfo(l).hError = hError(i,j,k,l);
            end
        end
    end
end




end