function [tt,g,f_opt,u,v,w]=permQIGA(A,B,C)
% 
% ���ܣ����˫��������DDP(A,B,C)
% ���룺����������ؼ���A,B,C
%           �Ŵ��������ͼ��� op=[
%                          1 �û����Ͻ���
%                          3 �������
%                          2 �ο����򽻲�
%                          4 Ƭ�η�ת
%                          5 Ƭ����λ]
% ���������������ʱtt, ��������g, ������Ӧֵf_opt
%           ˫��������Ľ⣬�������û�(u,v,w)��ʾ
%

% ��ʼ��
tt=0;g=0;f_opt=0;u=[];v=[];w=[];
% A=[5509,5626,6527,6766,7233,16841];
% B=[3526,4878,5643,5804,7421,21230];
% C=[1120,1868,2564,2752,3240,3526,3758,3775,4669,5509,15721];


% ��������ʵ��
m=length(A);n=length(B);k=length(C);

% % �趨�Ŵ����ʡ���Ⱥ��ģ������������
pc=0.85;
pm=2/(m+n);pm_gap=(0.55-pm)/200;
pop=50;maxG=100000;

% % ��Ⱥ��ʼ��
% % ������Ԫ������bu,bv��ʾ�䳤Ⱦɫ����Ⱥ
Ps=pop; 
item=m;
item1=n;
PsL=Ps*item; % the number of Q-bits
PsL1=Ps*item1; % the number of Q-bits
q=zeros(2,item); % Q-bits for one individual
q1=zeros(2,item1); % Q-bits for one individual
P=zeros(1,PsL);  % Q-bits for the population
P1=zeros(1,PsL1);  % Q-bits for the population
mm=zeros(1,item);
nn=zeros(1,item1);

% initialization Q(gen)
for j=1:item
    q(1,j)=sign(-1+2*rand(1))*(1/sqrt(2));
    q(2,j)=sign(-1+2*rand(1))*(1/sqrt(2));
end
Q1=q;
for kki=1:Ps-1
    for j=1:item
        q(1,j)=sign(-1+2*rand(1))*1/sqrt(2);
        q(2,j)=sign(-1+2*rand(1))*1/sqrt(2);
    end
    Q1=[Q1 q];
end
% Q1
% construct P(gen)
for i=1:PsL
    rr=rand(1);
    if rr<Q1(2,i)^2
        bit=1;
    else
        bit=0;
    end
    P1(1,i)=bit;
end



bu=cell(1,Ps);
bv=cell(1,Ps);
% bu
% bv

for i=1:Ps
  [mm,nn]=sort(P1((i-1)*item+1:i*item));
  bu{i}=nn;
end



% initialization Q(gen)
for j=1:item1
    q1(1,j)=sign(-1+2*rand(1))*(1/sqrt(2));
    q1(2,j)=sign(-1+2*rand(1))*(1/sqrt(2));
end
Q2=q1;
for kki=1:Ps-1
    for j=1:item1
        q1(1,j)=sign(-1+2*rand(1))*1/sqrt(2);
        q1(2,j)=sign(-1+2*rand(1))*1/sqrt(2);
    end
    Q2=[Q2 q1];
end
% Q2
for i=1:PsL1
    rr=rand(1);
    if rr<Q2(2,i)^2
        bit=1;
    else
        bit=0;
    end
    P2(1,i)=bit;
end
%����Ⱥ�е�ÿ��Ⱦɫ��������򣬲���¼��֮ǰ����������ʱ�õ��û�����u��QGA������DDP��ϵ�һ��

for i=1:Ps
  [mm,nn]=sort(P2((i-1)*item1+1:i*item1));
  bv{i}=nn;
end

% ������ʼ
tic
g=0;f_opt=0;i_opt=0;f(1:pop)=0;Loop=1;gf=[];
while (Loop==1)    
    for i=1:pop
        % Ⱦɫ�����
        u=bu{i};v=bv{i};
        % ��Ӧֵ����
        f(i)=DD_fitness(A,B,C,u,v);        
        % ����
        if f(i)>f_opt
            f_opt=f(i);
            i_opt=i;
        end
    end
    % ����    
    bu_opt=[];bu_opt=bu{i_opt};
    bv_opt=[];bv_opt=bv{i_opt};
    g=g+1;
    % ��ʾ��������ֵ
    %disp('--------- optimal fitness of current generation ---------');
    %str=sprintf('%d    %f', g, f_opt);
    %disp(str);
    gf(g)=f_opt;
    
    if (f_opt<1) && (g<maxG)       
        
        % �Ľ��Ķ���ѡ������,ֻ����תһ�μ������ȫ��ѡ��,������ȷ��ÿһ�������Ÿ��岻�ᱻ��̭
	    % ����ÿһ���屻ѡ��ĸ���
	    fp=f./sum(f);
	    % ������ּ��
        pop_choose=round(pop*0.8);
	    gap=1.0/pop_choose;
	    %������������ʼ��
	    toss=rand*gap;
	    j=0;jf=0.0;i=0;
	    while(i<pop_choose)
		    j=j+1;
		    if j>pop
			    % Խ��,��ת����
			    toss=rand*gap;
			    j=1;jf=0.0;
		    end
    	    jf=jf+fp(j);
    	    if toss<jf
			    % ѡ���j������
                i = i + 1;
                bu{i}=bu{j};bv{i}=bv{j};
        	    toss = toss + gap;
            end
        end
        % �����µ��������
        for i=pop_choose+1:pop-1
            bu{i}=randperm(m);
            bv{i}=randperm(n);
        end
        % ����
        bu{pop}=bu_opt;
        bv{pop}=bv_opt;
        
        % ִ�н���
        for i=1:2:pop_choose
            % Ⱦɫ�帱���Ʊ�
            xu=[];xv=[];yu=[];yv=[];
            xu=bu{i};xv=bv{i};
            yu=bu{i+1};yv=bv{i+1};            
                          
            % �û����Ͻ���
            r=rand;
            if r<pc
                bu{i}=xu(yu);bu{i+1}=yu(xu);
                bv{i}=xv(yv);bv{i+1}=yv(xv);
            end
            end
            
%         
        
        % ִ�б���
        for i=1:pop_choose
            % Ⱦɫ�帱���Ʊ�
            xu=[];xv=[];
            xu=bu{i};xv=bv{i}; 
            
            
             r=rand;
            if r<pm
                j1=randi(1,m);j2=randi(1,m);
                t=xu(j1);xu(j1)=xu(j2);xu(j2)=t;
            end
            r=rand;
            if r<pm
                j1=randi(1,n);j2=randi(1,n);
                t=xv(j1);xv(j1)=xv(j2);xv(j2)=t;
            end  
%         

            % ���������
            bu{i}=xu;bv{i}=xv;            
        end
        % �����������
        pm=pm+pm_gap;
        if pm>=0.55
            pm=2/(m+n);
        end
   else
        Loop=0;
    end
    end
  
tt=toc;
% ����Ⱦɫ�����
u=bu{i_opt};
v=bv{i_opt};
% w=ddseq(A,B,C,u,v);
% f_opt;
disp('[time gen fitness]=');
disp([tt, g, f_opt]);
t=tt;f=f_opt;
return



