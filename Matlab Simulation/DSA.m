% B-HLW Security Assessment: Miner Competition Simulation (Monte Carlo)
clear; clc;

% --- 仿真参数设置 ---
n_values = [1, 3, 6];           % 不同的确认数 N
alpha0_range = 0.05:0.05:0.5;  % 攻击者算力占比 alpha0 (用于散点模拟)
alpha_smooth = 0:0.01:0.5;     % 用于绘制理论曲线的平滑序列
num_trials = 100000;             % 每组参数下的蒙特卡洛试验次数
Ng = 1000;                      % 允许的最大追赶差距

figure; hold on; grid on;box on;
colors = [
    214/255, 39/255, 40/255;   % 红色 - N=1
    31/255, 119/255, 180/255;  % 蓝色 - N=3
    44/255, 160/255, 44/255;   % 绿色 - N=6
];

for idx = 1:length(n_values)
    N = n_values(idx);
    
    % --- 1. 计算理论曲线 (用于对比) ---
    P_theory = zeros(size(alpha_smooth));
    for j = 1:length(alpha_smooth)
        a = alpha_smooth(j);
        if a >= 0.5
            P_theory(j) = 1.0;
        else
            % 理论概率公式
            sum_prob = 0;
            for nY = 0:N
                comb = nchoosek(nY + N - 1, nY);
                term = comb * (1-a)^N * a^nY * (1 - (a/(1-a))^(N-nY+1));
                sum_prob = sum_prob + term;
            end
            P_theory(j) = 1 - sum_prob;
        end
    end
    % 绘制理论实线
    plot(alpha_smooth, P_theory, 'Color', colors(idx,:), 'LineWidth', 1.5, ...
        'DisplayName', ['Theory (N=', num2str(N), ')']);

    % --- 2. 蒙特卡洛离散模拟 (计算点) ---
    P_simulated = zeros(size(alpha0_range));
    for j = 1:length(alpha0_range)
        alpha0_ratio = alpha0_range(j);  % 恶意矿工算力
        alpha1_ratio = 1 - alpha0_ratio; % 诚实矿工算力
        successCount = 0;
        
        for t = 1:num_trials
            honestBlocks = 0;
            attackerBlocks = 0;
            
            % --- 模拟挖矿过程 ---
            while true
                % 基础安全边界检查
                if alpha0_ratio == 0 && alpha1_ratio == 0, break; end
                if alpha1_ratio == 0 && alpha0_ratio == 1, successCount = successCount + 1; break; end
                if alpha0_ratio == 0 && alpha1_ratio == 1, break; end

                % 算力竞争
                if rand() <= alpha0_ratio
                    attackerBlocks = attackerBlocks + 1;
                else
                    honestBlocks = honestBlocks + 1;
                end

                % 攻击成功：攻击链反超且诚实链已达确认数 N
                if attackerBlocks > honestBlocks && honestBlocks >= N
                    successCount = successCount + 1;
                    break;
                end

                % 攻击失败：落后达到 Ng
                if honestBlocks - attackerBlocks >= Ng
                    break;
                end
            end
        end
        P_simulated(j) = successCount / num_trials;
    end
    
    % --- 3. 绘制模拟点 (按照要求改用 plot 并使用 'o' 标记) ---
    % 'linestyle', 'none' 确保点之间不连线
    plot(alpha0_range, P_simulated, 'o', 'LineWidth', 2, 'Color', colors(idx,:),'DisplayName', ['Simulation (N=', num2str(N), ')']);
end

% --- 图表美化 ---
xlabel('Attacker Hash Power Fraction $\alpha$',Interpreter='latex');
ylabel('Attack Success Probability');
xlim([0 0.5]); ylim([0 1]);


% 用于补充图例
h1 = plot(NaN, NaN, '-o', 'Color', colors(1,:), 'LineWidth', 2); % N=1
h2 = plot(NaN, NaN, '-o', 'Color', colors(2,:), 'LineWidth', 2); % N=3
h3 = plot(NaN, NaN, '-o', 'Color', colors(3,:), 'LineWidth', 2); % N=6


h_theo = plot(NaN, NaN, '-', 'Color', 'k', 'LineWidth', 2); % Theo
h_sim = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Sim

hold off;

grid on;
box on;

% 设置第一个图例
legend1 = legend([h1, h2, h3], {'N=1', 'N=3', 'N=6'}, 'Location', 'best');

% 创建不可见的坐标轴用于第二个图例 - 分析方法
axes2 = axes('Position', get(gca, 'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h_theo, h_sim], {'Analytical', 'Simulation'}, 'Location', 'southeast');
legend2 = legend(axes2, [h_theo, h_sim], {'Analytical', 'Simulation'}, 'Location', 'southeast');

% PrintFigToPaper('-depsc', 'Blockchain Attack', 16, 'Times New Roman', 7, 1, 0, 0, 0, 0);