function SelCh = Mutate(SelCh, Pm, gen, maxGen)
%% 变异操作
% 输入：
% SelCh  被选择的个体
% Pm     变异概率
% gen    当前代数
% maxGen 最大代数
% 输出：
% SelCh  变异后的个体

[NSel, L] = size(SelCh);

if nargin < 3
    gen = 1;
end
if nargin < 4
    maxGen = 1;
end

progress = gen / maxGen;
currentPm = Pm * (1 + 0.8 * progress);
currentPm = min(currentPm, 0.3);

[NSel, L] = size(SelCh);
for i = 1 : NSel
    if currentPm >= rand
        R = randperm(L, 2);
        p1 = min(R);
        p2 = max(R);

        if progress < 0.5
            SelCh(i, R(1 : 2)) = SelCh(i, R(2 : -1 : 1));
        else
            SelCh(i, p1 : p2) = SelCh(i, p2 : -1 : p1);
        end
    end
end
