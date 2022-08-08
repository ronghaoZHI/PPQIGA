%the result of any instance by using any operator


function [T,G,S]=T1(INS)


format long;


%INS=input('Please input the inatance you want,INS£º');
T=[];G=[];S=[];
 for INS=10:11
    [a,b,c]=Instance(INS);
     m=length(a); n=length(b);p=length(c);
    [A,B,C]=OPH(a,b,c);
   

%[tt,g,f_opt,u,v,w]=PPQIGA(A,B,C)
% Set simulation times
tt1=0;gg=0;ss=0;
N=5;
for i=1:N
    %[t,g,f,u,v]=permCGA(a,b,c);
    %[tt,g,f_opt,]=PPQIGA()
   [t,g,f,u,v]=PPQIGA(A,B,C);
    %RS=[RS; t, g, f, 0, u, 0, v, 0, w];
    tt1=tt1+t;
    gg=gg+g;
    ss=ss+f;
end
tt1=tt1/N;gg=gg/N;ss=ss/N;

T=[T tt1];
G=[G gg];
S=[S ss];


% disp('[avgTime  avgEvoGen  SuccRate]=');
%  disp([tt,gg,ss]);
 disp('[T  G S]=');
 disp([T,G,S]);
end
end



 

