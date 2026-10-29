%% 吞吐量随LD数量
% LD_Num = [4 9 16 25 36 49];
% Matlab_100 = [7.3693 16.565 29.313 22.63 16.173 13.273];
% Matlab_80 = [7.349 16.493 28.962 23.71 16.684 13.9];
% Matlab_50 = [7.2002 15.702 25.73 23.707 16.887 13.442];
% Matlab_30 = [6.4931 12.94 19.418 19.612 15.74 12.799];
% Chainxim_100 = [7.38 16.65 29.4 22.43 16.573 13.673];
% Chainxim_80 = [7.345 16.51 29.062 24.11 16.884 14.1];
% Chainxim_50 = [7.23 15.702 26.13 23.807 17.087 13.642];
% Chainxim_30 = [6.51 12.94 19.57 19.312 16.24 12.819];
% 
% % 创建图形窗口
% figure;
% 
% % 绘制5条折线
% h1=plot(LD_Num, Matlab_100, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(LD_Num, Matlab_80, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(LD_Num, Matlab_50, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h4=plot(LD_Num, Matlab_30, '-', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h5=plot(LD_Num, Chainxim_100, 'o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h6=plot(LD_Num, Chainxim_80, '^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h7=plot(LD_Num, Chainxim_50, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h8=plot(LD_Num, Chainxim_30, 'd', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% %用于补充图例
% h9=plot(NaN, NaN, '-o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);% User Num=100
% h10=plot(NaN, NaN, '-^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);% User Num=80
% h11=plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);% User Num=50
% h12=plot(NaN, NaN, '-d', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);% User Num=20
% h13 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h14 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('LD Number');
% ylabel('Throughput (Gbps)');
% % title('Traffic Intensity = 0.01');
% xlim([0,50]);
% grid on;
% 
% ax = gca; % gca 获取当前坐标轴
% % set(ax, 'YLim', [5, 32]); % 设置 y 轴范围
% 
% % 设置图例
% legend1 = legend([h9,h10,h11,h12],{'#User=100', '#User=80', '#User=50', '#User=30'}, 'Position', [0.655 0.667 0.2 0.2]);
% 
% % 创建不可见的坐标轴用于第二个图例
% % axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% % legend2 = legend(axes2, [h13,h14], {'Matlab', 'Chainxim'}, 'Position', [0.72 0.24 0.1 0.1]); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 12);
% grid on;


%% 等待时间随LD数量
% LD_Num = [4 9 16 25 36 49];
% Matlab_100 = [66.5084 65.521 62.6943 111.9582 184.9506 222.3531];
% Matlab_80 = [64.2983 61.772 57.9804 91.4844 139.1849 159.9198];
% Matlab_50 = [57.567 52.2358 44.2397 54.5815 77.7863 91.4736];
% Matlab_30 = [45.6154 38.3826 31.6368 34.4353 42.6262 49.1757];
% Chainxim_100 = [66.4084 65.121 63.1943 112.1582 185.2506 223.0531];
% Chainxim_80 = [65.0983 62.172 58.1804 92.0844 139.8849 159.0198];
% Chainxim_50 = [57.967 51.9358 43.9397 53.9815 78.1863 92.0736];
% Chainxim_30 = [45.8154 38.6826 30.9368 35.0353 43.1262 49.0757];
% 
% % 创建图形窗口
% figure;
% 
% % 绘制5条折线
% h1=plot(LD_Num, Matlab_100, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(LD_Num, Matlab_80, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(LD_Num, Matlab_50, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h4=plot(LD_Num, Matlab_30, '-', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h5=plot(LD_Num, Chainxim_100, 'o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h6=plot(LD_Num, Chainxim_80, '^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h7=plot(LD_Num, Chainxim_50, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h8=plot(LD_Num, Chainxim_30, 'd', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% %用于补充图例
% h9=plot(NaN, NaN, '-o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);% User Num=100
% h10=plot(NaN, NaN, '-^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);% User Num=80
% h11=plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);% User Num=50
% h12=plot(NaN, NaN, '-d', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);% User Num=20
% h13 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h14 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('LD Number');
% ylabel('Average Waiting Time (s)');
% % title('Traffic Intensity = 0.01');
% grid on;
% 
% % 获取当前坐标轴句柄
% ax = gca; % gca 获取当前坐标轴
% % set(ax, 'YLim', [50, 420]); % 设置 y 轴范围
% 
% % 设置图例
% legend1 = legend([h9,h10,h11,h12],{'#User=100', '#User=80', '#User=50', '#User=30'}, 'Position', [0.33 0.755 0.2 0.15],'NumColumns',2);
% 
% % 创建不可见的坐标轴用于第二个图例
% % axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% % legend2 = legend(axes2, [h13,h14], {'Matlab', 'Chainxim'}, 'Position', [0.33 0.165 0.1 0.1],'Orientation', 'horizontal'); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 12);
% grid on;


%% 拒绝概率随LD数量(折线)
% LD_Num = [4 9 16 25 36 49];
% Matlab_100 = [0.9673 0.914 0.8072 0.7487 0.5984 0.3845];
% Matlab_80 = [0.9584 0.8873 0.7301 0.5951 0.4232 0.2722];
% Matlab_50 = [0.9299 0.7976 0.5306 0.3047 0.1892 0.1221];
% Matlab_30 = [0.8861 0.6959 0.4003 0.1477 0.0622 0.045];
% Chainxim_100 = [0.968 0.921 0.8165 0.755 0.6084 0.3755];
% Chainxim_80 = [0.961 0.8793 0.7351 0.5841 0.4312 0.2832];
% Chainxim_50 = [0.9309 0.7926 0.5316 0.3127 0.1922 0.1231];
% Chainxim_30 = [0.8911 0.6979 0.4093 0.1497 0.0702 0.051];
% 
% % 创建图形窗口
% figure;
% 
% % 绘制5条折线
% h1=plot(LD_Num, Matlab_100, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(LD_Num, Matlab_80, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(LD_Num, Matlab_50, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h4=plot(LD_Num, Matlab_30, '-', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h5=plot(LD_Num, Chainxim_100, 'o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h6=plot(LD_Num, Chainxim_80, '^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h7=plot(LD_Num, Chainxim_50, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h8=plot(LD_Num, Chainxim_30, 'd', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% %用于补充图例
% h9=plot(NaN, NaN, '-o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);% User Num=100
% h10=plot(NaN, NaN, '-^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);% User Num=80
% h11=plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);% User Num=50
% h12=plot(NaN, NaN, '-d', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);% User Num=20
% h13 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h14 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('LD Number');
% ylabel('Rejection Probability');
% % title('Traffic Intensity = 0.01');
% grid on;
% 
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h9,h10,h11,h12],{'#User=100', '#User=80', '#User=50', '#User=30'}, 'Position', [0.721 0.74 0.1 0.1]);
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h13,h14], {'Matlab', 'Chainxim'}, 'Position', [0.212 0.191 0.1 0.1]); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 12);
% grid on;


%% 拒绝概率随LD数量(柱状)
% LD_Num = [4 9 16 25 36 49];
% Matlab_p1_100 = [0.8037 0.7742 0.7133 0.7197 0.5991 0.3871];
% Matlab_p1_80 = [0.7516 0.6978 0.5958 0.5620 0.4220 0.2722];
% Matlab_p1_50 = [0.5795 0.4653 0.2971 0.2483 0.1845 0.1221];
% Matlab_p1_30 = [0.3155 0.1929 0.1003 0.081 0.0654 0.0416];
% 
% Matlab_p2_100 = [0.1633 0.1408 0.0943 0.0203 0.0003 0];
% Matlab_p2_80 = [0.2072 0.1884 0.1330 0.0321 0.0005 0];
% Matlab_p2_50 = [0.3497 0.3324 0.2301 0.0542 0.0007 0];
% Matlab_p2_30 = [0.5708 0.5025 0.2949 0.0669 0.0008 0];
% 
% 
% % 创建堆叠柱状图
% figure;
% % 设置 x 位置
% x_positions = 1:length(LD_Num);  % LD 的位置
% bar_width = 0.15;  % 调整柱子的宽度
% 
% hold on;
% 
% % 绘制每组数据的堆叠柱状图
% data_100 = [Matlab_p2_100; Matlab_p1_100];
% data_80 = [Matlab_p2_80; Matlab_p1_80];
% data_50 = [Matlab_p2_50; Matlab_p1_50];
% data_30 = [Matlab_p2_30; Matlab_p1_30];
% 
% % 绘制堆叠柱状图
% hBar100 = bar(x_positions - 0.3, data_100, 'stacked', 'BarWidth', bar_width, 'DisplayName', '100');
% hBar80 = bar(x_positions - 0.1, data_80, 'stacked', 'BarWidth', bar_width, 'DisplayName', '80');
% hBar50 = bar(x_positions + 0.1, data_50, 'stacked', 'BarWidth', bar_width, 'DisplayName', '50');
% hBar30 = bar(x_positions + 0.3, data_30, 'stacked', 'BarWidth', bar_width, 'DisplayName', '30');
% 
% % %用于补充图例
% h1=bar(NaN, NaN, 'FaceColor','flat','CData', [214/255, 39/255, 40/255]);% User Num=100
% h2=bar(NaN, NaN, 'FaceColor','flat','CData', [31/255, 119/255, 180/255]);% User Num=80
% h3=bar(NaN, NaN, 'FaceColor','flat','CData', [44/255, 160/255, 44/255]);% User Num=50
% h4=bar(NaN, NaN, 'FaceColor','flat','CData', [255/255, 127/255, 14/255]);% User Num=20
% h5 = bar(NaN, NaN, 'FaceColor','flat','CData', [199/255, 199/255, 199/255]); % p1
% h6 = bar(NaN, NaN, 'FaceColor','flat','CData', [65/255, 68/255, 81/255]); % p2
% 
% 
% % 添加颜色
% colors = [
%     214/255 39/255 40/255;  % p2 100
%     255/255 152/255 150/255;  % p1 100
%     31/255 119/255 180/255;  % p2 80
%     174/255 199/255 232/255;  % p1 80
%     44/255 160/255 44/255;  % p2 50
%     152/255 223/255 138/255;  % p1 50
%     255/255 127/255 14/255;  % p2 30
%     255/255 187/255 120/255   % p1 30
% ];
% 
% % colors = [
% %     214/255 39/255 40/255; % p2 100
% %     255/255 180/255 180/255; % p1 100 (更淡)
% %     31/255 119/255 180/255; % p2 80
% %     200/255 220/255 250/255; % p1 80 (更淡)
% %     44/255 160/255 44/255; % p2 50
% %     200/255 240/255 200/255; % p1 50 (更淡)
% %     255/255 127/255 14/255; % p2 30
% %     255/255 200/255 160/255; % p1 30 (更淡)
% % ];
% 
% % 设置颜色
% for i = 1:length(hBar100)
%     hBar100(i).FaceColor = 'flat';
%     hBar100(i).CData = colors(i, :);
%     hBar80(i).FaceColor = 'flat';
%     hBar80(i).CData = colors(i + 2, :);
%     hBar50(i).FaceColor = 'flat';
%     hBar50(i).CData = colors(i + 4, :);
%     hBar30(i).FaceColor = 'flat';
%     hBar30(i).CData = colors(i + 6, :);
% end
% 
% 
% % 设置坐标轴标签和标题
% % 添加标签和标题
% xticks(x_positions);  % 设置横坐标刻度
% xticklabels(LD_Num);  % 设置横坐标标签为 LD_Num
% xlabel('LD Number');
% ylabel('Rejection Probability');
% % title('Traffic Intensity = 0.01');
% ylim([0 1.1]); % 设置
% % 设置坐标轴属性以显示右侧和上侧坐标轴
% set(gca, 'Box', 'on');  % 显示边框
% grid on;
% hold off;
% 
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h1,h2,h3,h4],{'#User=100', '#User=80', '#User=50', '#User=30'}, 'Position', [0.705 0.717 0.1 0.1]);
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h5,h6], {'p1', 'p2'}, 'Position', [0.792 0.48 0.1 0.1]); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 12);
% grid on;


%% 不同LD数量下，吞吐量随活跃用户数量
% UE_Num = [10 20 40 60 80 100 120];
% Matlab_4 = [3.1552 5.4078 6.9744 7.2863 7.349 7.3693 7.3858];
% Matlab_25 = [9.2344 15.687 22.381 24.607 23.71 22.63 22.109];
% Matlab_49 = [8.4137 11.65 13.176 13.455 13.9 13.273 13.173];
% Matlab_WiFi1 = [6.6654 10.268 10.268 10.301 10.281 10.293 10.227];
% Matlab_WiFi2 = [7.8048 10.909 10.907 10.912 10.912 10.9 10.909];
% 
% Chainxim_4 = [3.1552 5.4078 6.9744 7.2863 7.349 7.3693 7.3858];
% Chainxim_25 = [9.2344 15.687 22.381 24.607 23.71 22.63 22.109];
% Chainxim_49 = [8.4137 11.65 13.176 13.455 13.9 13.273 13.173];
% Chainxim_WiFi1 = [6.6654 10.268 10.268 10.301 10.281 10.293 10.227];
% Chainxim_WiFi2 = [7.8048 10.909 10.907 10.912 10.912 10.9 10.909];
% 
% 
% % 创建图形窗口
% figure;
% 
% % 绘制5条折线
% h1=plot(UE_Num, Matlab_25, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(UE_Num, Matlab_49, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(UE_Num, Matlab_4, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h4=plot(UE_Num, Matlab_WiFi1, '--', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h5=plot(UE_Num, Matlab_WiFi2, '--', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2);
% 
% h6=plot(UE_Num, Chainxim_25, 'p', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h7=plot(UE_Num, Chainxim_49, 'o', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h8=plot(UE_Num, Chainxim_4, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h9=plot(UE_Num, Chainxim_WiFi1, '^', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h10=plot(UE_Num, Chainxim_WiFi2, 'v', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2);
% %用于补充图例
% h11 = plot(NaN, NaN, '-p', 'Color', [214/255, 39/255, 40/255],'LineWidth', 2); % LD Num=25
% h12 = plot(NaN, NaN, '-o', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2); % LD Num=49
% h13 = plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2); % LD Num=4
% h14 = plot(NaN, NaN, '--^', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2); % WiFi1
% h15 = plot(NaN, NaN, '--v', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2); % WiFi2
% h16 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h17 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('User Number');
% ylabel('Throughput (Gbps)');
% % title('Traffic Intensity = 0.01');
% % ylim([0 27]); % 设置右侧y轴范围为0到0.15
% grid on;
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h12,h11,h13],{'#LD=49', '#LD=25', '#LD=4'}, 'Position', [0.7 0.62 0.15 0.2]);
% 
% % 创建不可见的坐标轴用于第二个图例
% % axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% % legend2 = legend(axes2, [h16,h17], {'Matlab', 'Chainxim'}, 'Position', [0.202 0.806 0.1 0.1]); 
% 
% % 创建不可见的坐标轴用于第三个图例
% axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend3 = legend(axes3, [h14,h15], {'WiFi-baseline1','WiFi-baseline2'}, 'Position', [0.62 0.25 0.15 0.1]); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 10);
% grid on;




%% 不同LD数量下，等待时间随活跃用户数量
% UE_Num = [10 20 40 60 80 100 120];
% Matlab_4 = [23.0582 35.3455 52.1734 60.7075 64.2983 66.5084 67.9275];
% Matlab_25 = [17.1982 24.9232 43.8197 65.5709 91.4844 111.9582 123.4988];
% Matlab_49 = [17.3717 30.5029 69.6844 115.3195 159.9198 222.3531 277.8888];
% Matlab_WiFi1 = [11.9835 24.3086 30.0494 30.2894 30.5713 30.8239 31.5098];
% Matlab_WiFi2 = [0 13.0579 14.7081 14.8808 14.9243 15.0412 15.0912];
% 
% Chainxim_4 = [23.0582 35.3455 52.1734 60.7075 64.2983 66.5084 67.9275];
% Chainxim_25 = [17.1982 24.9232 43.8197 65.5709 91.4844 111.9582 123.4988];
% Chainxim_49 = [17.3717 30 69.6844 115.3195 159.9198 222.3531 277.8888];
% Chainxim_WiFi1 = [11.9835 24.3086 30.0494 30.2894 30.5713 30.8239 31.5098];
% Chainxim_WiFi2 = [0 13.0579 14.7081 14.8808 14.9243 15.0412 15.0912];
% 
% 
% % 创建图形窗口
% figure;
% 
% % 绘制5条折线
% h1=plot(UE_Num, Matlab_25, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(UE_Num, Matlab_49, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(UE_Num, Matlab_4, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h4=plot(UE_Num, Matlab_WiFi1, '--', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h5=plot(UE_Num, Matlab_WiFi2, '--', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2);
% 
% h6=plot(UE_Num, Chainxim_25, 'p', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h7=plot(UE_Num, Chainxim_49, 'o', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h8=plot(UE_Num, Chainxim_4, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h9=plot(UE_Num, Chainxim_WiFi1, '^', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h10=plot(UE_Num, Chainxim_WiFi2, 'v', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2);
% %用于补充图例
% h11 = plot(NaN, NaN, '-p', 'Color', [214/255, 39/255, 40/255],'LineWidth', 2); % LD Num=25
% h12 = plot(NaN, NaN, '-o', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2); % LD Num=49
% h13 = plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2); % LD Num=4
% h14 = plot(NaN, NaN, '--^', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2); % WiFi1
% h15 = plot(NaN, NaN, '--v', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2); % WiFi2
% h16 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h17 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('User Number');
% ylabel('Average Waiting Time (s)');
% % title('Traffic Intensity = 0.01');
% % ylim([0 27]); % 设置右侧y轴范围为0到0.15
% grid on;
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h12,h11,h13,h14,h15],{'#LD=49', '#LD=25', '#LD=4','WiFi-baseline1','WiFi-baseline2'}, 'Position', [0.25 0.65 0.15 0.2]);
% 
% % 创建不可见的坐标轴用于第二个图例
% % axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% % legend2 = legend(axes2, [h16,h17], {'Matlab', 'Chainxim'}, 'Position', [0.23 0.456 0.1 0.1]); 
% 
% % 创建不可见的坐标轴用于第三个图例
% % axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% % legend3 = legend(axes3, [h14,h15], {'WiFi-baseline1','WiFi-baseline2'}, 'Position', [0.65 0.22 0.15 0.1]); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 10);
% grid on;


%% 不同LD数量下，拒绝概率随活跃用户数量(折线)
% UE_Num = [10 20 40 60 80 100 120];
% Matlab_4 = [0.8355 0.8556 0.9113 0.9421 0.9588 0.967 0.9732];
% Matlab_25 = [0.0753 0.099 0.2149 0.4006 0.5941 0.74 0.8319];
% Matlab_49 = [0.0012 0.0154 0.0081 0.1667 0.2722 0.3845 0.5225];
% Matlab_WiFi1 = [0 0.449 0.85 0.9142 0.9395 0.9531 0.9617];
% Matlab_WiFi2 = [0 0.6309 0.9206 0.9558 0.9693 0.9766 0.9811];
% 
% Chainxim_4 = [0.8355 0.8556 0.9113 0.9421 0.9588 0.967 0.9732];
% Chainxim_25 = [0.0753 0.099 0.2149 0.4006 0.5941 0.74 0.8319];
% Chainxim_49 = [0.0012 0.0154 0.0081 0.1667 0.2722 0.3845 0.5225];
% Chainxim_WiFi1 = [0 0.449 0.85 0.9142 0.9395 0.9531 0.9617];
% Chainxim_WiFi2 = [0 0.6309 0.9206 0.9558 0.9693 0.9766 0.9811];
% 
% 
% % 创建图形窗口
% figure;
% 
% % 绘制5条折线
% h1=plot(UE_Num, Matlab_25, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(UE_Num, Matlab_49, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(UE_Num, Matlab_4, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h4=plot(UE_Num, Matlab_WiFi1, '--', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h5=plot(UE_Num, Matlab_WiFi2, '--', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2);
% 
% h6=plot(UE_Num, Chainxim_25, 'p', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h7=plot(UE_Num, Chainxim_49, 'o', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h8=plot(UE_Num, Chainxim_4, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h9=plot(UE_Num, Chainxim_WiFi1, '^', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h10=plot(UE_Num, Chainxim_WiFi2, 'v', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2);
% %用于补充图例
% h11 = plot(NaN, NaN, '-p', 'Color', [214/255, 39/255, 40/255],'LineWidth', 2); % LD Num=25
% h12 = plot(NaN, NaN, '-o', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2); % LD Num=49
% h13 = plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2); % LD Num=4
% h14 = plot(NaN, NaN, '--^', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2); % WiFi1
% h15 = plot(NaN, NaN, '--v', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2); % WiFi2
% h16 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h17 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('User Number');
% ylabel('Rejection Probability');
% % title('Traffic Intensity = 0.01');
% ylim([0 1.2]); % 设置
% grid on;
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h12,h11,h13],{'#LD=49', '#LD=25', '#LD=4'}, 'Position', [0.175 0.7235 0.15 0.2]);
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h16,h17], {'Matlab', 'Chainxim'}, 'Position', [0.732 0.191 0.1 0.1]); 
% 
% % 创建不可见的坐标轴用于第三个图例
% axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend3 = legend(axes3, [h14,h15], {'WiFi-baseline1','WiFi-baseline2'}, 'Position', [0.455 0.806 0.15 0.1]); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 10);
% grid on;




%% 不同LD数量下，拒绝概率随活跃用户数量(柱状)
% UE_Num = [20 40 80 100 120];
% Matlab_p1_4 = [0.1461 0.4764 0.7516 0.8037 0.8394];
% Matlab_p1_25 = [0.0273 0.1539 0.562 0.7197 0.8185];
% Matlab_p1_49 = [0.0054 0.0081 0.2722 0.3845 0.5225];
% Matlab_p1_WiFi1 = [0.449 0.85 0.9395 0.9531 0.9617];
% Matlab_p1_WiFi2 = [0.6309 0.9206 0.9693 0.9766 0.9811];
% 
% Matlab_p2_4 = [0.7095 0.4349 0.2072 0.1633 0.1338];
% Matlab_p2_25 = [0.0717 0.061 0.0321 0.0203 0.0133];
% Matlab_p2_49 = [0 0 0 0 0];
% Matlab_p2_WiFi1 = [0 0 0 0 0];
% Matlab_p2_WiFi2 = [0 0 0 0 0];
% 
% 
% % 创建堆叠柱状图
% figure;
% % 设置 x 位置
% x_positions = 1:length(UE_Num);  % LD 的位置
% bar_width = 0.15;  % 调整柱子的宽度
% 
% hold on;
% 
% % 绘制每组数据的堆叠柱状图
% data_4 = [Matlab_p2_4; Matlab_p1_4];
% data_25 = [Matlab_p2_25; Matlab_p1_25];
% data_49 = [Matlab_p2_49; Matlab_p1_49];
% data_WiFi1 = [Matlab_p2_WiFi1; Matlab_p1_WiFi1];
% data_WiFi2 = [Matlab_p2_WiFi2; Matlab_p1_WiFi2];
% 
% % 绘制堆叠柱状图
% hBar4 = bar(x_positions - 0.3, data_4, 'stacked', 'BarWidth', bar_width);
% hBar25 = bar(x_positions - 0.15, data_25, 'stacked', 'BarWidth', bar_width);
% hBar49 = bar(x_positions + 0.0, data_49, 'stacked', 'BarWidth', bar_width);
% hBarWiFi1 = bar(x_positions + 0.15, data_WiFi1, 'stacked', 'BarWidth', bar_width);
% hBarWiFi2 = bar(x_positions + 0.3, data_WiFi2, 'stacked', 'BarWidth', bar_width);
% 
% % %用于补充图例
% h1=bar(NaN, NaN, 'FaceColor','flat','CData', [214/255, 39/255, 40/255]);% LD Num=25
% h2=bar(NaN, NaN, 'FaceColor','flat','CData', [31/255, 119/255, 180/255]);% LD Num=49
% h3=bar(NaN, NaN, 'FaceColor','flat','CData', [44/255, 160/255, 44/255]);% LD Num=4
% h4=bar(NaN, NaN, 'FaceColor','flat','CData', [255/255, 127/255, 14/255]);% WiFi1
% h5=bar(NaN, NaN, 'FaceColor','flat','CData', [148/255, 103/255, 189/255]);% WiFi2
% h6 = bar(NaN, NaN, 'FaceColor','flat','CData', [199/255, 199/255, 199/255]); % p1
% h7 = bar(NaN, NaN, 'FaceColor','flat','CData', [65/255, 68/255, 81/255]); % p2
% 
% 
% % 添加颜色
% colors = [
%     44/255 160/255 44/255;  % p2 4
%     152/255 223/255 138/255;  % p1 4
%     214/255 39/255 40/255;  % p2 25
%     255/255 152/255 150/255;  % p1 25
%     31/255 119/255 180/255;  % p2 49
%     174/255 199/255 232/255;  % p1 49
%     255/255 127/255 14/255;  % p2 WiFi1
%     255/255 187/255 120/255;   % p1 WiFi1
%     148/255 103/255 189/255;  % p2 WiFi2
%     197/255 176/255 213/255   % p1 WiFi2
% ];
% 
% 
% % 设置颜色
% for i = 1:length(hBar4)
%     hBar4(i).FaceColor = 'flat';
%     hBar4(i).CData = colors(i, :);
%     hBar25(i).FaceColor = 'flat';
%     hBar25(i).CData = colors(i + 2, :);
%     hBar49(i).FaceColor = 'flat';
%     hBar49(i).CData = colors(i + 4, :);
%     hBarWiFi1(i).FaceColor = 'flat';
%     hBarWiFi1(i).CData = colors(i + 6, :);
%     hBarWiFi2(i).FaceColor = 'flat';
%     hBarWiFi2(i).CData = colors(i + 8, :);
% end
% 
% 
% % 设置坐标轴标签和标题
% % 添加标签和标题
% xticks(x_positions);  % 设置横坐标刻度
% xticklabels(UE_Num);  % 设置横坐标标签为 LD_Num
% xlabel('User Number');
% ylabel('Rejection Probability');
% % title('Traffic Intensity = 0.01');
% ylim([0 1.35]); % 设置右侧y轴范围为0到0.15
% % 设置坐标轴属性以显示右侧和上侧坐标轴
% set(gca, 'Box', 'on');  % 显示边框
% grid on;
% hold off;
% 
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h1,h2,h3],{'#LD=25', '#LD=49', '#LD=4'}, 'Position', [0.468 0.77 0.1 0.1],'Orientation', 'horizontal');
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h6,h7], {'p1', 'p2'}, 'Position', [0.287 0.74 0 0],'Orientation', 'horizontal'); 
% 
% % % 创建不可见的坐标轴用于第三个图例
% axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend3 = legend(axes3, [h4,h5], {'WiFi-baseline1','WiFi-baseline2'}, 'Position', [0.47 0.85 0.15 0.1],'Orientation', 'horizontal'); 
% 
% % 调整图形属性
% % set(gca, 'FontSize', 12);
% grid on;




%% 不同用户数量下，等待时间随流量强度
% Traffic_intensity = [0.01 0.00667 0.005 0.00333 0.002 0.00125 0.001 0.000667 0.0005];
% Matlab_OWC_50 = [54.7183 51.8938 48.6081 43.9819 35.9423 29.3352 25.5206 21.249 19.7453];
% Matlab_WiFi1_50 = [31.0067 29.8072 29.7895 28.8846 27.1138 24.8485 23.3319 18.9922 16.3062];
% Matlab_WiFi2_50 = [14.7959 14.7323 14.5525 14.1579 13.312 11.8781 10.6058 7.023 3.778];
% 
% Matlab_OWC_30 = [34.4324 32.8004 30.2942 27.5038 23.5473 19.9564 18.8039 17.4172 15.5493];
% Matlab_WiFi1_30 = [29.1313 28.0711 27.0858 24.9924 21.4671 17.5113 15.2553 13.0697 11.9407];
% Matlab_WiFi2_30 = [14.4495 14.0189 13.6257 12.5911 10.0411 5.5633 3.3546 0.6092 0.1352];
% 
% 
% 
% Chainxim_OWC_50 = [54.7183 51.8938 48.6081 43.9819 35.9423 29.3352 25.5206 21.249 19.7453];
% Chainxim_WiFi1_50 = [31.0067 29.8072 29.7895 28.8846 27.1138 24.8485 23.3319 18.9922 16.3062];
% Chainxim_WiFi2_50 = [14.7959 14.7323 14.5525 14.1579 13.312 11.8781 10.6058 7.023 3.778];
% 
% Chainxim_OWC_30 = [34.4324 32.8004 30.2942 27.5038 23.5473 19.9564 18.8039 17.4172 15.5493];
% Chainxim_WiFi1_30 = [29.1313 28.0711 27.0858 24.9924 21.4671 17.5113 15.2553 13.0697 11.9407];
% Chainxim_WiFi2_30 = [14.4495 14.0189 13.6257 12.5911 10.0411 5.5633 3.3546 0.6092 0.1352];
% 
% 
% % 创建图形窗口
% figure;
% 
% % 绘制折线
% h1=plot(Traffic_intensity, Matlab_OWC_50, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(Traffic_intensity, Matlab_WiFi1_50, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(Traffic_intensity, Matlab_WiFi2_50, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% 
% h4=plot(Traffic_intensity, Matlab_OWC_30, '--', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% h5=plot(Traffic_intensity, Matlab_WiFi1_30, '--', 'Color', [114/255, 158/255, 206/255], 'LineWidth', 2);
% h6=plot(Traffic_intensity, Matlab_WiFi2_30, '--', 'Color', [103/255, 191/255, 92/255], 'LineWidth', 2);
% 
% h7=plot(Traffic_intensity, Chainxim_OWC_50, 'o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h8=plot(Traffic_intensity, Chainxim_WiFi1_50, '^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h9=plot(Traffic_intensity, Chainxim_WiFi2_50, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% 
% h10=plot(Traffic_intensity, Chainxim_OWC_30, 'o', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% h11=plot(Traffic_intensity, Chainxim_WiFi1_30, '^', 'Color', [114/255, 158/255, 206/255], 'LineWidth', 2);
% h12=plot(Traffic_intensity, Chainxim_WiFi2_30, 's', 'Color', [103/255, 191/255, 92/255], 'LineWidth', 2);
% % 用于绘制图例
% h13 = plot(NaN, NaN, '-o', 'Color', [214/255, 39/255, 40/255],'LineWidth', 2); % Proposed
% h14 = plot(NaN, NaN, '-^', 'Color', [31/255, 119/255, 180/255],'LineWidth', 2); % WiFi-baseline1
% h15 = plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255],'LineWidth', 2); % WiFi-baseline2
% h16 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % User Num=50
% h17 = plot(NaN, NaN, '--', 'Color', [127/255, 127/255, 127/255], 'LineWidth', 2); % User Num=30
% h18 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h19 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('Traffic Intensity (request/user/round)');
% ylabel('Average Waiting Time (s)');
% ylim([0 65]); % 设置右侧y轴范围为0到0.15
% % title('LD Number = 25');
% grid on;
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h13,h14,h15],{'Proposed', 'WiFi-baseline1','WiFi-baseline2'}, 'Position', [0.25 0.773 0.1 0.1]);
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h16,h17], {'#User=50', '#User=30'}, 'Position', [0.71 0.2 0.1 0.1]); 
% 
% % 创建不可见的坐标轴用于第三个图例
% % axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% % legend3 = legend(axes3, [h18,h19], {'Matlab', 'Chainxim'}, 'Position', [0.74 0.36 0.1 0.1]);
% 
% % 调整图形属性
% % set(gca, 'FontSize', 10);
% grid on;


%% 不同用户数量下，吞吐量随流量强度
% Traffic_intensity = [0.01 0.00667 0.005 0.00333 0.002 0.00125 0.001 0.000667 0.0005];
% Matlab_OWC_50 = [23.727 23.209 23.0720 22.07 20.489 17.679 15.992 12.654 10.318];
% Matlab_WiFi1_50 = [10.222 10.276 10.245 10.226 10.234 10.178 10.151 9.8618 9.1494];
% Matlab_WiFi2_50 = [10.917 10.897 10.901 10.908 10.897 10.873 10.834 10.527 9.7014];
% Matlab_OWC_30 = [19.652 18.873 18.4340 17.121 14.59 11.775 10.425 7.7817 6.3042];
% Matlab_WiFi1_30 = [10.265 10.275 10.271 10.253 10.155 9.5811 8.9673 7.3878 6.029];
% Matlab_WiFi2_30 = [10.898 10.905 10.907 10.902 10.822 10.335 9.702 7.6888 6.4412];
% 
% Chainxim_OWC_50 = [23.727 23.209 23.0720 22.07 20.489 17.679 15.992 12.654 10.318];
% Chainxim_WiFi1_50 = [10.222 10.276 10.245 10.226 10.234 10.178 10.151 9.8618 9.1494];
% Chainxim_WiFi2_50 = [10.917 10.897 10.901 10.908 10.897 10.873 10.834 10.527 9.7014];
% Chainxim_OWC_30 = [19.652 18.873 18.4340 17.121 14.59 11.775 10.425 7.7817 6.3042];
% Chainxim_WiFi1_30 = [10.265 10.275 10.271 10.253 10.155 9.5811 8.9673 7.3878 6.029];
% Chainxim_WiFi2_30 = [10.898 10.905 10.907 10.902 10.822 10.335 9.702 7.6888 6.4412];
% 
% % 创建图形窗口
% figure;
% 
% % 绘制折线
% h1=plot(Traffic_intensity, Matlab_OWC_50, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(Traffic_intensity, Matlab_WiFi1_50, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(Traffic_intensity, Matlab_WiFi2_50, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% 
% h4=plot(Traffic_intensity, Matlab_OWC_30, '--', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% h5=plot(Traffic_intensity, Matlab_WiFi1_30, '--', 'Color', [114/255, 158/255, 206/255], 'LineWidth', 2);
% h6=plot(Traffic_intensity, Matlab_WiFi2_30, '--', 'Color', [103/255, 191/255, 92/255], 'LineWidth', 2);
% 
% h7=plot(Traffic_intensity, Chainxim_OWC_50, 'o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h8=plot(Traffic_intensity, Chainxim_WiFi1_50, '^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h9=plot(Traffic_intensity, Chainxim_WiFi2_50, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% 
% h10=plot(Traffic_intensity, Chainxim_OWC_30, 'o', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% h11=plot(Traffic_intensity, Chainxim_WiFi1_30, '^', 'Color', [114/255, 158/255, 206/255], 'LineWidth', 2);
% h12=plot(Traffic_intensity, Chainxim_WiFi2_30, 's', 'Color', [103/255, 191/255, 92/255], 'LineWidth', 2);
% % 用于绘制图例
% h13 = plot(NaN, NaN, '-o', 'Color', [214/255, 39/255, 40/255],'LineWidth', 2); % Proposed
% h14 = plot(NaN, NaN, '-^', 'Color', [31/255, 119/255, 180/255],'LineWidth', 2); % WiFi-baseline1
% h15 = plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255],'LineWidth', 2); % WiFi-baseline2
% h16 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % User Num=50
% h17 = plot(NaN, NaN, '--', 'Color', [127/255, 127/255, 127/255], 'LineWidth', 2); % User Num=30
% h18 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h19 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('Traffic Intensity (request/user/round)');
% ylabel('Throughput (Gbps)');
% % title('LD Number = 25');
% grid on;
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h13,h14,h15],{'B-HLW', 'WiFi-baseline1', 'WiFi-baseline2'}, 'Position', [0.65 0.5 0.1 0.1]);
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h16,h17], {'#User=50', '#User=30'}, 'Position', [0.655 0.245 0.19 0.1]); 
% 
% % 创建不可见的坐标轴用于第三个图例
% % axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% % legend3 = legend(axes3, [h18,h19], {'Matlab', 'Chainxim'}, 'Position', [0.74 0.53 0.1 0.1]);
% 
% % 调整图形属性
% % set(gca, 'FontSize', 10);
% grid on;



%% 不同用户数量下，拒绝概率随流量强度（折线）
% Traffic_intensity = [0.01 0.00667 0.005 0.00333 0.002 0.00125 0.001 0.000667 0.0005];
% Matlab_OWC_50 = [0.3049 0.2820 0.2569 0.2187 0.1636 0.1188 0.1056 0.0862 0.0812];
% Matlab_WiFi1_50 = [0.8896 0.8658 0.8408 0.7898 0.6901 0.5477 0.4597 0.2504 0.113];
% Matlab_WiFi2_50 = [0.9431 0.9154 0.8864 0.8306 0.718 0.56 0.4485 0.2256 0.0789];
% Matlab_OWC_30 = [0.1479 0.1370 0.1224 0.1112 0.0951 0.0824 0.0792 0.0791 0.075];
% Matlab_WiFi1_30 = [0.7624 0.7095 0.6587 0.5521 0.3597 0.1448 0.0723 0.0133 0.001];
% Matlab_WiFi2_30 = [0.8683 0.8038 0.7402 0.6176 0.3881 0.1383 0.0621 0.0061 0.0006];
% 
% Chainxim_OWC_50 = [0.3049 0.2820 0.2569 0.2187 0.1636 0.1188 0.1056 0.0862 0.0812];
% Chainxim_WiFi1_50 = [0.8896 0.8658 0.8408 0.7898 0.6901 0.5477 0.4597 0.2504 0.113];
% Chainxim_WiFi2_50 = [0.9431 0.9154 0.8864 0.8306 0.718 0.56 0.4485 0.2256 0.0789];
% Chainxim_OWC_30 = [0.1479 0.1370 0.1224 0.1112 0.0951 0.0824 0.0792 0.0791 0.075];
% Chainxim_WiFi1_30 = [0.7624 0.7095 0.6587 0.5521 0.3597 0.1448 0.0723 0.0133 0.001];
% Chainxim_WiFi2_30 = [0.8683 0.8038 0.7402 0.6176 0.3881 0.1383 0.0621 0.0061 0.0006];
% 
% % 创建图形窗口
% figure;
% 
% % 绘制折线
% h1=plot(Traffic_intensity, Matlab_OWC_50, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(Traffic_intensity, Matlab_WiFi1_50, '-', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(Traffic_intensity, Matlab_WiFi2_50, '-', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% 
% h4=plot(Traffic_intensity, Matlab_OWC_30, '--', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% h5=plot(Traffic_intensity, Matlab_WiFi1_30, '--', 'Color', [114/255, 158/255, 206/255], 'LineWidth', 2);
% h6=plot(Traffic_intensity, Matlab_WiFi2_30, '--', 'Color', [103/255, 191/255, 92/255], 'LineWidth', 2);
% 
% h7=plot(Traffic_intensity, Chainxim_OWC_50, 'o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h8=plot(Traffic_intensity, Chainxim_WiFi1_50, '^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h9=plot(Traffic_intensity, Chainxim_WiFi2_50, 's', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% 
% h10=plot(Traffic_intensity, Chainxim_OWC_30, 'o', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% h11=plot(Traffic_intensity, Chainxim_WiFi1_30, '^', 'Color', [114/255, 158/255, 206/255], 'LineWidth', 2);
% h12=plot(Traffic_intensity, Chainxim_WiFi2_30, 's', 'Color', [103/255, 191/255, 92/255], 'LineWidth', 2);
% % 用于绘制图例
% h13 = plot(NaN, NaN, '-o', 'Color', [214/255, 39/255, 40/255],'LineWidth', 2); % Proposed
% h14 = plot(NaN, NaN, '-^', 'Color', [31/255, 119/255, 180/255],'LineWidth', 2); % WiFi-baseline1
% h15 = plot(NaN, NaN, '-s', 'Color', [44/255, 160/255, 44/255],'LineWidth', 2); % WiFi-baseline2
% h16 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % User Num=50
% h17 = plot(NaN, NaN, '--', 'Color', [127/255, 127/255, 127/255], 'LineWidth', 2); % User Num=30
% h18 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h19 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% 
% % 设置坐标轴标签和标题
% xlabel('Traffic Intensity (request/user/round)');
% ylabel('Rejection Probability');
% % title('LD Number = 25');
% grid on;
% 
% % 设置图例
% % 首先创建一个图例
% legend1 = legend([h13,h14,h15],{'Proposed', 'WiFi-baseline1', 'WiFi-baseline2'}, 'Position', [0.66 0.53 0.19 0.1]);
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h16,h17], {'#User=50', '#User=30'}, 'Position', [0.735 0.38 0.1 0.1]); 
% 
% % 创建不可见的坐标轴用于第三个图例
% axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend3 = legend(axes3, [h18,h19], {'Matlab', 'Chainxim'}, 'Position', [0.18 0.82 0.1 0.1]);
% % 调整图形属性
% % set(gca, 'FontSize', 10);
% grid on;







%% 不同用户数量下，拒绝概率随流量强度(柱状)
Traffic_intensity = [0.0005 0.001 0.002 0.005 0.01];
Matlab_OWC_p1_50 = [0.0082 0.0328 0.0974 0.1986 0.2493];
Matlab_WiFi1_p1_50 = [0.113 0.4597 0.6901 0.8408 0.8896];
Matlab_WiFi2_p1_50 = [0.0789 0.4485 0.718 0.8864 0.9431];

Matlab_OWC_p1_30 = [0.0009 0.0059 0.0224 0.0542 0.081];
Matlab_WiFi1_p1_30 = [0.001 0.0723 0.3597 0.6587 0.7624];
Matlab_WiFi2_p1_30 = [0.0006 0.0621 0.3881 0.7402 0.8683];

Matlab_OWC_p2_50 = [0.073 0.0729 0.0662 0.0583 0.0556];
Matlab_WiFi1_p2_50 = [0 0 0 0 0];
Matlab_WiFi2_p2_50 = [0 0 0 0 0];

Matlab_OWC_p2_30 = [0.0741 0.0732 0.0727 0.0682 0.0669];
Matlab_WiFi1_p2_30 = [0 0 0 0 0];
Matlab_WiFi2_p2_30 = [0 0 0 0 0];

% 创建堆叠柱状图
figure;
% 设置 x 位置
x_positions = 1:length(Traffic_intensity);  % LD 的位置
bar_width = 0.1;  % 调整柱子的宽度

hold on;

% 绘制每组数据的堆叠柱状图
data_OWC_50 = [Matlab_OWC_p2_50; Matlab_OWC_p1_50];
data_OWC_30 = [Matlab_OWC_p2_30; Matlab_OWC_p1_30];
data_WiFi1_50 = [Matlab_WiFi1_p2_50; Matlab_WiFi1_p1_50];
data_WiFi1_30 = [Matlab_WiFi1_p2_30; Matlab_WiFi1_p1_30];
data_WiFi2_50 = [Matlab_WiFi2_p2_50; Matlab_WiFi2_p1_50];
data_WiFi2_30 = [Matlab_WiFi2_p2_30; Matlab_WiFi2_p1_30];

% 绘制堆叠柱状图
hBarOWC_50 = bar(x_positions - 0.375, data_OWC_50, 'stacked', 'BarWidth', bar_width);
hBarWiFi1_50 = bar(x_positions - 0.225, data_WiFi1_50, 'stacked', 'BarWidth', bar_width);
hBarWiFi2_50 = bar(x_positions - 0.075, data_WiFi2_50, 'stacked', 'BarWidth', bar_width);
hBarOWC_30 = bar(x_positions + 0.075, data_OWC_30, 'stacked', 'BarWidth', bar_width);
hBarWiFi1_30 = bar(x_positions + 0.225, data_WiFi1_30, 'stacked', 'BarWidth', bar_width);
hBarWiFi2_30 = bar(x_positions + 0.375, data_WiFi2_30, 'stacked', 'BarWidth', bar_width);

% %用于补充图例
h1=bar(NaN, NaN, 'FaceColor','flat','CData', [214/255 39/255 40/255]);% OWC
h2=bar(NaN, NaN, 'FaceColor','flat','CData', [31/255 119/255 180/255]);% WiFi1
h3=bar(NaN, NaN, 'FaceColor','flat','CData', [44/255 160/255 44/255]);% WiFi2
% h4=bar(NaN, NaN, 'FaceColor','flat','CData', [65/255, 68/255, 81/255]);% 50
% h5=bar(NaN, NaN, 'FaceColor','flat','CData', [127/255, 127/255, 127/255]);% 30
h6 = bar(NaN, NaN, 'FaceColor','flat','CData', [199/255, 199/255, 199/255]); % p1
h7 = bar(NaN, NaN, 'FaceColor','flat','CData', [65/255, 68/255, 81/255]); % p2


% 添加颜色
colors = [
    214/255 39/255 40/255;  % p2 OWC_50
    255/255 152/255 150/255;  % p1 OWC_50
    31/255 119/255 180/255;  % p2 WiFi1_50
    174/255 199/255 232/255;  % p1 WiFi1_50
    44/255 160/255 44/255;  % p2 WiFi2_50
    152/255 223/255 138/255  % p1 WiFi2_50
    214/255 39/255 40/255;  % p2 OWC_30
    255/255 152/255 150/255;   % p1 OWC_30
    31/255 119/255 180/255;  % p2 WiFi1_30
    174/255 199/255 232/255;   % p1 WiFi1_30
    44/255 160/255 44/255;  % p2 WiFi2_30
    152/255 223/255 138/255   % p1 WiFi2_30
];

% 设置颜色
for i = 1:length(hBarOWC_50)
    hBarOWC_50(i).FaceColor = 'flat';
    hBarOWC_50(i).CData = colors(i, :);
    hBarWiFi1_50(i).FaceColor = 'flat';
    hBarWiFi1_50(i).CData = colors(i + 2, :);
    hBarWiFi2_50(i).FaceColor = 'flat';
    hBarWiFi2_50(i).CData = colors(i + 4, :);
    hBarOWC_30(i).FaceColor = 'flat';
    hBarOWC_30(i).CData = colors(i + 6, :);
    hBarWiFi1_30(i).FaceColor = 'flat';
    hBarWiFi1_30(i).CData = colors(i + 8, :);
    hBarWiFi2_30(i).FaceColor = 'flat';
    hBarWiFi2_30(i).CData = colors(i + 10, :);
end


% 设置坐标轴标签和标题
% 添加标签和标题
xticks(x_positions);  % 设置横坐标刻度
xticklabels(Traffic_intensity);  % 设置横坐标标签为 Traffic_intensity
xlim([0.3, 5.7]);  % 根据需要调整范围
xlabel('Traffic Intensity (request/user/round)');
ylabel('Rejection Probability');
% title('Traffic Intensity = 0.01');
ylim([0 1.3]); % 设置右侧y轴范围为0到0.15
% 设置坐标轴属性以显示右侧和上侧坐标轴
set(gca, 'Box', 'on');  % 显示边框
grid on;

% User50
hRectangle1=rectangle('Position', [0.55, 0, 0.44, 0.12], 'EdgeColor',[255/255,127/255,14/255], 'LineStyle', '--', 'LineWidth', 1);
text(1.1, 0.47, '#User=50', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'Color', [255/255, 127/255, 14/255]);
annotation('arrow', [0.2, 0.2], [0.42, 0.2], 'Color', [255/255, 127/255, 14/255],'LineWidth', 1.5);
hRectangle2=rectangle('Position', [1.55, 0, 0.44, 0.47], 'EdgeColor',[255/255,127/255,14/255], 'LineStyle', '--', 'LineWidth', 1);
hRectangle3=rectangle('Position', [2.55, 0, 0.44, 0.73], 'EdgeColor',[255/255,127/255,14/255], 'LineStyle', '--', 'LineWidth', 1);
hRectangle4=rectangle('Position', [3.55, 0, 0.44, 0.895], 'EdgeColor',[255/255,127/255,14/255], 'LineStyle', '--', 'LineWidth', 1);
hRectangle5=rectangle('Position', [4.55, 0, 0.44, 0.95], 'EdgeColor',[255/255,127/255,14/255], 'LineStyle', '--', 'LineWidth', 1);


% User30
hRectangle6=rectangle('Position', [1.02, 0, 0.44, 0.09], 'EdgeColor', [148/255,103/255,189/255], 'LineStyle', '--', 'LineWidth', 1);
text(1.4, 0.6, '#User=30', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'Color', [148/255, 103/255, 189/255]);
annotation('arrow', [0.28, 0.28], [0.5, 0.19], 'Color', [148/255, 103/255, 189/255], 'LineWidth', 1.52);
hRectangle7=rectangle('Position', [2.02, 0, 0.44, 0.09], 'EdgeColor', [148/255,103/255,189/255], 'LineStyle', '--', 'LineWidth', 1);
hRectangle8=rectangle('Position', [3.02, 0, 0.44, 0.4], 'EdgeColor', [148/255,103/255,189/255], 'LineStyle', '--', 'LineWidth', 1);
hRectangle9=rectangle('Position', [4.02, 0, 0.44, 0.75], 'EdgeColor', [148/255,103/255,189/255], 'LineStyle', '--', 'LineWidth', 1);
hRectangle10=rectangle('Position', [5.02, 0, 0.44, 0.875], 'EdgeColor', [148/255,103/255,189/255], 'LineStyle', '--', 'LineWidth', 1);
hold off;


% 设置图例
% 首先创建一个图例
legend1 = legend([h1,h2,h3],{'B-HLW', 'WiFi-baseline1', 'WiFi-baseline2'}, 'Position', [0.303 0.7555 0.1 0.1]);

% 创建不可见的坐标轴用于第二个图例
axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
legend2 = legend(axes2, [h6,h7], {'p1', 'p2'}, 'Position', [0.607 0.845 0 0]); 

% % 创建不可见的坐标轴用于第三个图例
% axes3 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend3 = legend(axes3, [h4,h5], {'#User=50', '#User=30'}, 'Position', [0.405 0.839 0.15 0.1]); 

% 调整图形属性
% set(gca, 'FontSize', 12);
grid on;











%% 吞吐量提升比例
% Traffic_intensity = [0.01 0.00667 0.005 0.00333 0.002 0.00125 0.001 0.000667 0.0005];
% Matlab_OWC_50 = [23.727 23.209 23.0720 22.07 20.489 17.679 15.992 12.654 10.318];
% Matlab_WiFi2_50 = [10.917 10.897 10.901 10.908 10.897 10.873 10.834 10.527 9.7014];
% Matlab_Improvement = [117.3399286 112.9852253 111.6503073 102.3285662 88.02422685 62.59541985 47.60937788 20.20518666 6.355783701];
% Chainxim_OWC_50 = [23.727 23.209 23.0720 22.07 20.489 17.679 15.992 12.654 10.318];
% Chainxim_WiFi2_50 = [10.917 10.897 10.901 10.908 10.897 10.873 10.834 10.527 9.7014];
% Chainxim_Improvement = [117.3399286 112.9852253 111.6503073 102.3285662 88.02422685 62.59541985 47.60937788 20.20518666 6.355783701];
% 
% 
% % 创建图形窗口
% figure;
% 
% % 绘制折线
% h1=plot(Traffic_intensity, Matlab_OWC_50, '-', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(Traffic_intensity, Matlab_WiFi2_50, '-', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% h3=plot(Traffic_intensity, Chainxim_OWC_50, 'o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% h4=plot(Traffic_intensity, Chainxim_WiFi2_50, '^', 'Color', [237/255, 102/255, 93/255], 'LineWidth', 2);
% 
% % 设置坐标轴标签和标题
% xlabel('Traffic Intensity (request/user/round)');
% ylabel('Throughput (Gbps)');
% 
% 
% % 设置右侧y轴
% yyaxis right;
% % 绘制右侧折线
% h5=plot(Traffic_intensity, Matlab_Improvement, '--', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2); 
% h6=plot(Traffic_intensity, Chainxim_Improvement, 'd', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% ylabel('Improvement Ratio (%)','Color', 'k'); % 设置右侧y轴标签
% % title('Active User Number =50, LD Number = 25');
% grid on;
% 
% % 设置图例
% %用于区分chainxim和matlab
% h7 = plot(NaN, NaN, '-o', 'Color', [214/255, 39/255, 40/255],'LineWidth', 2); % OWC
% h8 = plot(NaN, NaN, '--^', 'Color', [237/255, 102/255, 93/255],'LineWidth', 2); % WIFI
% h9 = plot(NaN, NaN, '-d', 'Color', [255/255, 127/255, 14/255],'LineWidth', 2); % Improvement
% h10 = plot(NaN, NaN, '-', 'Color', 'k','LineWidth', 2); % Matlab Simulation
% h11 = plot(NaN, NaN, 'o', 'Color', 'k', 'LineWidth', 2); % Chainxim Simulation
% hold off;
% % legend1 = legend([h7, h8, h9], {'OWC', 'WiFi', 'Improvement'}, 'Position', [0.72 0.4 0.1 0.1]);
% 
% % 调整图形属性
% % set(gca, 'FontSize', 10);
% % 设置右侧y轴的颜色为黑色
% ax = gca; % 获取当前坐标轴
% ax.YColor = 'k'; % 将右侧y轴的颜色设置为黑色
% % 设置右侧y轴范围（根据需要调整）
% ylim([0 150]); % 设置右侧y轴范围为0到0.15
% 
% % 添加虚线圆圈和箭头
% % circle_x = 0.83; % 圆圈中心x坐标
% % circle_y = 0.63; % 圆圈中心y坐标
% % circle_r = 0.05; % 圆圈半径
% % annotation('ellipse',[circle_x-circle_r circle_y-circle_r 1*circle_r 3*circle_r],'LineStyle','--','Color','k','LineWidth', 2);
% arrow_x1_OWC = 0.725; % 箭头起点x坐标
% arrow_y1_OWC = 0.82; % 箭头起点y坐标
% arrow_x2_OWC = 0.705; % 箭头终点x坐标
% arrow_y2_OWC = 0.89; % 箭头终点y坐标
% annotation('arrow',[arrow_x1_OWC arrow_x2_OWC],[arrow_y1_OWC arrow_y2_OWC],'Color','k','LineWidth', 2);
% % 在箭头旁边插入文字
% text(0.007, 128, 'Proposed', 'Color', 'k', 'VerticalAlignment', 'middle');
% 
% arrow_x1_improvement = 0.725; % 箭头起点x坐标
% arrow_y1_improvement = 0.655; % 箭头起点y坐标
% arrow_x2_improvement = 0.705; % 箭头终点x坐标
% arrow_y2_improvement = 0.725; % 箭头终点y坐标
% annotation('arrow',[arrow_x1_improvement arrow_x2_improvement],[arrow_y1_improvement arrow_y2_improvement],'Color','k','LineWidth', 2);
% % 在箭头旁边插入文字
% text(0.00575, 98, 'Relative Improvement', 'Color', 'k', 'VerticalAlignment', 'middle');
% 
% arrow_x1_WIFI2 = 0.705; % 箭头起点x坐标
% arrow_y1_WIFI2 = 0.345; % 箭头起点y坐标
% arrow_x2_WIFI2 = 0.725; % 箭头终点x坐标
% arrow_y2_WIFI2 = 0.265; % 箭头终点y坐标
% annotation('arrow',[arrow_x1_WIFI2 arrow_x2_WIFI2],[arrow_y1_WIFI2 arrow_y2_WIFI2],'Color','k','LineWidth', 2);
% % 在箭头旁边插入文字
% text(0.00625, 47, 'WiFi-baseline2', 'Color', 'k', 'VerticalAlignment', 'middle');
% 
% % 创建不可见的坐标轴用于第二个图例
% axes2 = axes('Position',get(gca,'Position'), 'Visible', 'off');
% legend2 = legend(axes2, [h10,h11], {'Matlab', 'Chainxim'}, 'Position', [0.72 0.45 0.1 0.1]); 
% 
% grid on;



%% 吞吐量WiFi-baseline 1vs2,调整出块时间
% Traffic_intensity = [0.01 0.00667 0.005 0.00333 0.002 0.00125 0.001 0.000667 0.0005];
% WiFi_baseline2 = [9.9327 9.941 9.9489 9.9391 9.9331 9.932 9.9104 9.7409 9.3093];
% WiFi_baseline1_12blocktime = [9.3874 9.3505 9.3595 9.3516 9.3525 9.3015 9.3085 9.0631 8.6105];
% WiFi_baseline1_10blocktime = [9.5568 9.531 9.5313 9.5458 9.5291 9.5263 9.4709 9.2651 8.8157];
% WiFi_baseline1_8blocktime = [9.6982 9.6748 9.6672 9.6898 9.6866 9.6603 9.6144 9.3937 8.9075];
% WiFi_baseline1_6blocktime = [9.8135 9.7891 9.8168 9.7993 9.7997 9.7714 9.7425 9.5445 9.1041];
% WiFi_baseline1_4blocktime = [9.8984 9.9111 9.889 9.8879 9.8728 9.8767 9.8461 9.6282 9.1021];
% WiFi_baseline1_2blocktime = [9.919 9.8999 9.923 9.9229 9.9224 9.8908 9.8847 9.7305 9.2631];
% 
% 
% % 创建图形窗口
% figure;
% 
% % 绘制折线
% h1=plot(Traffic_intensity, WiFi_baseline2, '-o', 'Color', [214/255, 39/255, 40/255], 'LineWidth', 2);
% hold on;
% h2=plot(Traffic_intensity, WiFi_baseline1_12blocktime, '-^', 'Color', [31/255, 119/255, 180/255], 'LineWidth', 2);
% h3=plot(Traffic_intensity, WiFi_baseline1_10blocktime, '-^', 'Color', [255/255, 127/255, 14/255], 'LineWidth', 2);
% h4=plot(Traffic_intensity, WiFi_baseline1_8blocktime, '-^', 'Color', [44/255, 160/255, 44/255], 'LineWidth', 2);
% h5=plot(Traffic_intensity, WiFi_baseline1_6blocktime, '-^', 'Color', [148/255, 103/255, 189/255], 'LineWidth', 2);
% h6=plot(Traffic_intensity, WiFi_baseline1_4blocktime, '-^', 'Color', [140/255, 86/255, 75/255], 'LineWidth', 2);
% h7=plot(Traffic_intensity, WiFi_baseline1_2blocktime, '-^', 'Color', 'k', 'LineWidth', 2);
% 
% 
% % 设置坐标轴标签和标题
% xlabel('Traffic Intensity (request/user/round)');
% ylabel('Throughput (Gbps)');
% 
% % ylim([5 10.5]); % 设置右侧y轴范围为0到0.15
% grid on;
% 
% % 设置图例
% 
% hold off;
% legend1 = legend([h1, h2, h3, h4, h5, h6, h7], {'WiFi-baseline2', 'block time=12', 'block time=10','block time=8','block time=6','block time=4','block time=2'}, 'Position', [0.72 0.24 0.1 0.1]);




% PrintFigToPaper('-depsc', 'throughput_vs_LD', 28, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'waiting_time_vs_LD', 24, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'rejection_vs_LD', 28, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'throughput_vs_UE', 28, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'waiting_time_vs_UE', 24, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'rejection_vs_UE', 28, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'waiting_time_vs_traffic', 24, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'throughput_vs_traffic', 28, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'rejection_vs_traffic', 28, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'improvement', 16, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-depsc', 'WiFi-baseline_1vs2', 16, 'Times New Roman', 7, 1, 0, 0, 0, 0);


% PrintFigToPaper('-dpng', 'throughput_vs_LD_中文', 18, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-dpng', 'rejection_vs_LD_中文', 18, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-dpng', 'throughput_vs_UE_中文', 18, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-dpng', 'rejection_vs_UE_中文', 18, 'Times New Roman', 7, 1, 0, 0, 0, 0);
% PrintFigToPaper('-dpng', 'throughput_vs_traffic_中文', 18, 'Times New Roman', 7, 1, 0, 0, 0, 0);
PrintFigToPaper('-dpng', 'rejection_vs_traffic_中文', 18, 'Times New Roman', 7, 1, 0, 0, 0, 0);