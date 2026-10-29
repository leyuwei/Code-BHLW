clear all; close all; clc;
% 基本参数
fov_values = [10,30,60];
PLD_values = 1:1:14;
N_runs = 1000000; % 攻击者随机位置次数
% VLC参数
Apd = 10^-4;
sigma22 = 10^-21;
m = 10;
Rpd = 1;
B2 = 100e6;
% 位置参数
roomSize = [10, 10, 3];
LD_pos = [5, 5, 3];
user_pos = [5, 5, 1]; % 用户固定位置
UE_height = 1;
%% 计算攻击者平均传输速率（蒙特卡洛）
mean_attacker_rate = zeros(length(PLD_values), length(fov_values));
for p_idx = 1:length(PLD_values)
    PLD = PLD_values(p_idx);
   
    for f_idx = 1:length(fov_values)
        fov = fov_values(f_idx);
       
        total_rate = 0;
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
                    rate = B2 * log2(1 + SNR_linear);
                else
                    rate = 0;
                end
            else
                rate = 0;
            end
           
            total_rate = total_rate + rate;
        end
       
        mean_attacker_rate(p_idx, f_idx) = total_rate / N_runs;
    end
end
%% 计算用户传输速率（固定位置[5,5,1]，用户FoV=30°）
user_rate = zeros(length(PLD_values), 1);
for p_idx = 1:length(PLD_values)
    PLD = PLD_values(p_idx);
   
    d = norm(LD_pos - user_pos);
    dh = LD_pos(3) - user_pos(3);
   
    if d > 0
        angle = acos(dh/d);
        angle_deg = rad2deg(angle);
       
        fov = 30;
       
        if angle_deg <= fov
            G = ((m+1) * Apd) / (2 * pi * (d^2));
            h = G * (cosd(angle_deg)^m) * cosd(angle_deg);
            Pr = (h^2) * (PLD^2) * (Rpd^2);
            SNR_linear = Pr / (B2 * sigma22);
            rate = B2 * log2(1 + SNR_linear);
        else
            rate = 0;
        end
    else
        rate = 0;
    end
   
    user_rate(p_idx) = rate;
end

%% 计算安全速率
secure_rate = zeros(length(PLD_values), length(fov_values));
for p_idx = 1:length(PLD_values)
    for f_idx = 1:length(fov_values)
        secure_rate(p_idx, f_idx) = user_rate(p_idx) - mean_attacker_rate(p_idx, f_idx);
    end
end
%% 转换为Gbps
secure_rate_Gbps = secure_rate / 1e9;

%% 绘图（仅主图）
figure;
hold on;
colors = [
    214/255, 39/255, 40/255; % 红色
    31/255, 119/255, 180/255; % 蓝色
    44/255, 160/255, 44/255; % 绿色
];
% 画安全速率曲线（三条不同攻击者FoV）
for f_idx = 1:length(fov_values)
    plot(PLD_values, secure_rate_Gbps(:, f_idx), '-o', 'Color', colors(f_idx,:), 'LineWidth', 2, ...
        'DisplayName', sprintf('FoV=%d°', fov_values(f_idx)));
end
xlabel('$P_{LD}$ (W)','Interpreter', 'latex');
ylabel('Secrecy Rate (Gbps)');
legend('Location', 'west');
grid on;
box on;
xlim([1,14])
set(gca, 'FontSize', 12);

PrintFigToPaper('-depsc', 'Secrecy_Rate', 16, 'Times New Roman', 7, 1, 0, 0, 0, 0);