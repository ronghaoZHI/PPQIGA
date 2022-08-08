m1=3;
m2=7;
n=5;
k=1+(5-1)*rand(1,n);

r1=rand(1, n);
R1=sum(r1)-r1(n);c1=zeros(1,n);
c1=m1.*k+r1;
c1(n)=k(n)*R1;

r2=rand(1, n);
R2=sum(r2)-r2(n);c2=zeros(1,n);
c2=m2.*k+r2;
c2(n)=k(n)*R2;

tic
C=c1+c2;
t3=toc

