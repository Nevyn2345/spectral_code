function [ out ] = SS_Xcorr_fit( storage,fitdata,interpo,division_number )
%fitdata is a prebuilt spectra from a workspace
%   Detailed explanation goes here
number_points=size(storage,3);

parfor k=1:number_points
%   for k=1:number_points 

    %out(k,:)=xcorr(fitdata,sum(storage(:,:,k),2));
    %baseline to zero
    fitdatat=fitdata-min(fitdata);
    tempdata=sum(storage(:,:,k),2)-min(sum(storage(:,:,k),2));
    %scale fitdata to be the same height as input spectra
    fitdatat=fitdatat*(max(tempdata)./max(fitdatat));

    if interpo==1
        xf=1:length(fitdatat);
        xqf=1:1/division_number:length(fitdatat);
        vf=fitdatat;
        vqf = interp1(xf,vf,xqf,'spline'); %Interpolate to get same points as fitdata
        fitdatat=vqf;

        xd=1:length(tempdata);
        xqd=1:0.1:length(tempdata);
        vd=tempdata;
        vqd = interp1(xd,vd,xqd,'spline');
        tempdata=vqd;

    end

    out(k,:)=xcorr(fitdatat,tempdata);

end

end

