function [padenum,padeden] = padeWrap(td)

%This is a simple wrapper for the pade delay function to ensure order
%consistency over multiple scripts.

    order = 5;
    [padenum,padeden] = pade(td,order);
end
