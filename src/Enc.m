

a=5;
n=5;
k=1+(5-1)*rand(1,n);


tic
for i=1:1000
    r=rand(1, n);
R=sum(r)-r(n);q=zeros(1,n);
q=a.*k+r;
q(n)=k(n)*R;
end
t2=toc/1000


