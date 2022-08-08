%for N=1:5
function [t,g,f,u,v,w]=PPQIGA(A,B,C)
 

%  Initialization
tt=0;g=0;f_opt=0;u=[];v=[];w=[];
%  for INS=1:3
%     [a,b,c]=getInstance(INS);
 % [A,B,C]=OPH(a,b,c);
%     
     m=length(A); n=length(B);p=length(C);
% Set genetic probability, population size and maximum evolution generation
pc=0.85;
pm=2/(m+n);pm_gap=(0.55-pm)/200;
pop=50;maxG=10000;

% InitializE Population 
% bu and bv were used to represent variable-length chromosome population
bu=cell(1,pop);
bv=cell(1,pop);
for i=1:pop
    %disp('Individual i:');    
    bu{i}=randperm(m);
    bv{i}=randperm(n);
end

% Evolution began
tic
g=0;f_opt=0;i_opt=0;f(1:pop)=0;Loop=1;gf=[];
while (Loop==1)    
    for i=1:pop
        % Chromosome decoding
        u=bu{i};v=bv{i};
        % Calculate the fitness value
        %f(i)=DD_fitness(a,b,c,u,v);  
        
        f(i)=DD_fitness(A,B,C,u,v);  
        
        
        % Select excellent individual
        if f(i)>f_opt
            f_opt=f(i);
            i_opt=i;
        end
    end
    % Preserve excellent individual
    bu_opt=[];bu_opt=bu{i_opt};
    bv_opt=[];bv_opt=bv{i_opt};
    g=g+1;
    % Shows contemporary optimal values
    %disp('--------- optimal fitness of current generation ---------');
    %str=sprintf('%d    %f', g, f_opt);
    %disp(str);
    gf(g)=f_opt;
   
  
    
    if (f_opt<1) && (g<maxG)       
        
        %Improved wheel selection operator, only need to rotate once to complete all the selection, and it ensures that each generation of the best individual will not be eliminated
        %Calculate the probability of each individual being selected
	    fp=f./sum(f);
	    % Calculate the wheel spacing
        pop_choose=round(pop*0.8);
	    gap=1.0/pop_choose;
	    %Calculate the random start point of the roulette wheel
	    toss=rand*gap;
	    j=0;jf=0.0;i=0;
	    while(i<pop_choose)
		    j=j+1;
		    if j>pop
			    %Over the border, turn the wheel again
			    toss=rand*gap;
			    j=1;jf=0.0;
		    end
    	    jf=jf+fp(j);
    	     if toss<jf
			    % Select the Jth individual
                i = i + 1;
                bu{i}=bu{j};bv{i}=bv{j};
        	    toss = toss + gap;
             end
        end
        % Introduce new random individuals
        for i=pop_choose+1:pop-1
            bu{i}=randperm(m);
            bv{i}=randperm(n);
        end
        % Preserve excellent individual
        bu{pop}=bu_opt;
        bv{pop}=bv_opt;
        
       
        % execute crossover
       
        
        
        for i=1:2:pop
            % Copy preparation
            xu=[];xv=[];yu=[];yv=[];
            xu=bu{i};xv=bv{i};
            yu=bu{i+1};yv=bv{i+1}; 
                          
            % PCC
%             a=1
            r=rand;
            if r<pc
                bu{i}=xu(yu);bu{i+1}=yu(xu);
                bv{i}=xv(yv);bv{i+1}=yv(xv);
            end
  
        end
            
        
        % execute muation
%         for i=1:pop
%             % Copy preparation
%             xu=[];xv=[];
%             xu=bu{i};xv=bv{i}; 
%            
% 
% 
% 
% %     d=4
%             % FLP
%             p=length(xu);q=length(xv);
%             k2=randi([1,p]);k1=randi([1,k2]);L=k2-k1+1;
%             r=rand;
%             if r<pm
%                 xu(k1:1:k2)=xu(k2:-1:k1);
%             end
%             k2=randi([1,q]);k1=randi([1,k2]);L=k2-k1+1;
%             r=rand;
%             if r<pm
%                 xv(k1:1:k2)=xv(k2:-1:k1);
%             end
% %             
% 
% 
% 
% 
% 
% 
%  
% 
% 
% 
%             % Preserve muation results
%             bu{i}=xu;bv{i}=xv;            
%         end
        % Modified muation probability 
        pm=pm+pm_gap;
        if pm>=0.55
            pm=2/(m+n);
        end
    else
        Loop=0;

end
end
u=bu{i_opt};
v=bv{i_opt};
%w=ddseq(A,B,C,u,v);
%f_opt;
tt=toc;
disp('[time gen fitness]=');
disp([tt, g, f_opt]);
t=tt;f=f_opt;
end

% Optimal chromosome decoding

%end
%return
%end


