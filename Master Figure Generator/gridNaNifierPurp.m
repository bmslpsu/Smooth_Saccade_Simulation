function [gout] = gridNaNifierPurp(gin,gx,gy,cx,cy,radius)

%NaNify
xcheck = false;
ycheck = false;
for i = 1:length(cx)
    for k = 1:length(gx)
        for m = 1:length(gy)
            if abs(cx(i)-gx(k)) < radius
                if abs(cy(i)-gy(m)) < radius
                    gin(m,k) = 6;
                end
            end
        end
    end
    

end
k=1;
gout = gin;            

end