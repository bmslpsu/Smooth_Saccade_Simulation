%Simple script to get the working directory in the right place for relative
%calls.  This must be in the same directory of the Combination.mlx
%livescript for proper functionality.

function [path] = DirectoryHandlerSweep
path = convertCharsToStrings(fileparts(which(mfilename)));
cd(path)
end