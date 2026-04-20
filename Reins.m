function Chrom = Reins(Chrom, SelCh, ObjV, eliteCount)
%% 重插入子代的新种群
% 输入：
% Chrom 父代的种群
% SelCh 子代种群
% ObjV 父代适应度
% eliteCount 精英个体数量
% 输出：
% Chrom 组合父代与子代后得到的新种群

NIND = size(Chrom, 1);
NSel = size(SelCh, 1);

if nargin < 4
    eliteCount = 0;
end

eliteCount = min(max(eliteCount, 0), NIND - NSel);
[~, index] = sort(ObjV);

eliteChrom = Chrom(index(1 : eliteCount), :);
survivorChrom = Chrom(index(eliteCount + 1 : NIND - NSel), :);
Chrom = [eliteChrom; survivorChrom; SelCh];
