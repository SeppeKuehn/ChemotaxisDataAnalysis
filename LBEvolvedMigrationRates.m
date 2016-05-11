%% 20160511 -- plots the front migration rates from the 8 replicate LB evolved experiments.

load([pwd,'/Data/MigrationRates/LBMigrationRates.mat'])
sym = 'osv+';
for k=1:size(R,1)
    plot([1:15],R(k,1:15),['-',sym(ceil(k/2))],'markersize',10,'linewidth',3,'markerfacecolor','w')
    hold all
end
