function [ Spectra_out ] = SS_remove_background( Spectra_in )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Spectra_out = zeros(size(Spectra_in,1),size(Spectra_in,2),size(Spectra_in,3));

for K=1:size(Spectra_in,3)
    Spectra_out(:,:,K)=Spectra_in(:,:,K)-min(min(Spectra_in(:,:,K)));
end

