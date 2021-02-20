%This script is a modification of the isstable function.  It returns true
%if all the poles are in the LHP OR on the imaginary axis.  This is
%different from the original function, which returns true only if all poles
%are in the LHP (imaginary axis considered unstable).

function stab = isstablemod(tf)
    p = pole(tf);
    
    for i = 1:size(p,1) %for each pole
        if real(p(i)) <= 0
            stab = 1;
        else
            stab = 0;
            break
        end
    end
   
end