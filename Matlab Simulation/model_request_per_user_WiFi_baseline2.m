clear all;
import Block.*;
import BlockChain.*;
import Miner.*;


%% VLC链路参数
% PLD=1.5;%LD功率
fov=60;%视场FoV=90度
Apd=10^-4;%PD物理面积
sigma22=10^-21;%VLC噪声功率谱密度
thetahalf=60;%半功率角
IH=8;%最大电流
B2=100*10^6;%VLC链路带宽
u1=0.35;%发射功率放大器效率
% ID=1.5;%直流偏置，满足PLD*A<=ID


%其他参数
PT=40;%总功率阈值
PO=6;%最大光功率
rtao=0.6;%照明水平
var2=1;%VLC信号s1的方差
A=1;%VLC信号s1的幅度

%计算发射功率
PLD1=((IH-rtao*PO)^2)/(A*A);
PLD2=((rtao*PO)^2)/(A*A);
PLD=13; % Supplementary Table 1, optical power in W


%% RF链路参数
T=288.15;%环境温度
kB=1.380649*10^(-23);%玻尔兹曼常数（论文没给）
sigma21=kB*T;%RF噪声功率谱密度
dB=5;%断点距离
sigmaB1=3;%d<dB时，阴影衰落标准差
sigmaB1_linear=10^(sigmaB1/20);
sigmaB2=5;%d＞dB时，阴影衰落标准差
sigmaB2_linear=10^(sigmaB2/20);
psik=45;%到达/离开角
Pcirrf=0.3;%RF电路功耗
%使用WIFI 7,中心频率6GHz，带宽80MHz，信道数16个
fc=5*10^9;%中心载波频率
B1=40*10^6;%RF链路带宽
channel_num=12;%最多可同时服务的用户个数
u2=0.35;%发射功率放大器效率


%% 基本位置参数
%房间
roomSize=[10,10,3];%房间大小10×10×4.7


%LD位置参数
% LD1=[2,2,3];
LD1 = struct('ID', 'LD1', 'Position', [2, 2, 3], 'isbusy', false);
LD2 = struct('ID', 'LD2', 'Position', [5, 2, 3], 'isbusy', false);
LD3 = struct('ID', 'LD3', 'Position', [8, 2, 3], 'isbusy', false);
LD4 = struct('ID', 'LD4', 'Position', [2, 5, 3], 'isbusy', false);
LD5 = struct('ID', 'LD5', 'Position', [5, 5, 3], 'isbusy', false);
LD6 = struct('ID', 'LD6', 'Position', [8, 5, 3], 'isbusy', false);
LD7 = struct('ID', 'LD7', 'Position', [2, 8, 3], 'isbusy', false);
LD8 = struct('ID', 'LD8', 'Position', [5, 8, 3], 'isbusy', false);
LD9 = struct('ID', 'LD9', 'Position', [8, 8, 3], 'isbusy', false);


%RF AP位置参数
WIFI = struct('ID', 'WIFI', 'Position', [5,5,0], 'isbusy', false);


