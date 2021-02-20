
tao = 0.1;
g = tf(1,1,'InputDelay',tao);

for i = 1:5
    [num,den] = pade(tao,i);
    tf_pade(i) = tf(num,den);
end

step(g);
hold on
step(tf_pade(1));
step(tf_pade(2));
step(tf_pade(3));
step(tf_pade(4));
step(tf_pade(5));
title('Pade Approximation')
xlim([0,0.3])