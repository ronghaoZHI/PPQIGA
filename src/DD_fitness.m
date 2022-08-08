function [f]=DD_fitness(A,B,C,u,v)
 uA=A(u);
 vB=B(v);

SuA=[];SvB=[];
SA=[];
SA{1}=uA{1};

for i=2:length(A)
    SA{i}=SA{i-1}+uA{i};
end

SB=[];
SB{1}=vB{1};
for i=2:length(B)
    SB{i}=SB{i-1}+vB{i};
end



la=length(A);lb=length(B);
T=[];
i=1;j=1;k=1;
while (i<=la) || (j<=lb)
    if (i<=la) && (j<=lb)
        if SA{i}<SB{j}
            T{k}=SA{i};i=i+1;k=k+1;
        else
            T{k}=SB{j};j=j+1;k=k+1;
        end
    else
        while (i<=la)
            T{k}=SA{i};i=i+1;k=k+1;
        end
        while (j<=lb)
            T{k}=SB{j};j=j+1;k=k+1;
        end
    end
end
% È¥µôÄ©Î²ÖØ¸´ÔªËØ
 T(length(T))=[];



DA=[];F=[];
DA{1}=T{1};
%DA{1}
for i=2:length(T)
    DA{i}=T{i}-T{i-1};
   % DA{i}
end

n = length(DA);
for j = 1:n
    for i = 1:n-j
        if DA{i} > DA{i+1}
            t = DA{i};
            DA{i} =  DA{i+1};
             DA{i+1} = t;
        end
    end
end


F=DA;
fitnum=0;missnum=0;
lf=length(F);lc=length(C);
i=1;j=1;
while (i<=lf) || (j<=lc)
    if (i<=lf) && (j<=lc)
        if round(F{i})<round(C{j})
            missnum=missnum+1;i=i+1;             
        elseif round(C{j})<round(F{i}) 
            missnum=missnum+1;j=j+1;
        else
            fitnum=fitnum+1;i=i+1;j=j+1;        
        end
    else
        if (i<=lf)
            missnum=missnum+(lf-i+1);i=lf+1;
        elseif (j<=lc)
            missnum=missnum+(lc-j+1);j=lc+1;
        end
    end
end
f=fitnum/(fitnum+missnum);
return







