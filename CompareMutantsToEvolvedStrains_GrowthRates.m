%% compare growth rates in Full LB for founder, rounds 5, 10, 15 and RP437.
load([pwd,'/Data/GrowthRates/D_fullLB.mat'])
figure('pos',[100 100 1200 400])
for i=1:length(D)
   if strcmp(D(i).strain,'founder')
       col = 'k';
       x = 1;
       Founder(i) = D(i).cfit.p1*3600;
   else
       col = 'g';
       x = 15;
   end
   %subplot(1,2,1)
   CI = confint(D(i).cfit);
   errorbar(x,D(i).cfit.p1*3600,abs(CI(1,1) - D(i).cfit.p1)*3600,abs(CI(2,1) - D(i).cfit.p1)*3600,['o',col],'markersize',12,'linewidth',2);
   hold on
end
%
load([pwd,'/Data/GrowthRates/D_fullLB_R5And10.mat'])
for i=1:length(D)
   if strcmp(D(i).strain,'round5')
       col = 'k';
       x = 5;
   else
       col = 'k';
       x = 10
   end
   %subplot(1,2,1)
   CI = confint(D(i).cfit);
   errorbar(x,D(i).cfit.p1*3600,abs(CI(1,1) - D(i).cfit.p1)*3600,abs(CI(2,1) - D(i).cfit.p1)*3600,['o',col],'markersize',12,'linewidth',2);
   hold on
end
load([pwd,'/Data/GrowthRates/D_fullLB_Mutants.mat'])
for i=1:length(D)
   if strcmp(D(i).strain,'clpX')
       col = 'k';
       x = -2;
   else
       col = 'k';
       x = -4;
   end
   %subplot(1,2,1)
   CI = confint(D(i).cfit);
   errorbar(x,D(i).cfit.p1*3600,abs(CI(1,1) - D(i).cfit.p1)*3600,abs(CI(2,1) - D(i).cfit.p1)*3600,['o',col],'markersize',12,'linewidth',2);
   hold on
end
set(gcf,'color','w')
set(gca,'xtick',[-4 -2 1 5 10 15],'xticklabel',{'del. 1bp','clpX','F','5','10','15'},'fontsize',14)
ylabel('Specific growth rate [1/h]')
export_fig([pwd,'/Output/CompareEvolvedToMutantsGrowthRates'],'-png')