%用户位置参数（终端离地面1m）
% UE1=[1,9,1];
% UE2=[3,3,1];
% UE3=[4,7,1];
% UE4=[8,4,1];
% UE5=[5,1,1];
% UE6 = [1, 1, 1];
% UE7 = [9, 1, 1];
% UE8 = [1, 5, 1];
% UE9 = [9, 9.5, 1];
% UE10 = [4, 4, 1];
% UE11 = [6, 6, 1];
% UE12 = [4, 6, 1];
% UE13 = [6, 4, 1];
% UE = [UE1; UE2; UE3; UE4; UE5];
% 用户位置参数（终端离地面1m）
% UE1 = struct('ID', 'User1', 'Position', [0.5, 9.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);         
% % UE1 = struct('ID', 'User1', 'Position', [1, 9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'request_round',0,'transmissiontime',0,'Data',0);
% UE2 = struct('ID', 'User2', 'Position', [3, 3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE3 = struct('ID', 'User3', 'Position', [3.6, 8.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE4 = struct('ID', 'User4', 'Position', [8, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE5 = struct('ID', 'User5', 'Position', [5.4,1.2,1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE6 = struct('ID', 'User6', 'Position', [1, 1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE7 = struct('ID', 'User7', 'Position', [9, 1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE8 = struct('ID', 'User8', 'Position', [1.5, 6.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE9 = struct('ID', 'User9', 'Position', [9, 9.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% % UE9 = struct('ID', 'User9', 'Position', [9, 9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE10 = struct('ID', 'User10', 'Position', [4, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE11 = struct('ID', 'User11', 'Position', [6, 6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE12 = struct('ID', 'User12', 'Position', [4, 6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE13 = struct('ID', 'User13', 'Position', [6, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE14 = struct('ID', 'User14', 'Position', [3.3, 9.8, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE15 = struct('ID', 'User15', 'Position', [7, 3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE16 = struct('ID', 'User16', 'Position', [6.2, 7.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE17 = struct('ID', 'User17', 'Position', [2, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE18 = struct('ID', 'User18', 'Position', [9, 7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE19 = struct('ID', 'User19', 'Position', [3, 0.2, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE20 = struct('ID', 'User20', 'Position', [7, 5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE21 = struct('ID', 'User21', 'Position', [2.1, 2.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE22 = struct('ID', 'User22', 'Position', [4.8, 8.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE23 = struct('ID', 'User23', 'Position', [6.5, 2.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE24 = struct('ID', 'User24', 'Position', [1.8, 5.6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE25 = struct('ID', 'User25', 'Position', [8.2, 3.4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE26 = struct('ID', 'User26', 'Position', [5.1, 6.8, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE27 = struct('ID', 'User27', 'Position', [3.7, 7.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE28 = struct('ID', 'User28', 'Position', [7.4, 8.6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE29 = struct('ID', 'User29', 'Position', [2.5, 4.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE30 = struct('ID', 'User30', 'Position', [6.9, 5.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE31 = struct('ID', 'User31', 'Position', [4.2, 2.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE32 = struct('ID', 'User32', 'Position', [8.7, 6.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE33 = struct('ID', 'User33', 'Position', [3.1, 8.4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE34 = struct('ID', 'User34', 'Position', [5.6, 3.8, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE35 = struct('ID', 'User35', 'Position', [2.9, 6.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE36 = struct('ID', 'User36', 'Position', [7.2, 7.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE37 = struct('ID', 'User37', 'Position', [4.6, 4.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE38 = struct('ID', 'User38', 'Position', [6.3, 1.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE39 = struct('ID', 'User39', 'Position', [1.3, 7.2, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE40 = struct('ID', 'User40', 'Position', [8.4, 5.4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE41 = struct('ID', 'User41', 'Position', [5.3, 9.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE42 = struct('ID', 'User42', 'Position', [3.5, 3.2, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE43 = struct('ID', 'User43', 'Position', [7.8, 8.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE44 = struct('ID', 'User44', 'Position', [2.3, 5.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE45 = struct('ID', 'User45', 'Position', [6.7, 4.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE46 = struct('ID', 'User46', 'Position', [4.1, 8.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE47 = struct('ID', 'User47', 'Position', [8.1, 2.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE48 = struct('ID', 'User48', 'Position', [2.7, 6.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE49 = struct('ID', 'User49', 'Position', [5.8, 3.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% UE50 = struct('ID', 'User50', 'Position', [7.5, 7.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
% 创建一个包含用户ID和位置的结构数组
% users = [UE1, UE2, UE3, UE4, UE5, UE6, UE7, UE8, UE9, UE10, UE11, UE12, UE13,UE14,UE15,UE16,UE17,UE18,UE19,UE20];
% 原始UE列表
% all_UEs = [UE1, UE2, UE3, UE4, UE5, UE6, UE7, UE8, UE9, UE10, UE11, UE12, UE13,UE14,UE15,UE16,UE17,UE18,UE19,UE20,UE21,UE22,UE23,UE24,UE25,UE26,UE27,UE28,UE29,UE30,UE31,UE32,UE33,UE34,UE35,UE36,UE37,UE38,UE39,UE40,UE41,UE42,UE43,UE44,UE45,UE46,UE47,UE48,UE49,UE50];

%待上链的请求用户列表
UE=[];

%% 初始化活跃用户
% 活跃用户数量
n = 50;

% % 获取原始UE列表的长度
% num_UEs = numel(all_UEs);
% 
% % 生成一个随机的索引列表
% random_indices = randperm(num_UEs, n);
% 
% % 遍历随机索引列表，选择对应的UE并添加到users中
% for i = 1:n
%     index = random_indices(i);
%     selected_UE = all_UEs(index);
%     users(i) = selected_UE;
% end

% 初始化活跃用户
for i = 1:n
    % 生成随机位置
    x1 = rand() * 10;
    y1 = rand() * 10;
    z1 = 1;
    
    % 活跃用户组
    users(i) = struct(...
        'ID', sprintf('User%d', i), ...
        'Position', [x1, y1, z1], ...
        'Confirmblock', [], ...
        'Rate', [], ...
        'Startime', [], ...
        'time', [], ...
        'waittime', [], ...
        'UE_request_round', 0, ...
        'transmissiontime', 0, ...
        'Data', 0);
end

%每轮结束被重新添加进去的用户
add_users=[];
%每轮被拒绝的用户
rejected_users=[];


%% 请求被拒绝概率
all_request_num=0;%总请求数
reject_num=0;%被拒绝的请求数
%q_rejected=reject_num/max(1,all_request_num); %被拒绝的概率

%% 创立区块链
bc=BlockChain;
obj1=bc.blockArray(1)
m1=Miner(bc);
minerindex=1;

%% 开始迭代
round=10000;%出块总数，即迭代轮数
AllocatedUser=[];%已分配用户
UEsample=struct('ID', [], 'Position', [0, 0, 0],'Confirmblock', [],'Rate',0,'Startime',[],'time',[],'waittime',[],'UE_request_round',0,'transmissiontime',0,'Data',0);
Servicelists = [];%初始化服务列表，行为LD，列为服务顺序
% probability = 0.4;%选择用户的概率阈值/每次出块
% probability_round = 0.002427906; %选择用户的概率阈值/每轮平均
average_request=0 ;%平均上传请求的个数()
timeline=0;%时间轴
%等待列表，长度至多为3
queue_list=[];
max_queue_length=3;%长度至多为3


% 多余的传输时间
more_transmissiontime=0;

% 用于画直方图
block_time_table=zeros(round,1);

%用于判断是否该上传请求
timeslot=0;
% round_time=0.073242187;%与chainxim一致
round_time=0.1;%与chainxim一致
each_block_round=0;
each_block_time=0;
request_round=100;
traffic_intensity=0.01; %平均request_round轮上传一次请求

%平均出块时间
average_blocktime=12;

%% 按照出块判断
% while minerindex <= round
%     fprintf('第%d次出块周期：\n',minerindex);
%     %出块时间
%     blocktime= exprnd(average_blocktime); %均值为12的指数分布
%     block_time_table(minerindex)=blocktime;
%     %上传请求的时间点
%     %request_time=blocktime*rand;
%     %% 按照轮次进行操作
%     while each_block_time<=blocktime
%         each_block_time=each_block_time+round_time;
% 
%         %% 无论有没有服务的用户，先进行round_time的传输
%         delete_indices_service=[];
%         for i=1:length(Servicelists)
%             %先进行round_time的传输
%             Servicelists(i).transmissiontime=Servicelists(i).transmissiontime+round_time;
%             %然后判断是否已经传输结束
%             if Servicelists(i).transmissiontime>=Servicelists(i).time
%                 %传输结束,把传输结束的UE记录在AllocatedUser
%                 AllocatedUser=[AllocatedUser,Servicelists(i)];
%                 %记录id，判断结束后把它清除出服务列表
%                 delete_indices_service=[delete_indices_service,i];
%                 %同样，把服务完的用户清空数据字段后，等待本轮结束，重新添加到users中
%                 finisheduser=Servicelists(i);
%                 finisheduser.Confirmblock=[];
%                 finisheduser.Rate=0;
%                 finisheduser.Startime=[];
%                 finisheduser.time=[];
%                 finisheduser.waittime=[];
%                 finisheduser.transmissiontime=0;
%                 finisheduser.UE_request_round=0;
%                 finisheduser.Data=0;
%                 %用户位置随机改变
%                 finisheduser.Position = [rand() * 10, rand() * 10,1];
%                 %先收集在一起，等结束了放入users
%                 add_users=[add_users,finisheduser];
%             end
%         end
%         % 从Servicelists中移除已经结束传输的用户
%         Servicelists(delete_indices_service) = [];
% 
%         %% 遍历排队列表中的元素
%         remove_indices = [];  % 用于记录要移除的元素索引
%         for i=1:length(queue_list)
%             % 如果服务列表有空位，把排队列表中的放进去，等待下一轮操作
%             if numel(Servicelists)< channel_num
%                 Servicelists=[Servicelists,queue_list(i)];
%                 remove_indices=[remove_indices,i];
%             end
%         end
%         % 最后统一移除被记录的元素
%         queue_list(remove_indices) = [];
%              
%        
%         %% 判断这一轮是否上传请求
%         delete_indices=[];
%         for i = 1:numel(users)
%             users(i).UE_request_round = users(i).UE_request_round + 1;
%             if rand <= traffic_intensity %如果低于流量密度，则上传请求
% %                 users(i).UE_request_round=0;
%                 %% 用户上传请求
%                 % 记录上传请求时间
%                 users(i).waittime = timeline+each_block_time;
% 
%                 % 输出用户ID和位置
%                 fprintf('第%d秒上传请求的用户为：\n',timeline+each_block_time);
%                 fprintf('User ID: %s, Position: %s\n', users(i).ID, mat2str(users(i).Position));
% 
%                 % 把请求用户放进待服务用户组中
%                 UE = [UE, users(i)];
% 
%                 % 准备在本轮结束后从活跃用户组移除已上传的用户
%                 delete_indices=[delete_indices,i];
%             end
%         end
%         % 从users中移除已经上传请求的用户
%         users(delete_indices) = [];
% 
%         %% 将所有请求用户逐个放入服务列表中，并计算传输速率
%         %读取待服务用户组中的所有用户
%         numUsers=numel(UE);
%         % 累加总请求个数
%         all_request_num=all_request_num+numUsers;
%         if numUsers~=0 %只有存在上传请求的用户时才更新服务列表
%             % 计算UE与WIFI的距离
%             d=zeros(numUsers,1);
%             for i = 1:numUsers
%                 d(i)=norm(UE(i).Position-WIFI.Position);
%                 %             fprintf('%s 与 WIFI 的距离为 %.2f\n', UE(i).ID, d(i));
%             end
% 
%             %% 计算传输速率，用于后续传输
%             %计算RF信道增益
%             % % 设置实部和虚部的均值和标准差
%             % mu_real = 0;    % 实部均值
%             % sigma_real = 1; % 实部标准差
%             % mu_imag = 0;    % 虚部均值
%             % sigma_imag = 1; % 虚部标准差
%             % % 生成一个符合复数高斯分布的随机变量
%             % real_part = normrnd(mu_real, sigma_real);
%             % imag_part = normrnd(mu_imag, sigma_imag);
%             % aa = complex(real_part, imag_part);
%             aa=0.507974650905946 + 0.281984063670556i;
%             %LF计算
%             h1=zeros(numUsers,1);
%             for i=1:numUsers
%                 LF=20*log10(d(i))+20*log10(fc)-147.5;
%                 if d(i)<=dB
%                     K=1;%RiceanK-因子，论文没给，参考其他文章设置
%                     Lo=sigmaB1*randn();
%                     %         Lo=-2.828798165138041;
%                     %         Lo=1.780727757588922;%M=1,2,4,5
%                     %         Lo=0.659534170530985;%M=3,6,7
%                     L=LF+Lo;
%                     h1(i)=(sqrt(K/(K+1))*exp(1j*deg2rad(psik))+sqrt(1/(K+1))*aa)*10^(-L/20);
%                 else
%                     K=0;
%                     Lo=sigmaB2*randn();
%                     %         Lo=-2.828798165138041;
%                     %         Lo=1.780727757588922;%M=1,2,4,5
%                     %         Lo=0.659534170530985;%M=3,6,7
%                     L=LF+35*log10(d(i)/dB)+Lo;
%                     h1(i)=(sqrt(K/(K+1))*exp(1j*deg2rad(psik))+sqrt(1/(K+1))*aa)*10^(-L/20);
%                 end
%             end
% 
% 
% 
%             %计算数据速率
%             %功率向量
%             P=ones(numUsers, 1);
%             R=zeros(1,numUsers);
%             for j=1:numUsers
%                 fenzidown=P(j)*h1(j);
%                 fenzidown=norm(fenzidown)^2;
%                 fenmudown=B1*sigma21;
%                 R(j)=B1*log2(1+fenzidown/fenmudown);
%                 R(j)=R(j)/10^6;
%                 %判断是否超过同时服务用户数量上限
%                 if numel(Servicelists)< channel_num
%                     % 未超过，则把用户添加进服务列表中
%                     fprintf('%s-WIFI链路的传输速率为 %d MBit/s\n', UE(j).ID,R(j));
%                     UE(j).Rate=R(j);
%                     %更新服务列表
%                     %记录等待时间
%                     UE(j).waittime=UE(j).Startime-UE(j).waittime;
%                     %随机生成传输的数据大小，并根据传输速率计算相应的所需传输时间
%                     data_size_bit = randi([1000, 10000]);
%                     fprintf('%s-WIFI链路传输数据包大小：%d Mbit\n', UE(j).ID, data_size_bit);
%                     UE(j).Data=data_size_bit;%记录传输数据的大小
%                     transmission_rate_Mbps = UE(j).Rate; % 传输速率（以Mbps为单位）
%                     transmission_time_sec = data_size_bit / (transmission_rate_Mbps); % 计算传输时间（以秒为单位）
%                     UE(j).time=transmission_time_sec;%将所需传输时间设在UE中
%                     %将用户添加到服务列表末尾
%                     Servicelists=[Servicelists,UE(j)];
%                 else
%                     % 超过了，则判断排队列表中有无空位
%                     if numel(queue_list)< max_queue_length
%                         % 有，则把用户添加进排队列表中
%                         fprintf('%s-WIFI链路的传输速率为 %d MBit/s\n', UE(j).ID,R(j));
%                         UE(j).Rate=R(j);
%                         %更新服务列表
%                         %随机生成传输的数据大小，并根据传输速率计算相应的所需传输时间
%                         data_size_bit = randi([1000, 10000]);
%                         fprintf('%s-WIFI链路传输数据包大小：%d Mbit\n', UE(j).ID, data_size_bit);
%                         UE(j).Data=data_size_bit;%记录传输数据的大小
%                         transmission_rate_Mbps = UE(j).Rate; % 传输速率（以Mbps为单位）
%                         transmission_time_sec = data_size_bit / (transmission_rate_Mbps); % 计算传输时间（以秒为单位）
%                         UE(j).time=transmission_time_sec;%将所需传输时间设在UE中
%                         %将用户添加排队列表末尾
%                         queue_list=[queue_list,UE(j)];
%                     else
%                         % 如果服务列表和排队列表都没空了，就拒绝
%                         fprintf('%s 的请求被拒绝\n', UE(j).ID);
%                         % 累加拒绝的请求个数
%                         reject_num=reject_num+1;
%                         % 用户随机改变位置，清空参数，并被重新放回活跃用户组中
%                         UE(j).Position = [rand() * 10, rand() * 10,1];
%                         UE(j).Confirmblock=[];
%                         UE(j).Rate=0;
%                         UE(j).Startime=[];
%                         UE(j).time=[];
%                         UE(j).waittime=[];
%                         UE(j).transmissiontime=0;
%                         UE(j).UE_request_round=0;
%                         UE(j).Data=0;
%                         rejected_users=[rejected_users,UE(j)];
%                     end
%                 end
% 
%             end
%             fprintf('\n');
%             % 把UE清空
%             UE=[];
%         end
%         %本轮结束
%         %将结束服务的用户添加到users中
%         users=[users,add_users];
%         add_users=[];
%         %将被拒绝的用户添加到users中
%         users=[users,rejected_users];
%         rejected_users=[];
%     end
%     %本次出块判断结束
%     %准备下一次区块时间
%     each_block_time=0;
% 
%     %% 出块
%     minerindex=minerindex+1;
%     fprintf('本次出块时间为: %.2f\n', blocktime);
%     % 更新时间轴
%     timeline=timeline+blocktime;
%     fprintf('\n');
% end











%% 按照轮次进行操作
max_round=1200000; % = 总时间/round_time 取整
round_caculated=1;
if ~isempty(getenv('BHLW_SMOKE_BLOCKS')), max_round=ceil(120*str2double(getenv('BHLW_SMOKE_BLOCKS'))); end
while round_caculated<=max_round
    timeline=timeline+round_time;
    %% 无论有没有服务的用户，先进行round_time的传输
    delete_indices_service=[];
    for i=1:length(Servicelists)
        %先进行round_time的传输
        Servicelists(i).transmissiontime=Servicelists(i).transmissiontime+round_time;
        %然后判断是否已经传输结束
        if Servicelists(i).transmissiontime>=Servicelists(i).time
            %传输结束,把传输结束的UE记录在AllocatedUser
            AllocatedUser=[AllocatedUser,Servicelists(i)];
            %记录id，判断结束后把它清除出服务列表
            delete_indices_service=[delete_indices_service,i];
            %同样，把服务完的用户清空数据字段后，等待本轮结束，重新添加到users中
            finisheduser=Servicelists(i);
            finisheduser.Confirmblock=[];
            finisheduser.Rate=0;
            finisheduser.Startime=[];
            finisheduser.time=[];
            finisheduser.waittime=[];
            finisheduser.transmissiontime=0;
            finisheduser.UE_request_round=0;
            finisheduser.Data=0;
            %用户位置随机改变
            finisheduser.Position = [rand() * 10, rand() * 10,1];
            %先收集在一起，等结束了放入users
            add_users=[add_users,finisheduser];
        end
    end
    % 从Servicelists中移除已经结束传输的用户
    Servicelists(delete_indices_service) = [];

    %% 遍历排队列表中的元素
    remove_indices = [];  % 用于记录要移除的元素索引
    for i=1:length(queue_list)
        % 如果服务列表有空位，把排队列表中的放进去，等待下一轮操作
        if numel(Servicelists)< channel_num
            %记录等待时间
            queue_list(i).waittime=timeline-queue_list(i).waittime;
            Servicelists=[Servicelists,queue_list(i)];
            remove_indices=[remove_indices,i];
        end
    end
    % 最后统一移除被记录的元素
    queue_list(remove_indices) = [];


    %% 判断这一轮是否上传请求
    delete_indices=[];
    for i = 1:numel(users)
        users(i).UE_request_round = users(i).UE_request_round + 1;
        if rand <= traffic_intensity %如果低于流量密度，则上传请求
            %                 users(i).UE_request_round=0;
            %% 用户上传请求
            % 记录上传请求时间
            users(i).waittime = timeline;

            % 输出用户ID和位置
            fprintf('第%d秒上传请求的用户为：\n',users(i).waittime);
            fprintf('User ID: %s, Position: %s\n', users(i).ID, mat2str(users(i).Position));

            % 把请求用户放进待服务用户组中
            UE = [UE, users(i)];

            % 准备在本轮结束后从活跃用户组移除已上传的用户
            delete_indices=[delete_indices,i];
        end
    end
    % 从users中移除已经上传请求的用户
    users(delete_indices) = [];

    %% 将所有请求用户逐个放入服务列表中，并计算传输速率
    %读取待服务用户组中的所有用户
    numUsers=numel(UE);
    % 累加总请求个数
    all_request_num=all_request_num+numUsers;
    if numUsers~=0 %只有存在上传请求的用户时才更新服务列表
        % 计算UE与WIFI的距离
        d=zeros(numUsers,1);
        for i = 1:numUsers
            d(i)=norm(UE(i).Position-WIFI.Position);
            %             fprintf('%s 与 WIFI 的距离为 %.2f\n', UE(i).ID, d(i));
        end

        %% 计算传输速率，用于后续传输
        % 计算RF信道增益
        % 设置实部和虚部的均值和标准差
        mu_real = 0;    % 实部均值
        sigma_real = 1/sqrt(2); % 实部标准差
        mu_imag = 0;    % 虚部均值
        sigma_imag = 1/sqrt(2); % 虚部标准差
        % 生成一个符合复数高斯分布的随机变量
        real_part = normrnd(mu_real, sigma_real);
        imag_part = normrnd(mu_imag, sigma_imag);
        aa = complex(real_part, imag_part);
        %aa=0.507974650905946 + 0.281984063670556i;
        %LF计算
        h1=zeros(numUsers,1);
        for i=1:numUsers
            aa=(randn()+1i*randn())/sqrt(2);
            LF=20*log10(d(i))+20*log10(fc)-147.5;
            if d(i)<=dB
                K=1;%RiceanK-因子，论文没给，参考其他文章设置
                Lo=sigmaB1*randn();
                %         Lo=-2.828798165138041;
                %         Lo=1.780727757588922;%M=1,2,4,5
                %         Lo=0.659534170530985;%M=3,6,7
                L=LF+Lo;
                h1(i)=(sqrt(K/(K+1))*exp(1j*deg2rad(psik))+sqrt(1/(K+1))*aa)*10^(-L/20);
            else
                K=1;
                Lo=sigmaB2*randn();
                %         Lo=-2.828798165138041;
                %         Lo=1.780727757588922;%M=1,2,4,5
                %         Lo=0.659534170530985;%M=3,6,7
                L=LF+35*log10(d(i)/dB)+Lo;
                h1(i)=(sqrt(K/(K+1))*exp(1j*deg2rad(psik))+sqrt(1/(K+1))*aa)*10^(-L/20);
            end
        end



        %计算数据速率
        %功率向量
        P=ones(numUsers, 1);
        R=zeros(1,numUsers);
        for j=1:numUsers
            fenzidown=P(j)*abs(h1(j))^2;
            fenmudown=B1*sigma21;
            R(j)=B1*log2(1+fenzidown/fenmudown);
            R(j)=R(j)/10^6;
            %判断是否超过同时服务用户数量上限
            if numel(Servicelists)< channel_num
                % 未超过，则把用户添加进服务列表中
                fprintf('%s-WIFI链路的传输速率为 %d MBit/s\n', UE(j).ID,R(j));
                UE(j).Rate=R(j);
                %更新服务列表
                %记录等待时间
                UE(j).waittime=timeline-UE(j).waittime;
                %随机生成传输的数据大小，并根据传输速率计算相应的所需传输时间
                data_size_bit = randi([1000, 10000]);
                fprintf('%s-WIFI链路传输数据包大小：%d Mbit\n', UE(j).ID, data_size_bit);
                UE(j).Data=data_size_bit;%记录传输数据的大小
                transmission_rate_Mbps = UE(j).Rate; % 传输速率（以Mbps为单位）
                transmission_time_sec = data_size_bit / (transmission_rate_Mbps); % 计算传输时间（以秒为单位）
                UE(j).time=transmission_time_sec;%将所需传输时间设在UE中
                %将用户添加到服务列表末尾
                Servicelists=[Servicelists,UE(j)];
            else
                % 超过了，则判断排队列表中有无空位
                if numel(queue_list)< max_queue_length
                    % 有，则把用户添加进排队列表中
                    fprintf('%s-WIFI链路的传输速率为 %d MBit/s\n', UE(j).ID,R(j));
                    UE(j).Rate=R(j);
                    %更新服务列表
                    %随机生成传输的数据大小，并根据传输速率计算相应的所需传输时间
                    data_size_bit = randi([1000, 10000]);
                    fprintf('%s-WIFI链路传输数据包大小：%d Mbit\n', UE(j).ID, data_size_bit);
                    UE(j).Data=data_size_bit;%记录传输数据的大小
                    transmission_rate_Mbps = UE(j).Rate; % 传输速率（以Mbps为单位）
                    transmission_time_sec = data_size_bit / (transmission_rate_Mbps); % 计算传输时间（以秒为单位）
                    UE(j).time=transmission_time_sec;%将所需传输时间设在UE中
                    %将用户添加排队列表末尾
                    queue_list=[queue_list,UE(j)];
                else
                    % 如果服务列表和排队列表都没空了，就拒绝
                    fprintf('%s 的请求被拒绝\n', UE(j).ID);
                    % 累加拒绝的请求个数
                    reject_num=reject_num+1;
                    % 用户随机改变位置，清空参数，并被重新放回活跃用户组中
                    UE(j).Position = [rand() * 10, rand() * 10,1];
                    UE(j).Confirmblock=[];
                    UE(j).Rate=0;
                    UE(j).Startime=[];
                    UE(j).time=[];
                    UE(j).waittime=[];
                    UE(j).transmissiontime=0;
                    UE(j).UE_request_round=0;
                    UE(j).Data=0;
                    rejected_users=[rejected_users,UE(j)];
                end
            end

        end
        fprintf('\n');
        % 把UE清空
        UE=[];
    end
    %将结束服务的用户添加到users中
    users=[users,add_users];
    add_users=[];
    %将被拒绝的用户添加到users中
    users=[users,rejected_users];
    rejected_users=[];

    %本轮结束,进行下一轮判断
    round_caculated=round_caculated+1;
end




%% 数据计算
count = 0;          % waittime = 72 的计数器
sumWaittime = 0;    % waittime 的总和
maxWaittime = -Inf; % 最大的 waittime
minWaittime = Inf;  % 最小的 waittime

sumData=0;   %传输的数据总量

for i = 1:numel(AllocatedUser)
    currentWaittime = AllocatedUser(i).waittime;
    currentData=AllocatedUser(i).Data;

    % 更新最大值和最小值
    if currentWaittime > maxWaittime
        maxWaittime = currentWaittime;
    end
    if currentWaittime < minWaittime
        minWaittime = currentWaittime;
    end

    % 计算 waittime = 72 的计数
    if currentWaittime == 72
        count = count + 1;
    end

    % 计算 waittime 的总和
    sumWaittime = sumWaittime + currentWaittime;

    %计算数据总量
    sumData=sumData+currentData;
end

% 计算概率
probability = count / max(1,numel(AllocatedUser));

% 计算平均值
average = sumWaittime / max(1,numel(AllocatedUser));

%计算吞吐量
throughput=sumData/timeline;

% 所经历区块数
blocknum=minerindex-1;

%计算被拒绝的概率
q_rejected=reject_num/max(1,all_request_num);