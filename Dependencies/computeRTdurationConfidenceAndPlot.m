function[aCI,xi,gi,hp] = computeRTdurationConfidenceAndPlot(RDtotal,num,col)

% inputs are a vector of all observed run durations.
% number of bootstrap replicates.
% color to be plotted in RGB.

[bootstat,bootsam] = bootstrp(num,@mean,RDtotal);
disp(['avg ev. run duration ',num2str(mean(bootstat))])
for i = 1:num
    r = bootsam(:,i);
    RDcurr = RDtotal(r);
    [f,x] = ecdf(RDcurr);
    G{i} = 1-f;
    X{i} = x;
    %semilogy(x,g,'Color','g');
    %hold all
end
% evolved confidence intervals from bootstrapping.
MinMax = min(cellfun(@max,X)); % find the minimum maximum t_r.
delta = 0.0333; % step size in the t_r axis for interpolation.
xi = X{1}(1):delta:MinMax; % interpolation vector.
Gi = [];
for i=1:num
    [xtmp,idx,~] = unique(X{i}); 
    Gi(:,i) = interp1(xtmp,G{i}(idx),xi);
    %semilogy(Gi(:,i))
    %hold on
end
alpha = 0.05;
Gis = sort(Gi,2);
CI = Gis(:,[round(num*alpha/2), num - round(num*alpha/2)]);
% there are some nans here - only in regions where the CI is VERY tight.
% set those values to zero:
CI(isnan(CI)) = 0;
% now do the plotting:
% make an interpolated version of the actual data.
[f,x] = ecdf(RDtotal);
g = 1-f;
[xtmp,idx,~] = unique(x); 
gi = interp1(xtmp,g(idx),xi);
aCI = abs(bsxfun(@minus,CI',gi));
%aCI(:,1) = 0;
[hl1,hp] = boundedline(xi,gi,aCI','alpha');
set(gca,'yscale','log')
set(hl1,'color',0.6*col,'linewidth',3)
set(hp,'facecolor',col)


