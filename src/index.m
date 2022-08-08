a=[7,8,18];
b=[1,2,2,4,5,5,5,9];
%c=[1,2,2,2,2,3,4,5,5,7];
c=[1,2,2,2,2,3,4,5,5,7,1,3,5,7,5,7,9,8,5,4,7,3,2,1,5,7,4,5,5,4];

 k=1+(5-1)*rand(1,5);
%L=sum(k);
 %s=randi(8, 1, 5);
 r=rand(1, 5);

m=length(a); n=length(b);p=length(c);
A=cell(1,length(a));q=zeros(1,5);
for j=1:length(a)
    q=a(j).*k+r;
    A{j}=q;
end

 B=cell(1,length(b));q1=zeros(1,5);
for j=1:length(b)
    q1=b(j).*k+r;
    B{j}=q1;
end
 %vB=B(v);
C=cell(1,length(c));q2=zeros(1,5);
for j=1:length(c)
    q2=c(j).*k+r;
    C{j}=q2;
end


pop=50;%maxG=10000;

% InitializE Population 
% bu and bv were used to represent variable-length chromosome population
bu=cell(1,pop);
bv=cell(1,pop);
bw=cell(1,pop);
for i=1:pop
    %disp('Individual i:');    
    bu{i}=randperm(m);
    bv{i}=randperm(n);
    bw{i}=randperm(p);
end

% Evolution began
tic
    for i=1:pop
        u=bu{i};          
    uA=A(u);
    %vB=B(v);
    %uC=C(w);
    end
   t1=toc/50
   
   tic
    for i=1:pop
        v=bv{i};          
    %uA=A(u);
    vB=B(v);
    %uC=C(w);
    end
   t2=toc/50
   
   tic
    
     for i=1:pop
        w=bw{i};          
    wC=C(w);
    %vB=B(v);
    %uC=C(w);
     end
    t3=toc/50