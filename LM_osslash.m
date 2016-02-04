function [ slash ] = LM_osslash()
%LM_OSSLASH Summary of this function goes here
%   Detailed explanation goes here

    %gets path delimiting slash character for current operating system
    if (strcmp(getenv('os'),'Windows_NT')==1)
        slash='\';
    else
        slash='/';
    end


end

