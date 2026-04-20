function D = Distance(a, edgeWeightType)
%% 计算两两城市之间的距离
% 输入 a 各城市的位置坐标
% 输出 D 两两城市之间的距离

if nargin < 2
    edgeWeightType = 'RAW_EUC';
end

row = size(a, 1);
D = zeros(row, row);
for i = 1 : row
    for j = i + 1 : row
        dist = sqrt((a(i, 1) - a(j, 1))^2 + (a(i, 2) - a(j, 2))^2);
        if strcmpi(edgeWeightType, 'EUC_2D')
            dist = round(dist);
        end
        D(i, j) = dist;
        D(j, i) = D(i, j);
    end
end
