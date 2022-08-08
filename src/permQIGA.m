function [tt,g,f_opt,u,v,w]=permQIGA(A,B,C)
% 
% 功能：求解双消化问题DDP(A,B,C)
% 输入：三个有序多重集合A,B,C
%           遗传算子类型集合 op=[
%                          1 置换复合交叉
%                          3 单点变异
%                          2 参考保序交叉
%                          4 片段翻转
%                          5 片段移位]
% 输出：进化计算用时tt, 进化代数g, 最优适应值f_opt
%           双消化问题的解，用三个置换(u,v,w)表示
%

% 初始化
tt=0;g=0;f_opt=0;u=[];v=[];w=[];
% A=[5509,5626,6527,6766,7233,16841];
% B=[3526,4878,5643,5804,7421,21230];
% C=[1120,1868,2564,2752,3240,3526,3758,3775,4669,5509,15721];


% 解析输入实例
m=length(A);n=length(B);k=length(C);

% % 设定遗传概率、种群规模和最大进化代数
pc=0.85;
pm=2/(m+n);pm_gap=(0.55-pm)/200;
pop=50;maxG=100000;

% % 种群初始化
% % 用两个元胞数组bu,bv表示变长染色体种群
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
%对种群中的每条染色体进行排序，并记录其之前的索引，此时得到置换矩阵u，QGA编码与DDP结合到一起

for i=1:Ps
  [mm,nn]=sort(P2((i-1)*item1+1:i*item1));
  bv{i}=nn;
end

% 进化开始
tic
g=0;f_opt=0;i_opt=0;f(1:pop)=0;Loop=1;gf=[];
while (Loop==1)    
    for i=1:pop
        % 染色体解码
        u=bu{i};v=bv{i};
        % 适应值计算
        f(i)=DD_fitness(A,B,C,u,v);        
        % 择优
        if f(i)>f_opt
            f_opt=f(i);
            i_opt=i;
        end
    end
    % 保优    
    bu_opt=[];bu_opt=bu{i_opt};
    bv_opt=[];bv_opt=bv{i_opt};
    g=g+1;
    % 显示当代最优值
    %disp('--------- optimal fitness of current generation ---------');
    %str=sprintf('%d    %f', g, f_opt);
    %disp(str);
    gf(g)=f_opt;
    
    if (f_opt<1) && (g<maxG)       
        
        % 改进的赌轮选择算子,只需旋转一次即可完成全部选择,而且它确保每一代的最优个体不会被淘汰
	    % 计算每一个体被选择的概率
	    fp=f./sum(f);
	    % 计算赌轮间距
        pop_choose=round(pop*0.8);
	    gap=1.0/pop_choose;
	    %计算赌轮随机起始点
	    toss=rand*gap;
	    j=0;jf=0.0;i=0;
	    while(i<pop_choose)
		    j=j+1;
		    if j>pop
			    % 越界,重转赌轮
			    toss=rand*gap;
			    j=1;jf=0.0;
		    end
    	    jf=jf+fp(j);
    	    if toss<jf
			    % 选择第j个个体
                i = i + 1;
                bu{i}=bu{j};bv{i}=bv{j};
        	    toss = toss + gap;
            end
        end
        % 引入新的随机个体
        for i=pop_choose+1:pop-1
            bu{i}=randperm(m);
            bv{i}=randperm(n);
        end
        % 保优
        bu{pop}=bu_opt;
        bv{pop}=bv_opt;
        
        % 执行交叉
        for i=1:2:pop_choose
            % 染色体副本制备
            xu=[];xv=[];yu=[];yv=[];
            xu=bu{i};xv=bv{i};
            yu=bu{i+1};yv=bv{i+1};            
                          
            % 置换复合交叉
            r=rand;
            if r<pc
                bu{i}=xu(yu);bu{i+1}=yu(xu);
                bv{i}=xv(yv);bv{i+1}=yv(xv);
            end
            end
            
%         
        
        % 执行变异
        for i=1:pop_choose
            % 染色体副本制备
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

            % 保存变异结果
            bu{i}=xu;bv{i}=xv;            
        end
        % 修正变异概率
        pm=pm+pm_gap;
        if pm>=0.55
            pm=2/(m+n);
        end
   else
        Loop=0;
    end
    end
  
tt=toc;
% 最优染色体解码
u=bu{i_opt};
v=bv{i_opt};
% w=ddseq(A,B,C,u,v);
% f_opt;
disp('[time gen fitness]=');
disp([tt, g, f_opt]);
t=tt;f=f_opt;
return



