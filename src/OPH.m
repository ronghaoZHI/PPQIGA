 function [A,B,C]=OPH(a,b,c)
% format long;
T=[];
%for INS=1:7
    tic
%[a,b,c]=getInstance(INS);
m=length(a); n=length(b);p=length(c);

k=1+(5-1)*rand(1,5);
%L=sum(k);
 %s=randi(8, 1, 5);
 


A=cell(1,m);q=zeros(1,5);
for j=1:m
     r=rand(1, 5);
     R=sum(r)-r(5);
    q=a(j).*k+r;
    q(5)=k(5)*R;
    A{j}=q;
end
%A
B=cell(1,n);q1=zeros(1,5);
for j=1:n
     r=rand(1, 5);
     R=sum(r)-r(5);
    q1=b(j).*k+r;
    q1(5)=k(5)*R;
    B{j}=q1;
end
%B
C=cell(1,p);q2=zeros(1,5);
for j=1:p
     r=rand(1, 5);
     R=sum(r)-r(5);
    q2=c(j).*k+r;
    q2(5)=k(5)*R;
    C{j}=q2;
end
%C
 t=toc;
 T=[T t];
 %T
%end
end

