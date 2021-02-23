function [tracksweepP] = trackingSim(j,cl_tf,pureSin,pureSinTime,sinfreqs,Fs,N)

    %Simulate
    sinin = pureSin(j,:);
    sinout = lsim(cl_tf,sinin,pureSinTime);

    %FRF Analysis
    ffin = fft(sinin,N);
    ffout = fft(sinout,N);
    ffindex = round(1 + sinfreqs(j)/(Fs/N));
    magratio = abs(ffout(ffindex))/abs(ffin(ffindex));
    phaseshift = angle(ffout(ffindex)) - angle(ffin(ffindex));
    compGain = magratio + phaseshift*1i;
    perfectGain = 1 + 0*1i;
    error = abs(compGain - perfectGain);
    tracksweepP.gain = magratio;
    tracksweepP.phase = phaseshift;
    tracksweepP.error = error;
    
end