%%房间
roomSize=[10,10,3];%房间大小10×10×4.7

%LD位置参数
LD1=[2,2,3];
LD2=[5,2,3];
LD3=[8,2,3];
LD4=[2,5,3];
LD5=[5,5,3];
LD6=[8,5,3];
LD7=[2,8,3];
LD8=[5,8,3];
LD9=[8,8,3];
%RF AP位置参数
WIFI=[5,5,0];

%用户位置参数（终端离地面1m）
UE1=[0.5, 9.5, 1];
UE2=[3,3,1];
UE3=[3.6,8.3,1];
UE4=[8,4,1];
UE5=[5.4,1.2,1];
UE6 = [1, 1, 1];
UE7 = [9, 1, 1];
UE8 = [1.5, 6.5, 1];
UE9 = [9, 9.5, 1];
UE10 = [4, 4, 1];
UE11 = [6, 6, 1];
UE12 = [4, 6, 1];
UE13 = [6, 4, 1];
UE14 = [3.3, 9.8, 1];
UE15 = [7, 3, 1];
UE16 = [6.2, 7.5, 1];
UE17 = [2, 4, 1];
UE18 = [9, 7, 1];
UE19 = [3, 0.2, 1];
UE20 = [7, 5, 1];
UE21 = [2.1, 2.7, 1];
UE22 = [4.8, 8.1, 1];
UE23 = [6.5, 2.3, 1];
UE24 = [1.8, 5.6, 1];
UE25 = [8.2, 3.4, 1];
UE26 = [5.1, 6.8, 1];
UE27 = [3.7, 7.9, 1];
UE28 = [7.4, 8.6, 1];
UE29 = [2.5, 4.3, 1];
UE30 = [6.9, 5.7, 1];
UE31 = [4.2, 2.1, 1];
UE32 = [8.7, 6.3, 1];
UE33 = [3.1, 8.4, 1];
UE34 = [5.6, 3.8, 1];
UE35 = [2.9, 6.1, 1];
UE36 = [7.2, 7.7, 1];
UE37 = [4.6, 4.9, 1];
UE38 = [6.3, 1.5, 1];
UE39 = [1.3, 7.2, 1];
UE40 = [8.4, 5.4, 1];
UE41 = [5.3, 9.1, 1];
UE42 = [3.5, 3.2, 1];
UE43 = [7.8, 8.9, 1];
UE44 = [2.3, 5.1, 1];
UE45 = [6.7, 4.7, 1];
UE46 = [4.1, 8.7, 1];
UE47 = [8.1, 2.9, 1];
UE48 = [2.7, 6.9, 1];
UE49 = [5.8, 3.5, 1];
UE50 = [7.5, 7.3, 1];


% 创建图形窗口
figure;

% 绘制房间边界
room = [0, 0, 0; 0, roomSize(2), 0; roomSize(1), roomSize(2), 0; roomSize(1), 0, 0; 0, 0, 0];
plot3(room(:,1), room(:,2), room(:,3), 'k-', 'LineWidth', 2);
hold on;

% 绘制AP
scatter3(LD1(1), LD1(2), LD1(3), 'r', 'filled');
scatter3(LD2(1), LD2(2), LD2(3), 'r', 'filled');
scatter3(LD3(1), LD3(2), LD3(3), 'r', 'filled');
scatter3(LD4(1), LD4(2), LD4(3), 'r', 'filled');
scatter3(LD5(1), LD5(2), LD5(3), 'r', 'filled');
scatter3(LD6(1), LD6(2), LD6(3), 'r', 'filled');
scatter3(LD7(1), LD7(2), LD7(3), 'r', 'filled');
scatter3(LD8(1), LD8(2), LD8(3), 'r', 'filled');
scatter3(LD9(1), LD9(2), LD9(3), 'r', 'filled');
% scatter3(LED2(1), LED2(2), LED2(3), 'g', 'filled');
% scatter3(LED3(1), LED3(2), LED3(3), 'b', 'filled');
% scatter3(LED4(1), LED4(2), LED4(3), 'k', 'filled');
% scatter3(LED5(1), LED5(2), LED5(3), 'y', 'filled');
scatter3(WIFI(1), WIFI(2), WIFI(3), 'm', 'filled');

