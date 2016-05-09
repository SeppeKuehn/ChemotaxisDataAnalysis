function[s] = nansmoothing(x,w)

for i=1:length(x)
   if i-w<1
       s(i) = nanmean(x(1:i));
   elseif i+w>numel(x)
       s(i) = nanmean(x(i-w:end));
   else
      s(i) = nanmean(x(i-w:i+w));
   end
end
s(isnan(x)) = nan;