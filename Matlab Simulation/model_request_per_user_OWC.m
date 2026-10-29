clear all;
import Block.*;
import BlockChain.*;
import Miner.*;


%% VLC链路参数
% PLD=1.5;%LD功率
fov=30;%视场FoV=60/30度
Apd=10^-4;%PD物理面积
sigma22=10^-21;%VLC噪声功率谱密度
thetahalf=30;%半功率角
IH=8;%最大电流
B2=100*10^6;%VLC链路带宽
u1=0.35;%发射功率放大器效率
% ID=1.5;%直流偏置，满足PLD*A<=ID
m=10;%兰伯特发射阶数
Rpd=1; %PD响应率


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
% PLD=100;



%% 基本位置参数
%房间
roomSize=[10,10,3];%房间大小10×10×4.7


%LD位置参数
%% 4个LD的分布
% LD1 = struct('ID', 'LD1', 'Position', [2.5, 2.5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD2 = struct('ID', 'LD2', 'Position', [7.5, 2.5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD3 = struct('ID', 'LD3', 'Position', [2.5, 7.5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD4 = struct('ID', 'LD4', 'Position', [7.5, 7.5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);


%% 9个LD的分布
% LD1 = struct('ID', 'LD1', 'Position', [1.67, 1.67, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD2 = struct('ID', 'LD2', 'Position', [5.0, 1.67, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD3 = struct('ID', 'LD3', 'Position', [8.33, 1.67, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD4 = struct('ID', 'LD4', 'Position', [1.67, 5.0, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD5 = struct('ID', 'LD5', 'Position', [5.0, 5.0, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD6 = struct('ID', 'LD6', 'Position', [8.33, 5.0, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD7 = struct('ID', 'LD7', 'Position', [1.67, 8.33, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD8 = struct('ID', 'LD8', 'Position', [5.0, 8.33, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD9 = struct('ID', 'LD9', 'Position', [8.33, 8.33, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);


%% 16个LD的分布
% LD1 = struct('ID', 'LD1', 'Position', [1.25, 1.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD2 = struct('ID', 'LD2', 'Position', [3.75, 1.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD3 = struct('ID', 'LD3', 'Position', [6.25, 1.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD4 = struct('ID', 'LD4', 'Position', [8.75, 1.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD5 = struct('ID', 'LD5', 'Position', [1.25, 3.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD6 = struct('ID', 'LD6', 'Position', [3.75, 3.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD7 = struct('ID', 'LD7', 'Position', [6.25, 3.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD8 = struct('ID', 'LD8', 'Position', [8.75, 3.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD9 = struct('ID', 'LD9', 'Position', [1.25, 6.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD10 = struct('ID', 'LD10', 'Position', [3.75, 6.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD11 = struct('ID', 'LD11', 'Position', [6.25, 6.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD12 = struct('ID', 'LD12', 'Position', [8.75, 6.25, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD13 = struct('ID', 'LD13', 'Position', [1.25, 8.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD14 = struct('ID', 'LD14', 'Position', [3.75, 8.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD15 = struct('ID', 'LD15', 'Position', [6.25, 8.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
% LD16 = struct('ID', 'LD16', 'Position', [8.75, 8.75, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);


%% 25个LD的分布
LD1 = struct('ID', 'LD1', 'Position', [1, 1, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD2 = struct('ID', 'LD2', 'Position', [3, 1, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD3 = struct('ID', 'LD3', 'Position', [5, 1, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD4 = struct('ID', 'LD4', 'Position', [7, 1, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD5 = struct('ID', 'LD5', 'Position', [9, 1, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD6 = struct('ID', 'LD6', 'Position', [1, 3, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD7 = struct('ID', 'LD7', 'Position', [3, 3, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD8 = struct('ID', 'LD8', 'Position', [5, 3, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD9 = struct('ID', 'LD9', 'Position', [7, 3, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD10 = struct('ID', 'LD10', 'Position', [9, 3, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD11 = struct('ID', 'LD11', 'Position', [1, 5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD12 = struct('ID', 'LD12', 'Position', [3, 5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD13 = struct('ID', 'LD13', 'Position', [5, 5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD14 = struct('ID', 'LD14', 'Position', [7, 5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD15 = struct('ID', 'LD15', 'Position', [9, 5, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD16 = struct('ID', 'LD16', 'Position', [1, 7, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD17 = struct('ID', 'LD17', 'Position', [3, 7, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD18 = struct('ID', 'LD18', 'Position', [5, 7, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD19 = struct('ID', 'LD19', 'Position', [7, 7, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD20 = struct('ID', 'LD20', 'Position', [9, 7, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD21 = struct('ID', 'LD21', 'Position', [1, 9, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD22 = struct('ID', 'LD22', 'Position', [3, 9, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD23 = struct('ID', 'LD23', 'Position', [5, 9, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD24 = struct('ID', 'LD24', 'Position', [7, 9, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);
LD25 = struct('ID', 'LD25', 'Position', [9, 9, 3], 'isbusy', false, 'channel_gain',0, 'interference',0);

%% 36个LD的分布
% LD1 = struct('ID', 'LD1', 'Position', [0.835, 0.835, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD2 = struct('ID', 'LD2', 'Position', [0.835, 2.505, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD3 = struct('ID', 'LD3', 'Position', [0.835, 4.175, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD4 = struct('ID', 'LD4', 'Position', [0.835, 5.845, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD5 = struct('ID', 'LD5', 'Position', [0.835, 7.515, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD6 = struct('ID', 'LD6', 'Position', [0.835, 9.185, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD7 = struct('ID', 'LD7', 'Position', [2.505, 0.835, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD8 = struct('ID', 'LD8', 'Position', [2.505, 2.505, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD9 = struct('ID', 'LD9', 'Position', [2.505, 4.175, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD10 = struct('ID', 'LD10', 'Position', [2.505, 5.845, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD11 = struct('ID', 'LD11', 'Position', [2.505, 7.515, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD12 = struct('ID', 'LD12', 'Position', [2.505, 9.185, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD13 = struct('ID', 'LD13', 'Position', [4.175, 0.835, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD14 = struct('ID', 'LD14', 'Position', [4.175, 2.505, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD15 = struct('ID', 'LD15', 'Position', [4.175, 4.175, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD16 = struct('ID', 'LD16', 'Position', [4.175, 5.845, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD17 = struct('ID', 'LD17', 'Position', [4.175, 7.515, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD18 = struct('ID', 'LD18', 'Position', [4.175, 9.185, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD19 = struct('ID', 'LD19', 'Position', [5.845, 0.835, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD20 = struct('ID', 'LD20', 'Position', [5.845, 2.505, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD21 = struct('ID', 'LD21', 'Position', [5.845, 4.175, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD22 = struct('ID', 'LD22', 'Position', [5.845, 5.845, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD23 = struct('ID', 'LD23', 'Position', [5.845, 7.515, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD24 = struct('ID', 'LD24', 'Position', [5.845, 9.185, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD25 = struct('ID', 'LD25', 'Position', [7.515, 0.835, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD26 = struct('ID', 'LD26', 'Position', [7.515, 2.505, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD27 = struct('ID', 'LD27', 'Position', [7.515, 4.175, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD28 = struct('ID', 'LD28', 'Position', [7.515, 5.845, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD29 = struct('ID', 'LD29', 'Position', [7.515, 7.515, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD30 = struct('ID', 'LD30', 'Position', [7.515, 9.185, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD31 = struct('ID', 'LD31', 'Position', [9.185, 0.835, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD32 = struct('ID', 'LD32', 'Position', [9.185, 2.505, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD33 = struct('ID', 'LD33', 'Position', [9.185, 4.175, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD34 = struct('ID', 'LD34', 'Position', [9.185, 5.845, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD35 = struct('ID', 'LD35', 'Position', [9.185, 7.515, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD36 = struct('ID', 'LD36', 'Position', [9.185, 9.185, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);



%% 49个LD的分布
% LD1 = struct('ID', 'LD1', 'Position', [0.715, 0.715, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD2 = struct('ID', 'LD2', 'Position', [0.715, 2.145, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD3 = struct('ID', 'LD3', 'Position', [0.715, 3.575, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD4 = struct('ID', 'LD4', 'Position', [0.715, 5.005, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD5 = struct('ID', 'LD5', 'Position', [0.715, 6.435, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD6 = struct('ID', 'LD6', 'Position', [0.715, 7.865, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD7 = struct('ID', 'LD7', 'Position', [0.715, 9.295, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD8 = struct('ID', 'LD8', 'Position', [2.145, 0.715, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD9 = struct('ID', 'LD9', 'Position', [2.145, 2.145, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD10 = struct('ID', 'LD10', 'Position', [2.145, 3.575, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD11 = struct('ID', 'LD11', 'Position', [2.145, 5.005, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD12 = struct('ID', 'LD12', 'Position', [2.145, 6.435, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD13 = struct('ID', 'LD13', 'Position', [2.145, 7.865, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD14 = struct('ID', 'LD14', 'Position', [2.145, 9.295, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD15 = struct('ID', 'LD15', 'Position', [3.575, 0.715, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD16 = struct('ID', 'LD16', 'Position', [3.575, 2.145, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD17 = struct('ID', 'LD17', 'Position', [3.575, 3.575, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD18 = struct('ID', 'LD18', 'Position', [3.575, 5.005, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD19 = struct('ID', 'LD19', 'Position', [3.575, 6.435, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD20 = struct('ID', 'LD20', 'Position', [3.575, 7.865, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD21 = struct('ID', 'LD21', 'Position', [3.575, 9.295, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD22 = struct('ID', 'LD22', 'Position', [5.005, 0.715, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD23 = struct('ID', 'LD23', 'Position', [5.005, 2.145, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD24 = struct('ID', 'LD24', 'Position', [5.005, 3.575, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD25 = struct('ID', 'LD25', 'Position', [5.005, 5.005, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD26 = struct('ID', 'LD26', 'Position', [5.005, 6.435, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD27 = struct('ID', 'LD27', 'Position', [5.005, 7.865, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD28 = struct('ID', 'LD28', 'Position', [5.005, 9.295, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD29 = struct('ID', 'LD29', 'Position', [6.435, 0.715, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD30 = struct('ID', 'LD30', 'Position', [6.435, 2.145, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD31 = struct('ID', 'LD31', 'Position', [6.435, 3.575, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD32 = struct('ID', 'LD32', 'Position', [6.435, 5.005, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD33 = struct('ID', 'LD33', 'Position', [6.435, 6.435, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD34 = struct('ID', 'LD34', 'Position', [6.435, 7.865, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD35 = struct('ID', 'LD35', 'Position', [6.435, 9.295, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD36 = struct('ID', 'LD36', 'Position', [7.865, 0.715, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD37 = struct('ID', 'LD37', 'Position', [7.865, 2.145, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD38 = struct('ID', 'LD38', 'Position', [7.865, 3.575, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD39 = struct('ID', 'LD39', 'Position', [7.865, 5.005, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD40 = struct('ID', 'LD40', 'Position', [7.865, 6.435, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD41 = struct('ID', 'LD41', 'Position', [7.865, 7.865, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD42 = struct('ID', 'LD42', 'Position', [7.865, 9.295, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD43 = struct('ID', 'LD43', 'Position', [9.295, 0.715, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD44 = struct('ID', 'LD44', 'Position', [9.295, 2.145, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD45 = struct('ID', 'LD45', 'Position', [9.295, 3.575, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD46 = struct('ID', 'LD46', 'Position', [9.295, 5.005, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD47 = struct('ID', 'LD47', 'Position', [9.295, 6.435, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD48 = struct('ID', 'LD48', 'Position', [9.295, 7.865, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);
% LD49 = struct('ID', 'LD49', 'Position', [9.295, 9.295, 3], 'isbusy', false, 'channel_gain', 0, 'interference', 0);



%RF AP位置参数
WIFI=[5,5,0];


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
% UE1 = struct('ID', 'User1', 'Position', [0.5, 9.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% % UE1 = struct('ID', 'User1', 'Position', [1, 9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE2 = struct('ID', 'User2', 'Position', [3, 3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE3 = struct('ID', 'User3', 'Position', [3.6, 8.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE4 = struct('ID', 'User4', 'Position', [8, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE5 = struct('ID', 'User5', 'Position', [5.4,1.2,1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE6 = struct('ID', 'User6', 'Position', [1, 1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE7 = struct('ID', 'User7', 'Position', [9, 1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE8 = struct('ID', 'User8', 'Position', [1.5, 6.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE9 = struct('ID', 'User9', 'Position', [9, 9.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% % UE9 = struct('ID', 'User9', 'Position', [9, 9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE10 = struct('ID', 'User10', 'Position', [4, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE11 = struct('ID', 'User11', 'Position', [6, 6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE12 = struct('ID', 'User12', 'Position', [4, 6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE13 = struct('ID', 'User13', 'Position', [6, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE14 = struct('ID', 'User14', 'Position', [3.3, 9.8, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE15 = struct('ID', 'User15', 'Position', [7, 3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE16 = struct('ID', 'User16', 'Position', [6.2, 7.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE17 = struct('ID', 'User17', 'Position', [2, 4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE18 = struct('ID', 'User18', 'Position', [9, 7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE19 = struct('ID', 'User19', 'Position', [3, 0.2, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE20 = struct('ID', 'User20', 'Position', [7, 5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE21 = struct('ID', 'User21', 'Position', [2.1, 2.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE22 = struct('ID', 'User22', 'Position', [4.8, 8.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE23 = struct('ID', 'User23', 'Position', [6.5, 2.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE24 = struct('ID', 'User24', 'Position', [1.8, 5.6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE25 = struct('ID', 'User25', 'Position', [8.2, 3.4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE26 = struct('ID', 'User26', 'Position', [5.1, 6.8, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE27 = struct('ID', 'User27', 'Position', [3.7, 7.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE28 = struct('ID', 'User28', 'Position', [7.4, 8.6, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE29 = struct('ID', 'User29', 'Position', [2.5, 4.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE30 = struct('ID', 'User30', 'Position', [6.9, 5.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE31 = struct('ID', 'User31', 'Position', [4.2, 2.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE32 = struct('ID', 'User32', 'Position', [8.7, 6.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE33 = struct('ID', 'User33', 'Position', [3.1, 8.4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE34 = struct('ID', 'User34', 'Position', [5.6, 3.8, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE35 = struct('ID', 'User35', 'Position', [2.9, 6.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE36 = struct('ID', 'User36', 'Position', [7.2, 7.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE37 = struct('ID', 'User37', 'Position', [4.6, 4.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE38 = struct('ID', 'User38', 'Position', [6.3, 1.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE39 = struct('ID', 'User39', 'Position', [1.3, 7.2, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE40 = struct('ID', 'User40', 'Position', [8.4, 5.4, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE41 = struct('ID', 'User41', 'Position', [5.3, 9.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE42 = struct('ID', 'User42', 'Position', [3.5, 3.2, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE43 = struct('ID', 'User43', 'Position', [7.8, 8.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE44 = struct('ID', 'User44', 'Position', [2.3, 5.1, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE45 = struct('ID', 'User45', 'Position', [6.7, 4.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE46 = struct('ID', 'User46', 'Position', [4.1, 8.7, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE47 = struct('ID', 'User47', 'Position', [8.1, 2.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE48 = struct('ID', 'User48', 'Position', [2.7, 6.9, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE49 = struct('ID', 'User49', 'Position', [5.8, 3.5, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% UE50 = struct('ID', 'User50', 'Position', [7.5, 7.3, 1],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
% % 原始UE列表
% all_UEs = [UE1, UE2, UE3, UE4, UE5, UE6, UE7, UE8, UE9, UE10, UE11, UE12, UE13,UE14,UE15,UE16,UE17,UE18,UE19,UE20,UE21,UE22,UE23,UE24,UE25,UE26,UE27,UE28,UE29,UE30,UE31,UE32,UE33,UE34,UE35,UE36,UE37,UE38,UE39,UE40,UE41,UE42,UE43,UE44,UE45,UE46,UE47,UE48,UE49,UE50];

%待上链的请求用户列表
UE=[];

%最终被接受到区块中的用户
UE_accept=[];

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
        'transmissiondata', 0, ...
        'waittime', [], ...
        'request_time', 0, ...
        'Data', 0, ...
        'channel_gain', 0);
end


%% 选择LD
% LD参数
% all_LDs = [LD1; LD2; LD3; LD4; LD5; LD6; LD7; LD8; LD9; LD10; LD11; LD12; LD13; LD14; LD15; LD16; LD17; LD18; LD19; LD20; LD21; LD22; LD23; LD24; LD25; LD26; LD27; LD28; LD29; LD30; LD31; LD32; LD33];
% 使用的LD数
n_LD=25;
% 使用的LD组
% LD=[LD1; LD2; LD3; LD4]; % 4个LD
% LD=[LD1; LD2; LD3; LD4; LD5; LD6; LD7; LD8; LD9]; % 9个LD
% LD=[LD1; LD2; LD3; LD4; LD5; LD6; LD7; LD8; LD9; LD10; LD11; LD12; LD13; LD14; LD15; LD16];% 16个LD
LD=[LD1; LD2; LD3; LD4; LD5; LD6; LD7; LD8; LD9; LD10; LD11; LD12; LD13; LD14; LD15; LD16; LD17; LD18; LD19; LD20; LD21; LD22; LD23; LD24; LD25];% 25个LD
% LD=[LD1; LD2; LD3; LD4; LD5; LD6; LD7; LD8; LD9; LD10; LD11; LD12; LD13; LD14; LD15; LD16; LD17; LD18; LD19; LD20; LD21; LD22; LD23; LD24; LD25; LD26; LD27; LD28; LD29; LD30; LD31; LD32; LD33; LD34; LD35; LD36];% 36个LD
% LD=[LD1; LD2; LD3; LD4; LD5; LD6; LD7; LD8; LD9; LD10; LD11; LD12; LD13; LD14; LD15; LD16; LD17; LD18; LD19; LD20; LD21; LD22; LD23; LD24; LD25; LD26; LD27; LD28; LD29; LD30; LD31; LD32; LD33; LD34; LD35; LD36; LD37; LD38; LD39; LD40; LD41; LD42; LD43; LD44; LD45; LD46; LD47; LD48; LD49];% 49个LD
% LD位置参数
LDlocation=[];
for i=1:numel(LD)
    LDlocation=[LDlocation;LD(i).Position];
end


%% 请求被拒绝概率
all_request_num=0;%总请求数
reject_num=0;%被拒绝的请求数
%q_rejected=reject_num/max(1,all_request_num); %总的被拒绝的概率
reject_num_servicelist=0; %因为服务列表容量上限被拒绝
%q_rejected_servicelist=reject_num_servicelist/max(1,all_request_num) %因为服务列表容量上限被拒绝的概率
reject_num_fov=0;%因为视场范围内没有LD而被拒绝
%q_rejected_fov=reject_num_fov/max(1,all_request_num) %因为视场范围内没有LD而被拒绝的概率

%% 创立区块链
bc=BlockChain;
obj1=bc.blockArray(1)
m1=Miner(bc);
minerindex=1;

%% 开始迭代
round=10000;%出块总数，即迭代轮数
AllocatedUser=[];%已分配用户
UEsample=struct('ID', [], 'Position', [0, 0, 0],'Confirmblock', [],'Rate',[],'Startime',[],'transmissiondata',0,'waittime',[],'request_time',0,'Data',0,'channel_gain',0);
Servicelists = repmat(UEsample, n_LD, round);%初始化服务列表，行为LD，列为服务顺序
serviceorder=ones(1,n_LD);%用于添加UE到服务列表中
servicerateorder=ones(1,n_LD);%用于添加UE传输速率到服务列表中
serviceorderindex=ones(1,n_LD);%用于LD根据服务列表提供服务时
transmissiontime=zeros(1,n_LD);%用于记录每个LD正在服务的时长
average_request=0 ;%平均上传请求的个数()
timeline=0;%时间轴
confirmtime=0;%预设的区块确认时间(一次确认，即出块就完成确认)


% 多余的传输时间
more_transmissiontime=zeros(1,n_LD);

% 用于画直方图
block_time_table=zeros(round,1);

%用于判断是否该上传请求
timeslot=0;
% round_time=0.073242187;%与chainxim一致
real_round_time=0.1;%与chainxim一致，本次仿真不变
round_time=real_round_time;%用于后续仿真，可能会变
each_block_round=0;
each_block_time=0;
request_round=100;
traffic_intensity=0.01; %平均request_round轮上传一次请求

if ~isempty(getenv('BHLW_SMOKE_BLOCKS')), round=str2double(getenv('BHLW_SMOKE_BLOCKS')); end
while minerindex <= round
    fprintf('第%d次出块周期：\n',minerindex);
    %出块时间
    blocktime= exprnd(12); %均值为12的指数分布
    block_time_table(minerindex)=blocktime;
    while each_block_time<blocktime
        % 轮次++
        each_block_time=each_block_time+round_time;

        %如果超过了出块时间，则将eachblocktime设置为blocktime
        if each_block_time>blocktime
            round_time=blocktime-(each_block_time-round_time);
            each_block_time=blocktime;
        end

        %% 判断是否该上传请求（从每个用户的角度）
        delete_indices=[];
        for i = 1:numel(users)
            if rand <= traffic_intensity %如果低于流量密度，则上传请求
                % 用户上传请求
                % 记录上传请求时间
                users(i).request_time = timeline+each_block_time;

                % 输出用户ID和位置
                fprintf('第%d秒上传请求的用户为：\n',timeline+each_block_time);
                fprintf('User ID: %s, Position: %s\n', users(i).ID, mat2str(users(i).Position));

                % 把请求用户放进待上链用户组中
                UE = [UE, users(i)];

                % 准备在本次循环结束后从活跃用户组移除已上传的用户
                delete_indices=[delete_indices,i];
            end
        end
        % 从users中移除已经上传请求的用户
        users(delete_indices) = [];

        %% 遍历LD状态
        for i=1:length(LD)
            %如果LD繁忙
            if LD(i).isbusy==true
                %更新链路所受干扰
                LD(i).interference=0;
                for k=1:length(LD)
                    % 干扰来自其他所有LD
                    if (~strcmp(LD(k).ID,LD(i).ID)) && LD(k).isbusy==true   %%%%干扰是来自其他正在工作的灯，而非其他链路，因此增益是用户与其他灯之间的增益！！！！
                        %LD与用户垂直距离
                        dh=2;
                        %直线距离
                        d_interference=norm(LD(k).Position - Servicelists(i, serviceorderindex(i)).Position);
                        radiation_angle_interference = acos(dh/d_interference);%计算出射角
                        radiation_angle_interference = rad2deg(radiation_angle_interference);%转换为角度
                        incident_angle_interference = radiation_angle_interference;%计算入射角
                        %计算VLC信道增益
%                         m=(-log(2))/log(cosd(thetahalf));

                        G=((m+1)*Apd)/(2*pi*(d_interference^2));
                        if incident_angle_interference<=fov
                            channel_gain=G*((cosd(radiation_angle_interference))^m)*cosd(incident_angle_interference);
                        else
                            channel_gain=0;
                        end
                        LD(i).interference=LD(i).interference+channel_gain*channel_gain*PLD*PLD*Rpd*Rpd;
                    end
                end

                %更新传输速率
                r=(LD(i).channel_gain)*(LD(i).channel_gain)*PLD*PLD*Rpd*Rpd;
%                 R=B2*log2(1+r/(B2*sigma22));
                R=B2*log2(1+r/(B2*sigma22+LD(i).interference));
                R=R/10^6;
                Servicelists(i, serviceorderindex(i)).Rate=R;


                %进行round_time的传输
                Servicelists(i, serviceorderindex(i)).transmissiondata=Servicelists(i, serviceorderindex(i)).transmissiondata+round_time*Servicelists(i, serviceorderindex(i)).Rate;

                %然后判断是否已经传输结束
                if Servicelists(i, serviceorderindex(i)).transmissiondata>=Servicelists(i, serviceorderindex(i)).Data
                    %传输结束后，状态变为空闲
                    LD(i).isbusy=false;
                    %LD信道增益清零
                    LD(i).channel_gain=0;
                    %最重要的是，把传输结束的UE记录在AllocatedUser
                    AllocatedUser=[AllocatedUser,Servicelists(i, serviceorderindex(i))];
                    %同样，把服务完的用户清空数据字段后，重新添加到users中
                    finisheduser=Servicelists(i, serviceorderindex(i));
                    finisheduser.Confirmblock=[];
                    finisheduser.Rate=[];
                    finisheduser.Startime=[];
                    finisheduser.transmissiondata=0;
                    finisheduser.waittime=[];
                    finisheduser.request_time=0;
                    finisheduser.Data=0;
                    finisheduser.channel_gain=0;
                    %用户位置随机改变%
                    finisheduser.Position = [rand() * 10, rand() * 10,1];
                    % 把用户放入活跃用户组中
                    users=[users,finisheduser];
                    %服务顺序++
                    serviceorderindex(i)=serviceorderindex(i)+1;
                end
                %如果还在传输，则除了加传输时间外不做任何操作
            end


            %如果LD空闲（注意，刚刚由繁忙变空闲的LD可以立刻执行这段代码）
            if LD(i).isbusy==false
                %如果服务列表中有用户且确认区块数满足，则开始提供服务
                if ~isempty(Servicelists(i, serviceorderindex(i)).ID) && Servicelists(i, serviceorderindex(i)).Confirmblock >= confirmtime
                    data_size_bit = randi([1000, 10000]);
                    Servicelists(i, serviceorderindex(i)).Data=data_size_bit;
                    fprintf('%s-LD%d链路传输数据包大小：%d Mbit\n', Servicelists(i, serviceorderindex(i)).ID, i, data_size_bit);
                    Servicelists(i, serviceorderindex(i)).Startime=timeline+each_block_time;
                    Servicelists(i, serviceorderindex(i)).waittime=Servicelists(i, serviceorderindex(i)).Startime-Servicelists(i, serviceorderindex(i)).request_time;
                    %serviceorderindex(i)的递增在传输完成后进行
                    %LD状态设为繁忙
                    LD(i).isbusy=true;
                    %记录链路的信道增益
                    LD(i).channel_gain=Servicelists(i, serviceorderindex(i)).channel_gain;
                end
            end
            
            %结束LD状态遍历
        end

    end
    % 本次出块所有判断结束，用于记录时间进度的参数清零，round_time也重新设置
    each_block_time=0; 
    round_time=real_round_time;
    fprintf('\n');

    %% 更新时间轴
    timeline=timeline+blocktime;


    %% 执行合约，得到分配结果，然后更新服务列表
    fprintf('利用mindistance算法自动为用户分配下行传输LD：\n');
    %读取待上链请求用户组中的所有用户
    numUsers=numel(UE);
    % 累加总请求个数
    all_request_num=all_request_num+numUsers;
    if numUsers~=0 %只有存在上传请求的用户时才更新服务列表
        % 计算UE与LD的距离
        UEposition=zeros(numUsers,3);
        for i=1:numUsers
            UEposition(i,:)=UE(i).Position;
        end
        distances = pdist2(UEposition, LDlocation);

        % 利用最短距离原则为UE配对LD
        [~, LD_indices] = min(distances, [], 2);
        % 最终上链的请求所配对的LD
        LD_indices_accept=[];
        % 显示UE与配对的LD
        for i = 1:length(LD_indices)
            % 判断服务列表中尚未完成服务的用户是否大于等于三个
            if serviceorder(LD_indices(i))-serviceorderindex(LD_indices(i)) < 3
                % 服务列表未满，接受此用户的请求
                %记录用户与配对LD的距离
                d=distances(i, LD_indices(i));
                fprintf('%s 与 LD%d 配对，距离为 %.2f\n', UE(i).ID, LD_indices(i), distances(i, LD_indices(i)));
                %更新该用户相关参数
                UE(i).Confirmblock=-1;%确认块数量，此时交易所在区块还未挖出，因此是-1，挖出后为0
%                 UE_accept=[UE_accept,UE(i)];%该用户为最终上链的用户
%                 LD_indices_accept=[LD_indices_accept,LD_indices(i)];%记录该用户配对的LD

                %计算信道增益
                %LD与用户垂直距离
                dh=2;
                radiation_angle = acos(dh/d);%计算出射角
                radiation_angle = rad2deg(radiation_angle);%转换为角度
                incident_angle = radiation_angle;%计算入射角
                %计算VLC信道增益
%                 m=(-log(2))/log(cosd(thetahalf));
                G=((m+1)*Apd)/(2*pi*(d^2));
                if incident_angle<=fov
                    h2=G*((cosd(radiation_angle))^m)*cosd(incident_angle);
                else
                    h2=0;
                end
                UE(i).channel_gain=h2;
                
                %可能出现LD过少，用户过远，信道增益为0的情况
                if UE(i).channel_gain ~=0
                    %用户被记录在服务列表中
                    Servicelists(LD_indices(i),serviceorder(LD_indices(i)))=UE(i);
                    serviceorder(LD_indices(i))=serviceorder(LD_indices(i))+1;%更新服务列表中的顺序，下一次再写入UE就会在后面
                else
                    %信道增益为0，也拒绝用户
                    fprintf('%s 的请求被拒绝\n', UE(i).ID);
                    % 累加拒绝的请求个数
                    reject_num=reject_num+1;
                    reject_num_fov=reject_num_fov+1;
                    % 用户随机改变位置，清空参数，并被重新放回活跃用户组中
                    UE(i).Position = [rand() * 10, rand() * 10,1];
                    UE(i).Confirmblock=[];
                    UE(i).Rate=[];
                    UE(i).Startime=[];
                    UE(i).transmissiondata=0;
                    UE(i).waittime=[];
                    UE(i).request_time=0;
                    UE(i).Data=0;
                    UE(i).channel_gain=0;
                    users=[users,UE(i)];
                end
            else
                % 服务列表已满，拒绝此用户的请求
                fprintf('%s 的请求被拒绝\n', UE(i).ID);
                % 累加拒绝的请求个数
                reject_num=reject_num+1;
                reject_num_servicelist=reject_num_servicelist+1;
                % 用户随机改变位置，清空参数，并被重新放回活跃用户组中
                UE(i).Position = [rand() * 10, rand() * 10,1];
                UE(i).Confirmblock=[];
                UE(i).Rate=[];
                UE(i).Startime=[];
                UE(i).transmissiondata=0;
                UE(i).waittime=[];
                UE(i).request_time=0;
                UE(i).Data=0;
                UE(i).channel_gain=0;
                users=[users,UE(i)];
            end
        end

        %清空UE，重新接受请求
        UE=[];
        %请求被接受的用户个数
        numUsers_accept=numel(UE_accept);
        % 把UE_accept清空
        UE_accept=[];
    end

    fprintf('\n');
   

    %% 出块
    transcation={'None'};
    LDcondition={'None'};
    m1.mine(transcation,LDcondition);
    minerindex=minerindex+1;
    %服务列表中所有非空元素的确认区块数+1
    for i = 1:size(Servicelists, 1)
        for j = 1:size(Servicelists, 2)
            if ~isempty(Servicelists(i, j).ID)
                Servicelists(i, j).Confirmblock = Servicelists(i, j).Confirmblock + 1;
            end
        end
    end
    %时间轴+blocktime秒
    fprintf('本次出块时间为: %.2f\n', blocktime);
    bc.blockArray(minerindex)



    fprintf('\n');
    fprintf('\n');
    fprintf('\n');


end





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
q_rejected=reject_num/max(1,all_request_num);%总拒绝概率
q_rejected_servicelist=reject_num_servicelist/max(1,all_request_num);%因为服务列表容量而被拒绝的概率
q_rejected_fov=reject_num_fov/max(1,all_request_num);%因为视场内没有LD而被拒绝的概率


% 计算平均出块时间
average_blocktime_calculated = mean(block_time_table);

