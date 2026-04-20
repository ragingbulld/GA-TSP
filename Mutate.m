function SelCh = Mutate(SelCh, Pm)
%% 变异操作
% 输入：
% SelCh  被选择的个体
% Pm     变异概率
% 输出：
% SelCh  变异后的个体

[NSel, L] = size(SelCh);
for i = 1 : NSel
    if Pm >= rand
        R = randperm(L, 2);
        fromPos = R(1);
        toPos = R(2);
        chrom = SelCh(i, :);

        gene = chrom(fromPos);
        chrom(fromPos) = [];

        if toPos == 1
            chrom = [gene, chrom];
        elseif toPos > L - 1
            chrom = [chrom, gene];
        else
            chrom = [chrom(1 : toPos - 1), gene, chrom(toPos : end)];
        end

        SelCh(i, :) = chrom;
    end
end
