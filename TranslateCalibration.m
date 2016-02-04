function [ final, A,B ] = TranslateCalibration( real, spectra, showit, rx, sx )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if sum(real(1,:))==0
   real=real(2:end,:); 
   spectra=spectra(2:end,:); 
end

if length(real)<3
    disp('Too few points');
end

P=BuildP(real([rx],1:2));

[ newcoord ] = Buildnewcords(spectra([sx],1:2));

outcome=inv(P)*newcoord;

A=reshape(outcome(1:4),2,2);
A=A';
B=outcome(5:6);

[Q,W] = size(real);
for i=1:Q;
[ transformed ] = ApplyTranform( real(i,1:2),A,B );
finalt(:,i)=transformed;
end
final=finalt';
final(:,3)=final(:,1);
final(:,4)=final(:,2);

if showit==1;
plot(real(:,1),real(:,2),'r*',spectra(:,1),spectra(:,2),'b.',final(:,1),final(:,2),'go');
end

end

