function [ new_centres ] = transformcent( A,B,centresx,centresy )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i=1:length(centresx)
    temp(1)=centresx(i);
    temp(2)=centresy(i);
    test=A*temp'+B;
    new_centres(i,1)=test(1);
    new_centres(i,2)=test(2);
end

