% function [A,B,C]=getInstance(INS,scale,max_gap)
function [a,b,c]=getInstance(INS)
% ���ܣ�ѡ�����ʵ��
% ���룺INS --- ����ʵ�����ͣ�1..8  D10 DataSet INS 1..8, ����ֵ����ʾ���ʵ��
%           scale ---  ʵ����ģ��|C|��ֵ(�������ʵ��������)
%           max_gap --- CƬ�������gap(�������ʵ��������)
% �����[A,B,C] --- D10 DataSet INS 1..8

%Function: select test instances
% input: INS --- test instance type: 1..8 D10 DataSet INS 1..8, other values all represent random instances
%        scale -- instance size is the value of |C| (only for random instances)
%        Maximum gap on % max_gap -- C segment (only for random instances)
%output:[A,B,C] -- -d10 DataSet INS 1..8

% Initialization the instance
a=[];b=[];c=[];

% Instances from Sur-Kolay: D10 TestSet

if INS==1
% Instance 1
disp('------------------- D10 TestSet 1 -------------------')
a=[1,2,3,3,4,4,5,5];
b=[1,2,3,3,3,7,8];
c=[1,1,1,1,1,1,2,2,2,2,2,3,4,4];

elseif INS==2
% Instance 2
% disp('------------------- D10 TestSet 2 -------------------')
% 
%  a=[5509,5626,6527,6766,7233,16841];
%  b=[3526,4878,5643,5804,7421,21230];
%  c=[1120,1868,2564,2752,3240,3526,3758,3775,4669,5509,15721];

 disp('------------------- D10 TestSet 8 -------------------')
a=[1,3,3,12];
b=[1,2,3,3,4,6];
c=[1,1,1,1,2,2,2,3,6];
 
 
elseif INS==3
% Instance 3
disp('------------------- D10 TestSet 3 -------------------')
a=[7,8,18];
b=[1,2,2,4,5,5,5,9];
c=[1,2,2,2,2,3,4,5,5,7];

elseif INS==4
% Instance 4
disp('------------------- D10 TestSet 4 -------------------')
a=[1,1,1,1,2,3,5,7,12];
b=[1,2,2,4,5,5,5,9];
c=[1,1,1,1,1,1,1,1,1,2,2,3,3,5,9];

elseif INS==5
% Instance 5
disp('------------------- D10 TestSet 5 -------------------')
a=[1,2,2,3,3,4];
b=[1,1,2,2,4,5];
c=[1,1,1,1,1,2,2,3,3];

% elseif INS==6
% % Instance 6
% disp('------------------- D10 TestSet 6 -------------------')
% a=[1,2,3,4,5,6,7,8,9];
% b=[15,15,15];
% c=[1,1,1,1,2,2,2,3,6];

elseif INS==6
% Instance 7
disp('------------------- D10 TestSet 7 -------------------')
a=[7,8,18];
b=[1,1,1,1,2,3,5,7,12];
c=[1,1,1,1,1,2,2,4,5,7,8];

elseif INS==7
% Instance 8
disp('------------------- D10 TestSet 8 -------------------')
a=[1,3,3,12];
b=[1,2,3,3,4,6];
c=[1,1,1,1,2,2,2,3,6];

elseif INS==8
disp('------------------- D10 TestSet 2 -------------------')

 a=[5509,5626,6527,6766,7233,16841];
 b=[3526,4878,5643,5804,7421,21230];
 c=[1120,1868,2564,2752,3240,3526,3758,3775,4669,5509,15721];

elseif INS==10
disp('------------------- Instance 10 : reduced from D 10 Instance 2 -------------------')
%A=[5509,5626,6527,6766,7233,16841];
%B=[3526,4878,5643,5804,7421,21230];
%C=[1120,1868,2564,2752,3240,3526,3758,3775,4669,5509,15721];
% rounding-down with 0.1
%A=round(A/1000-0.1);
%B=round(B/1000-0.1);
%C=round(C/1000-0.1);
a=[5     6     6     7     7    17];
b=[3     5     6     6     7    21];
c=[1     2     2     3     3     3     4     4     5     5    16];

% else
% % Random Instance
% disp('------------------- Random Instance : -------------------')
% [A,B,C]=randDDPinstance(scale,max_gap);
end

%disp('A=');disp(A);
%disp('B=');disp(B);
%disp('C=');disp(C);
disp('Instance size=');disp([length(a),length(b),length(c)]);
%str=strABC(A,B,C);
%disp(str);

return







