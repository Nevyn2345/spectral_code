function [ filelist ] = LM_filelist( folder )
%LM_FILELIST Summary of this function goes here
%   Detailed explanation goes here
    
    %slash direction
    slash=LM_osslash;
        
    files=dir(folder);

    nfiles=size(files,1);
    
    filelist=cell(nfiles,1);
    
    %filelist=cellstr(filelist);
    
    for i=1:nfiles;        
        if (not(isempty(strfind(lower(files(i).name),'tif'))))
            filelist{i}=strcat(folder, slash, files(i).name);
        end
    end
    
    filelist=filelist(cellfun('length',filelist)>0);
    
end

