%Time
t_final = 10;
delta_t = 0.005;
t = 0:delta_t:t_final;

%Slow Signal 1: Chirp
scale = 50;
f_start_slow = 0.5;
f_end_slow = 2.5;
chirps_slow = scale*chirp(t,f_start_slow,t(end),f_end_slow,'linear',-90);
figure
plot(t,chirps_slow)

%Slow Signal 2: SoS
f_slow = [0.5 1.1 2.6];
p_slow = randi(360,length(f_slow),1,'uint32');
p_slow = deg2rad(double(p_slow));
ssscale = scale/length(f_slow);

%Make a higher resolution t vector for finding zero crossing
highdelta = 0.0000001;
t_temp = 0:highdelta:t_final;
sostemp = zeros(1,length(t_temp));
for i = 1:size(t_temp,2)
    for j = 1:length(f_slow)
        sostemp(i) = sostemp(i) + ssscale*(sin(2*pi*f_slow(j)*t_temp(i)+p_slow(j)));
    end
end
[zeroind,zerodist] = zerocross(sostemp);

t_cross = t_temp(zeroind);

%Time shifted SoS for initial value close to zero
sos_slow = zeros(1,length(t));
for i = 1:size(t,2)
    for j = 1:length(f_slow)
        sos_slow(i) = sos_slow(i) + ssscale*(sin(2*pi*f_slow(j)*(t(i)+t_cross)+p_slow(j)));
    end
end

figure
plot(t,sos_slow)

%Step input, if needed
steps = scale*ones(1,length(t));
figure
plot(t,steps)

basepath = strcat(commonPath,'\Performance Input Signals');
savePath = genFileName(basepath,'performanceInputsSlow');
save(savePath,'t','scale','f_start_slow','f_end_slow','f_slow','p_slow','chirps_slow','sos_slow','steps')
%%
%Fast Signal 1: Chirp
f_start_fast = 1;
f_end_fast = 5;
chirps_fast = scale*chirp(t,f_start_fast,t(end),f_end_fast,'linear',-90);
figure
plot(t,chirps_fast)

%Fast Signal 2: SoS
f_fast = [1 3.5 5.1];
p_fast = randi(360,length(f_fast),1,'uint32');
p_fast = deg2rad(double(p_fast));
ssscale = scale/length(f_fast);

%Make a higher resolution t vector for finding zero crossing
highdelta = 0.0000001;
t_temp = 0:highdelta:t_final;
sostemp = zeros(1,length(t_temp));
for i = 1:size(t_temp,2)
    for j = 1:length(f_fast)
        sostemp(i) = sostemp(i) + ssscale*(sin(2*pi*f_fast(j)*t_temp(i)+p_fast(j)));
    end
end
[zeroind,zerodist] = zerocross(sostemp);

t_cross = t_temp(zeroind);

%Time shifted SoS for initial value close to zero
sos_fast = zeros(1,length(t));
for i = 1:size(t,2)
    for j = 1:length(f_fast)
        sos_fast(i) = sos_fast(i) + ssscale*(sin(2*pi*f_fast(j)*(t(i)+t_cross)+p_fast(j)));
    end
end

figure
plot(t,sos_fast)

basepath = strcat(commonPath,'\Performance Input Signals');
savePath = genFileName(basepath,'performanceInputsFast');
save(savePath,'t','scale','f_start_fast','f_end_fast','f_fast','p_fast','chirps_fast','sos_fast','steps')

clearvars -except commonPath
