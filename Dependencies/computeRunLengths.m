function[p] = computeRunLengths(p,i)
tmp = p(i).trajectory(:,14);
tmp(isnan(tmp)) = 3;
[fv,ev] = SplitVec(tmp','equal','first','last');
[z] = SplitVec(tmp');
x = p(i).trajectory(:,1);
y = p(i).trajectory(:,2);
m=1;L = [];
for j=1:length(z)
    if z{j}(1) ==1 && numel(z{j})>1
        L(m) = arclength(x(fv(j):ev(j)),y(fv(j):ev(j)));
        m=m+1;
    end
end
p(i).RL = L*0.15;