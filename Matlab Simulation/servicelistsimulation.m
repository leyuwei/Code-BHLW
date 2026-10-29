num_simulations = 10;  % 仿
% 真次数
total_sumWaittime = 0;  % sumWaittime 的累加总和
total_probability = 0;  % probability 的累加总和
total_average = 0;      % average 的累加总和
total_maxWaittime = 0;  % maxWaittime 的累加总和
total_minWaittime = 0;  % minWaittime 的累加总和

fileID = fopen('simulation_results.txt', 'w');
for j = 1:num_simulations
    % 调用代码文件以获取相关值
    model_request_per_user_WiFi_baseline1;
%     model_request_per_user_WiFi_baseline2;
%     model_request_per_user_OWC;

    % 进行相应的计算和更新
    % ...

    % 将结果写入文本文件
    fileID = fopen('simulation_results.txt', 'a');
    fprintf(fileID, 'Iteration %f:\n', j);
    fprintf(fileID, 'sumWaittime: %f\n', sumWaittime);
    fprintf(fileID, 'average: %f\n', average);
    fprintf(fileID, 'maxWaittime: %f\n', maxWaittime);
    fprintf(fileID, 'minWaittime: %f\n\n', minWaittime);
    fprintf(fileID, 'blocknum: %f\n\n', blocknum);
    fprintf(fileID, 'throughput: %f\n\n', throughput);
    fprintf(fileID, 'q_rejected: %f\n\n', q_rejected);

    
    % 更新累加总和
%     total_sumWaittime = total_sumWaittime + sumWaittime;
%     total_probability = total_probability + probability;
%     total_average = total_average + average;
%     total_maxWaittime = total_maxWaittime + maxWaittime;
%     total_minWaittime = total_minWaittime + minWaittime;
end

% 关闭文件
fclose(fileID);

% 打开文本文件以进行读取
fileID = fopen('simulation_results.txt', 'r');

% 初始化累加总和的计数器
count = 0;

% 初始化变量
sumWaittime_sum = 0;
average_sum = 0;
maxWaittime_sum = 0;
minWaittime_sum = 0;
blocknum_sum=0;
throughput_sum=0;
q_rejected_sum=0;

% 逐行读取文本文件
line = fgetl(fileID);
while ischar(line)
    % 检查行是否包含待读取的值
    if contains(line, 'sumWaittime')
        % 提取sumWaittime的值并累加
        tokens = regexp(line, '[-+]?[0-9]*\.?[0-9]+', 'match');
        sumWaittime_sum = sumWaittime_sum + str2double(tokens{end});
        count = count + 1;
    elseif contains(line, 'average')
        % 提取average的值并累加
        tokens = regexp(line, '[-+]?[0-9]*\.?[0-9]+', 'match');
        average_sum = average_sum + str2double(tokens{end});
    elseif contains(line, 'maxWaittime')
        % 提取maxWaittime的值并累加
        tokens = regexp(line, '[-+]?[0-9]*\.?[0-9]+', 'match');
        maxWaittime_sum = maxWaittime_sum + str2double(tokens{end});
    elseif contains(line, 'minWaittime')
        % 提取minWaittime的值并累加
        tokens = regexp(line, '[-+]?[0-9]*\.?[0-9]+', 'match');
        minWaittime_sum = minWaittime_sum + str2double(tokens{end});
    elseif contains(line, 'blocknum')
        % 提取minWaittime的值并累加
        tokens = regexp(line, '[-+]?[0-9]*\.?[0-9]+', 'match');
        blocknum_sum = blocknum_sum + str2double(tokens{end});
    elseif contains(line, 'throughput')
        % 提取minWaittime的值并累加
        tokens = regexp(line, '[-+]?[0-9]*\.?[0-9]+', 'match');
        throughput_sum = throughput_sum + str2double(tokens{end});
    elseif contains(line, 'q_rejected')
        % 提取minWaittime的值并累加
        tokens = regexp(line, '[-+]?[0-9]*\.?[0-9]+', 'match');
        q_rejected_sum = q_rejected_sum + str2double(tokens{end});
    end
    
    % 读取下一行
    line = fgetl(fileID);
end

% 关闭文件
fclose(fileID);

% 计算平均值
average_sumWaittime = sumWaittime_sum / 10;
average_average = average_sum / 10;
average_maxWaittime = maxWaittime_sum / 10;
average_minWaittime = minWaittime_sum / 10;
average_blocknum=blocknum_sum/10;
average_throughput=throughput_sum/10;
average_q_rejected=q_rejected_sum/10;

% 输出结果
% disp(['Average sumWaittime: ' num2str(average_sumWaittime)]);
% disp(['Average probability: ' num2str(average_probability)]);
% disp(['Average average: ' num2straverage_average)]);
% disp(['Average maxWaittime: ' num2str(average_maxWaittime)]);
% disp(['Average minWaittime: ' num2str(average_minWaittime)]);