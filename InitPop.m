function Chrom = InitPop(NIND, N, D)
%% 初始化种群
% 输入：
% NIND：种群大小
% N：个体染色体长度（这里为城市的个数）
% D：距离矩阵，用于贪心初始化
% 输出：
% 初始种群

Chrom = zeros(NIND, N);                     % 用于存储种群
greedyCount = floor(NIND * 0.3);

for i = 1 : NIND - greedyCount
    Chrom(i, :) = randperm(N);              % 随机生成初始种群
end

for i = NIND - greedyCount + 1 : NIND
    startCity = randi(N);
    route = zeros(1, N);
    visited = false(1, N);

    route(1) = startCity;
    visited(startCity) = true;

    for j = 2 : N
        currentCity = route(j - 1);
        candidateDist = D(currentCity, :);
        candidateDist(visited) = inf;
        [~, nextCity] = min(candidateDist);
        route(j) = nextCity;
        visited(nextCity) = true;
    end

    Chrom(i, :) = route;
end
