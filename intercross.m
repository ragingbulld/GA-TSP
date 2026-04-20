function [a, b] = intercross(a, b)
% 输入：
% a 和 b 为两个待交叉的个体
% 输出：
% a 和 b 为交叉后得到的两个个体

a = scx_child(a, b);
b = scx_child(b, a);

function child = scx_child(parent1, parent2)
L = length(parent1);
child = zeros(1, L);
used = false(1, L);
current = parent1(1);

for k = 1 : L
    child(k) = current;
    used(current) = true;

    if k == L
        break;
    end

    cand1 = next_unvisited_successor(parent1, current, used);
    cand2 = next_unvisited_successor(parent2, current, used);

    if cand1 == 0 && cand2 == 0
        remaining = find(~used);
        distances = city_distance(current, remaining);
        [~, idx] = min(distances);
        current = remaining(idx);
    elseif cand1 == 0
        current = cand2;
    elseif cand2 == 0
        current = cand1;
    else
        if city_distance(current, cand1) <= city_distance(current, cand2)
            current = cand1;
        else
            current = cand2;
        end
    end
end

if numel(unique(child)) ~= L
    error('SCX交叉生成了非法个体');
end

function candidate = next_unvisited_successor(parent, current, used)
L = length(parent);
pos = find(parent == current, 1);
candidate = 0;
for step = 1 : L - 1
    nextPos = mod(pos - 1 + step, L) + 1;
    city = parent(nextPos);
    if ~used(city)
        candidate = city;
        return;
    end
end

function dist = city_distance(fromCity, toCities)
global GLOBAL_TSP_DISTANCE;
dist = GLOBAL_TSP_DISTANCE(fromCity, toCities);