% 绘制用户
scatter3(UE1(1), UE1(2), UE1(3), 'g', 'filled');
scatter3(UE2(1), UE2(2), UE2(3), 'g', 'filled');
scatter3(UE3(1), UE3(2), UE3(3), 'g', 'filled');
scatter3(UE4(1), UE4(2), UE4(3), 'g', 'filled');
scatter3(UE5(1), UE5(2), UE5(3), 'g', 'filled');
scatter3(UE6(1), UE6(2), UE6(3), 'g', 'filled');
scatter3(UE7(1), UE7(2), UE7(3), 'g', 'filled');
scatter3(UE8(1), UE8(2), UE8(3), 'g', 'filled');
scatter3(UE9(1), UE9(2), UE9(3), 'g', 'filled');
scatter3(UE10(1), UE10(2), UE10(3), 'g', 'filled');
scatter3(UE11(1), UE11(2), UE11(3), 'g', 'filled');
scatter3(UE12(1), UE12(2), UE12(3), 'g', 'filled');
scatter3(UE13(1), UE13(2), UE13(3), 'g', 'filled');
scatter3(UE14(1), UE14(2), UE14(3), 'g', 'filled');
scatter3(UE15(1), UE15(2), UE15(3), 'g', 'filled');
scatter3(UE16(1), UE16(2), UE16(3), 'g', 'filled');
scatter3(UE17(1), UE17(2), UE17(3), 'g', 'filled');
scatter3(UE18(1), UE18(2), UE18(3), 'g', 'filled');
scatter3(UE19(1), UE19(2), UE19(3), 'g', 'filled');
scatter3(UE20(1), UE20(2), UE20(3), 'g', 'filled');
scatter3(UE21(1), UE21(2), UE21(3), 'g', 'filled');
scatter3(UE22(1), UE22(2), UE22(3), 'g', 'filled');
scatter3(UE23(1), UE23(2), UE23(3), 'g', 'filled');
scatter3(UE24(1), UE24(2), UE24(3), 'g', 'filled');
scatter3(UE25(1), UE25(2), UE25(3), 'g', 'filled');
scatter3(UE26(1), UE26(2), UE26(3), 'g', 'filled');
scatter3(UE27(1), UE27(2), UE27(3), 'g', 'filled');
scatter3(UE28(1), UE28(2), UE28(3), 'g', 'filled');
scatter3(UE29(1), UE29(2), UE29(3), 'g', 'filled');
scatter3(UE30(1), UE30(2), UE30(3), 'g', 'filled');
scatter3(UE31(1), UE31(2), UE31(3), 'g', 'filled');
scatter3(UE32(1), UE32(2), UE32(3), 'g', 'filled');
scatter3(UE33(1), UE33(2), UE33(3), 'g', 'filled');
scatter3(UE34(1), UE34(2), UE34(3), 'g', 'filled');
scatter3(UE35(1), UE35(2), UE35(3), 'g', 'filled');
scatter3(UE36(1), UE36(2), UE36(3), 'g', 'filled');
scatter3(UE37(1), UE37(2), UE37(3), 'g', 'filled');
scatter3(UE38(1), UE38(2), UE38(3), 'g', 'filled');
scatter3(UE39(1), UE39(2), UE39(3), 'g', 'filled');
scatter3(UE40(1), UE40(2), UE40(3), 'g', 'filled');
scatter3(UE41(1), UE41(2), UE41(3), 'g', 'filled');
scatter3(UE42(1), UE42(2), UE42(3), 'g', 'filled');
scatter3(UE43(1), UE43(2), UE43(3), 'g', 'filled');
scatter3(UE44(1), UE44(2), UE44(3), 'g', 'filled');
scatter3(UE45(1), UE45(2), UE45(3), 'g', 'filled');
scatter3(UE46(1), UE46(2), UE46(3), 'g', 'filled');
scatter3(UE47(1), UE47(2), UE47(3), 'g', 'filled');
scatter3(UE48(1), UE48(2), UE48(3), 'g', 'filled');
scatter3(UE49(1), UE49(2), UE49(3), 'g', 'filled');
scatter3(UE50(1), UE50(2), UE50(3), 'g', 'filled');








% 设置坐标轴标签
xlabel('X');
ylabel('Y');
zlabel('Z');

% 设置图形标题
title('会议室模型');


% 图例
% legend([AP1, AP2, User]);

% 设置图形视角
view(3);

% 创建图形窗口
figure;

% 绘制平面图
subplot(1, 2, 1);
% 绘制房间边界
room = [0, 0, 0; 0, roomSize(2), 0; roomSize(1), roomSize(2), 0; roomSize(1), 0, 0; 0, 0, 0];
plot(room(:, 1), room(:, 2), 'k-', 'LineWidth', 2);
hold on;

