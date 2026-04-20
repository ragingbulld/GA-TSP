%% 清除变量和窗口
clear;
clc;
close all;

%% 1. 加载 TSPLIB 数据和参数
instance = LoadTSPLIBInstance(fullfile(fileparts(mfilename('fullpath')), 'data', 'eil101.tsp'));
X = instance.coords;
tsplibBest = 629;

NIND = 100;       % 种群大小
MAXGEN = 2000;    % 最大迭代次数
Pc = 0.9;         % 交叉概率
Pm = 0.1;        % 变异概率
GGAP = 0.9;       % 代沟 (generation gap)

D = Distance(X, instance.edgeWeightType);  % 生成距离矩阵
N = size(D, 1);   % 城市规模

%% 2. 初始化种群
Chrom = InitPop(NIND, N, D);
initialChrom = Chrom(1, :);
initialLength = PathLength(D, initialChrom);

%% 3. 优化过程图先生成
figure('Name', '遗传算法优化过程', 'NumberTitle', 'off');
hPlot = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);
xlabel('代数'); ylabel('当前最优路径长度');
title(['TSPLIB ', upper(instance.name), ' 收敛曲线']);
grid on;
hold on;

total_tic = tic;
gen = 0;
trace = zeros(1, MAXGEN);
bestGen = 0;
bestTime = 0;

ObjV = PathLength(D, Chrom); % 计算初始路径长度

while gen < MAXGEN
    % A. 计算适应度
    FitnV = Fitness(ObjV);
    
    % B. 选择
    SelCh = Select(Chrom, FitnV, GGAP);
    
    % C. 交叉
    SelCh = Recombin(SelCh, Pc);
    
    % D. 变异
    SelCh = Mutate(SelCh, Pm);
    
    % E. 进化逆转 (针对 TSP 的局部搜索增强)
    SelCh = Reverse(SelCh, D);
    
    % F. 重插入
    ObjVSel = PathLength(D, SelCh);
    Chrom = Reins(Chrom, SelCh, ObjV);
    
    % G. 更新代数并记录最优解
    gen = gen + 1;
    ObjV = PathLength(D, Chrom);
    [minObjV, minInd] = min(ObjV);
    trace(gen) = minObjV; % 存入追踪数组

    if gen == 1 || trace(gen) < min(trace(1:gen-1))
        bestGen = gen;
        bestTime = toc(total_tic);
    end
    
    set(hPlot, 'XData', 1:gen, 'YData', trace(1:gen));

    if gen > 1
        ylim([minObjV * 0.95, max(trace(1:gen)) * 1.05]);
        xlim([1, MAXGEN]);
    end

    drawnow;
end

totalTime = toc(total_tic);

%% 4. 输出结果并生成其余图形
disp(['数据集名称：', upper(instance.name)]);
disp(['城市数量：', num2str(N)]);
disp(['TSPLIB 已知最优值：', num2str(tsplibBest)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
disp(['初始种群中的一个随机值路径长度：', num2str(initialLength)]);
OutputPath(initialChrom);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');

disp(['优化后的最优路径长度：', num2str(trace(end))]);
[minObjV, minInd] = min(ObjV);
bestPath = Chrom(minInd, :);
OutputPath(bestPath);
disp(['与 TSPLIB 最优值的差距：', num2str(minObjV - tsplibBest)]);
disp(['相对最优误差：', num2str((minObjV - tsplibBest) / tsplibBest * 100, '%.4f'), '%']);
disp(['最优解首次出现代数：', num2str(bestGen)]);
disp(['搜索最优解耗时：', num2str(bestTime), ' 秒']);
disp(['总运行耗时：', num2str(totalTime), ' 秒']);

figure('Name', '城市分布图', 'NumberTitle', 'off');
plot(X(:,1), X(:,2), 'o');
title(['TSPLIB ', upper(instance.name), ' 城市分布']);
grid on;

DrawPath(initialChrom, X);
title(['初始随机路径图 (长度: ', num2str(initialLength), ')']);

DrawPath(bestPath, X);
title(['最终优化路径图 (长度: ', num2str(minObjV), ')']);
