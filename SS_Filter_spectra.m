function [ indfinal ] = SS_Filter_spectra(Storage, difference, average_length,SNR,Peak_in_centre)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[X,Y,Z]=size(Storage);
newdata=Storage;

newdata=sum(newdata,2);
newdata=reshape(newdata,X,Z);

[valma,indxma]=max(newdata);
%[valmi,indxmi]=min(newdata);

valfir = mean(newdata(1:average_length,:));
vallas = mean(newdata(end-average_length:end,:));

indr=find(abs(valfir-vallas)<difference);
indsnr=find(valma./((valfir+vallas)./2) >SNR);
indfinal=intersect(indr,indsnr);

if Peak_in_centre >0
    indpeak=find((indxma > X/2-Peak_in_centre) & (indxma < X/2+Peak_in_centre));
    indfinal=intersect(indfinal,indpeak);
end


end

