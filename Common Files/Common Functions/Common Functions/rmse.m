function [rmse] = rmse(in,out)
    assert(length(in) == length(out),'Vectors must be the same size');
    
    (out - in)
    for i = length(in)
       err2 = (out(i)-in(i))^2;
       
    end
end