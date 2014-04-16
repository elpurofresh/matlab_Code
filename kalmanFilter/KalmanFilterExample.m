%Created by Lazaros Moysis using Matlab 7

%Estimating the constant value x(k)=x(k+1)=0.12345 using the measurement
%z(k)=x(k)+w(k) where w is a white noise w~N(0,0.01). We'll implement Kalman's
%filter algorithm for discrete time.
r=0.01;
%create a random sequence of numbers. function randn draws numbers from standard 
%normal distribution
noise=randn(1,150);
%create the random white noise sequence by multiplying the set of random numbers by the %standard deviation (tipiki apoklisi) of w 
w=sqrt(r)*noise;
%create the measurements vector
zmeasure=0.12345+w;
%create the real-time constant vector
xconstant1(1:150)=0.12345;
%create the algorithm for the kalman filter (first 150 estimations)
     xprior(1)=0;
     Pprior(1)=1;
     K(1)=Pprior(1)/(Pprior(1)+r);
    xpost(1)=xprior(1)+K(1)*(zmeasure(1)-xprior(1));
    Ppost(1)=(1-K(1))*Pprior(1);
for i=2:150
    xprior(i)=xpost(i-1);
    Pprior(i)=Ppost(i-1);
    K(i)=Pprior(i)/(Pprior(i)+r);
    xpost(i)=xprior(i)+K(i)*(zmeasure(i)-xprior(i));
    Ppost(i)=(1-K(i))*Pprior(i);
end
for i=1:150
k(i)=i;
end
plot(k,xpost(k),'*',k,zmeasure(k),'g--',k,xconstant1(k),'r')
legend('estimation','measurements','real-time quantity')
