%% B-HLW抗窃听性能分析
clear all; close all; clc;

% 基本参数
fov_values = [10,30,60];        
PLD_values = 1:1:14; 
N_runs = 1000000;  % 攻击者随机位置次数

% VLC参数
Apd = 10^-4;     
sigma22 = 10^-21; 
m = 10;          
Rpd = 1;         
B2 = 100e6;      

% 位置参数
roomSize = [10, 10, 3];
LD_pos = [5, 5, 3];        
user_pos = [5, 5, 1];  % 用户固定位置
UE_height = 1;             

%% 计算攻击者平均线性SNR（蒙特卡洛）
mean_attacker_SNR_linear = zeros(length(PLD_values), length(fov_values));

for p_idx = 1:length(PLD_values)
    PLD = PLD_values(p_idx);
    
    for f_idx = 1:length(fov_values)
        fov = fov_values(f_idx);
        
        total_SNR = 0;
        rand_x = roomSize(1) * rand(N_runs, 1);
        rand_y = roomSize(2) * rand(N_runs, 1);
        
        for run = 1:N_runs
            attacker_pos = [rand_x(run), rand_y(run), UE_height];
            d = norm(LD_pos - attacker_pos);
            dh = LD_pos(3) - attacker_pos(3);
            
            if d > 0
                angle = acos(dh/d);
                angle_deg = rad2deg(angle);
                
                if angle_deg <= fov
                    G = ((m+1) * Apd) / (2 * pi * (d^2));
                    h = G * (cosd(angle_deg)^m) * cosd(angle_deg);
                    Pr = (h^2) * (PLD^2) * (Rpd^2);
                    SNR_linear = Pr / (B2 * sigma22);
                else
                    SNR_linear = 0;
                end
            else
                SNR_linear = 0;
            end
            
            total_SNR = total_SNR + SNR_linear;
        end
        
        mean_attacker_SNR_linear(p_idx, f_idx) = total_SNR / N_runs;
    end
end

%% 计算用户SNR（固定位置[5,5,1]，用户只有一个FoV值，用fov=30°）
user_SNR_linear = zeros(length(PLD_values), 1);

for p_idx = 1:length(PLD_values)
    PLD = PLD_values(p_idx);
    
    % 用户固定位置参数
    d = norm(LD_pos - user_pos);  % 用户-LD距离
    dh = LD_pos(3) - user_pos(3);  % 垂直高度差
    
    if d > 0
        angle = acos(dh/d);
        angle_deg = rad2deg(angle);
        
        % 用户使用30°FoV
        fov = 30;
        
        if angle_deg <= fov
            G = ((m+1) * Apd) / (2 * pi * (d^2));
            h = G * (cosd(angle_deg)^m) * cosd(angle_deg);
            Pr = (h^2) * (PLD^2) * (Rpd^2);
            SNR_linear = Pr / (B2 * sigma22);
        else
            SNR_linear = 0;
        end
    else
        SNR_linear = 0;
    end
    
    user_SNR_linear(p_idx) = SNR_linear;
end

%% 转换为dB（避免log10(0)）
% 设置一个非常小的值，用于替换0，以便计算对数
EPS = 1e-30;

% 攻击者SNR转换为dB
mean_attacker_SNR_dB = 10 * log10(max(mean_attacker_SNR_linear, EPS));

% 用户SNR转换为dB
user_SNR_dB = 10 * log10(max(user_SNR_linear, EPS));

%% 绘图
figure;
hold on;

colors = [
    214/255, 39/255, 40/255;   % 红色 - N=1, w=0.8
    31/255, 119/255, 180/255;  % 蓝色 - N=1, w=0.85
    44/255, 160/255, 44/255;   % 绿色 - N=1, w=0.9
];

% 画攻击者曲线（三条不同FoV）
for f_idx = 1:length(fov_values)
    plot(PLD_values, mean_attacker_SNR_dB(:, f_idx), '--o', 'Color', colors(f_idx,:), 'LineWidth', 2, ...
        'DisplayName', sprintf('Attacker (FoV=%d°)', fov_values(f_idx)));
end

% 画用户曲线（一条，用黑色虚线）
plot(PLD_values, user_SNR_dB, 'k-o', 'LineWidth', 2, 'DisplayName', 'User');

xlabel('$P_{LD}$ (W)','Interpreter', 'latex');
ylabel('SNR (dB)');
legend('Location', 'west');
grid on;
box on;
xlim([1,14])

% 创建局部放大图
axes('Position',[0.6,0.17,0.25,0.25]);   % 右下角
hold on;

% 局部放大区域：功率范围7-14W，SNR范围-5到10 dB
zoom_x_range = PLD_values >= 9 & PLD_values <= 11;
zoom_plot_x = PLD_values(zoom_x_range);

for f_idx = 1:length(fov_values)
    zoom_data = mean_attacker_SNR_dB(zoom_x_range, f_idx);
    plot(zoom_plot_x, zoom_data, '--o', 'Color', colors(f_idx,:), 'LineWidth', 2);
end


% 设置局部放大图的属性
grid on;
box on;
xlim([9.95,10.05]);
ylim([42.8, 43.1]); % 调整Y轴范围以显示差异


% 在主图上添加放大区域指示框
set(gca, 'FontSize', 12);  % 坐标轴刻度字体大小
main_axes = gca;
axes(main_axes);
rectangle('Position',[7,-5,7,15], 'EdgeColor','r', 'LineWidth',1, 'LineStyle','--');

PrintFigToPaper('-depsc', 'SNR_Comparison', 16, 'Times New Roman', 7, 1, 0, 0, 0, 0);