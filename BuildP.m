function [ P ] = BuildP( coords )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

P(1,:)=[coords(1,1),coords(1,2),0,0,1,0];

P(2,:)=[0,0,coords(1,1),coords(1,2),0,1];

P(3,:)=[coords(2,1),coords(2,2),0,0,1,0];

P(4,:)=[0,0,coords(2,1),coords(2,2),0,1];

P(5,:)=[coords(3,1),coords(3,2),0,0,1,0];

P(6,:)=[0,0,coords(3,1),coords(3,2),0,1];

end

