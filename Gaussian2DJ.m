function [F, J] = Gaussian2DJ(p,xdata)

a=p(1);
b=p(2);
c=p(3);
d=p(4);
e=p(5);
f=p(6);

x=xdata(:,1);
y=xdata(:,2);

F = (a.*exp(-1.*((((x-b)/c).^2)+((y-d)/e).^2)))+f;

%Jacobian is the derivatives of a function over the parameter space
Ja=exp(- (b - x).^2/c.^2 - (d - y).^2/e.^2);
Jb=-(a.*exp(- (b - x).^2/c.^2 - (d - y).^2/e.^2).*(2.*b - 2.*x))/c.^2;
Jc=(2.*a.*exp(- (b - x).^2/c.^2 - (d - y).^2/e.^2).*(b - x).^2)/c.^3;
Jd=-(a.*exp(- (b - x).^2/c.^2 - (d - y).^2/e.^2).*(2.*d - 2.*y))/e.^2;
Je=(2.*a.*exp(- (b - x).^2/c.^2 - (d - y).^2/e.^2).*(d - y).^2)/e.^3;
Jf(1:size(xdata,1),1)=1;


J = [Ja, Jb, Jc, Jd, Je, Jf];


end