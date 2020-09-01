function [coercedNum] = coerce(Num,upper,lower)
if Num > upper
    coercedNum = upper;
elseif Num < lower
    coercedNum = lower;
else
    coercedNum = Num;
end
end