% 绘制AP
scatter(LD1(1), LD1(2), 'r', 'filled');
scatter(LD2(1), LD2(2), 'r', 'filled');
scatter(LD3(1), LD3(2), 'r', 'filled');
scatter(LD4(1), LD4(2), 'r', 'filled');
scatter(LD5(1), LD5(2), 'r', 'filled');
scatter(LD6(1), LD6(2), 'r', 'filled');
scatter(LD7(1), LD7(2), 'r', 'filled');
scatter(LD8(1), LD8(2), 'r', 'filled');
scatter(LD9(1), LD9(2), 'r', 'filled');

% 绘制RF AP
scatter(WIFI(1), WIFI(2), 'm', 'filled');

% 绘制用户
scatter(UE1(1), UE1(2), 'g', 'filled');
scatter(UE2(1), UE2(2), 'g', 'filled');
scatter(UE3(1), UE3(2), 'g', 'filled');
scatter(UE4(1), UE4(2), 'g', 'filled');
scatter(UE5(1), UE5(2), 'g', 'filled');
scatter(UE6(1), UE6(2), 'g', 'filled');
scatter(UE7(1), UE7(2), 'g', 'filled');
scatter(UE8(1), UE8(2), 'g', 'filled');
scatter(UE9(1), UE9(2), 'g', 'filled');
scatter(UE10(1), UE10(2), 'g', 'filled');
scatter(UE11(1), UE11(2), 'g', 'filled');
scatter(UE12(1), UE12(2), 'g', 'filled');
scatter(UE13(1), UE13(2), 'g', 'filled');
scatter3(UE14(1), UE14(2), UE14(3), 'g', 'filled');
scatter3(UE15(1), UE15(2), UE15(3), 'g', 'filled');
scatter3(UE16(1), UE16(2), UE16(3), 'g', 'filled');
scatter3(UE17(1), UE17(2), UE17(3), 'g', 'filled');
scatter3(UE18(1), UE18(2), UE18(3), 'g', 'filled');
scatter3(UE19(1), UE19(2), UE19(3), 'g', 'filled');
scatter3(UE20(1), UE20(2), UE20(3), 'g', 'filled');
scatter3(UE21(1), UE21(2), UE21(3), 'g', 'filled');
scatter3(UE22(1), UE22(2), UE22(3), 'g', 'filled');
scatter3(UE23(1), UE23(2), UE23(3), 'g', 'filled');
scatter3(UE24(1), UE24(2), UE24(3), 'g', 'filled');
scatter3(UE25(1), UE25(2), UE25(3), 'g', 'filled');
scatter3(UE26(1), UE26(2), UE26(3), 'g', 'filled');
scatter3(UE27(1), UE27(2), UE27(3), 'g', 'filled');
scatter3(UE28(1), UE28(2), UE28(3), 'g', 'filled');
scatter3(UE29(1), UE29(2), UE29(3), 'g', 'filled');
scatter3(UE30(1), UE30(2), UE30(3), 'g', 'filled');
scatter3(UE31(1), UE31(2), UE31(3), 'g', 'filled');
scatter3(UE32(1), UE32(2), UE32(3), 'g', 'filled');
scatter3(UE33(1), UE33(2), UE33(3), 'g', 'filled');
scatter3(UE34(1), UE34(2), UE34(3), 'g', 'filled');
scatter3(UE35(1), UE35(2), UE35(3), 'g', 'filled');
scatter3(UE36(1), UE36(2), UE36(3), 'g', 'filled');
scatter3(UE37(1), UE37(2), UE37(3), 'g', 'filled');
scatter3(UE38(1), UE38(2), UE38(3), 'g', 'filled');
scatter3(UE39(1), UE39(2), UE39(3), 'g', 'filled');
scatter3(UE40(1), UE40(2), UE40(3), 'g', 'filled');
scatter3(UE41(1), UE41(2), UE41(3), 'g', 'filled');
scatter3(UE42(1), UE42(2), UE42(3), 'g', 'filled');
scatter3(UE43(1), UE43(2), UE43(3), 'g', 'filled');
scatter3(UE44(1), UE44(2), UE44(3), 'g', 'filled');
scatter3(UE45(1), UE45(2), UE45(3), 'g', 'filled');
scatter3(UE46(1), UE46(2), UE46(3), 'g', 'filled');
scatter3(UE47(1), UE47(2), UE47(3), 'g', 'filled');
scatter3(UE48(1), UE48(2), UE48(3), 'g', 'filled');
scatter3(UE49(1), UE49(2), UE49(3), 'g', 'filled');
scatter3(UE50(1), UE50(2), UE50(3), 'g', 'filled');

% 设置坐标轴标签
xlabel('X');
ylabel('Y');

% 设置图形标题
title('用户位置平面图');

% 设置图形视角
view(2);