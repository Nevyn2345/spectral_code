function [ Transformed ] = ApplyTranform( coordinates,A,B )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
temp=A*coordinates'+B;
Transformed=temp';

end


