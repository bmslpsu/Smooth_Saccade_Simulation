function [index,distance] = zerocross(array)
    sizes = size(array);
    direction = 1;
    if sizes(1) == 1
        direction = 2;
    end
    
    valold = array(1);
    for i = 1:sizes(direction)
        valnew = array(i);
        
        if sign(valnew) ~= sign(valold)
            if abs(valnew) > abs(valold)
                index = i-1;
            else
                index = i;
            end
            break
        else
        end
        valold = array(i);
    end
    distance = abs(array(i));
end