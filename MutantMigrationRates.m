%% 20160511 -- SK -- script plots the migration rates of the (single) mutants
% that Dave constructed and measured on 4/23/2016.

load([pwd,'/Data/MigrationRates/MutMigrationRates.mat'])

%% plot the rates as a function of mutation.
colors = [0.35 0.35 0.35;...
          1 0 0;...
          1 0 0;...
          0 1 0];
x = [3 2 1 4 3 2 1 4];
figure('pos',[100 100 800 400])
for i=1:length(x)
   errorbar(x(i),MutMigration.rate(i),MutMigration.CI(1,i)*60/85,MutMigration.CI(2,i)*60/85,'o','color',colors(x(i),:),'markersize',12,'linewidth',2)
   hold on
end
set(gca,'linewidth',2,'xtick',[1 2 3 4],'xticklabel',{'F','del. 1bp','clpX E185*','round 15'},'fontsize',16)
set(gcf,'color','w')
export_fig([pwd,'/Output/MutantMigrationSpeeds'],'-png')
%%