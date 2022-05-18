function [strippedArray] = zerostrip(originalArray)

strippedArray = flip(originalArray);
flag = 1;
while flag == 1
    if strippedArray(1,:) == [0 0]
        strippedArray = strippedArray(2:end,:);
    else
        flag = 0;
    end
end
end