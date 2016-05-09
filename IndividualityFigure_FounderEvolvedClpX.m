%% 20160311 -- looking at individuality to determine if 

R = [1,5,10,15,19,23];
dataset= {'FounderAggregateFiveMinute','pE5o','pE10o','EvolvedAggregateFiveMinute','pclpX','pdelta1bp'};

aRD = cell(1,6); aTD = cell(1,6); aVR = cell(1,6);
for j=1:length(dataset)
    load([pwd,'/RunTumbleDetectedBerg/',dataset{j},'_RTstats'])
    for i=1:length(p)
        if p(i).tumbler==1
           continue 
        end
        aRD{j} = [aRD{j},p(i).RD];
        aTD{j} = [aTD{j},p(i).TD];
        aVR{j} = [aVR{j},p(i).aveRunSpeed];
    end
    M = M(M(:,1)<1,:);
    M = M(M(:,3)<0.4,:);
    aM{j} = M;
end
%%
colors = [0 0 0;...
          1 1 0;...
          0.9 0.4 0.17;...
          1 0 0;...
          0 1 0;...
          0 0 1];
      
figure('pos',[100 100 1600 500])
subplot(1,2,1)
nb = 200;
for i=1:6
    M = aM{i};
   for j=1:nb
      idx = randsample(size(M,1),size(M,1),true);
      stat(j) = nanstd(M(idx,1));
   end
   astat = sort(stat);
   CI = astat([10,190]);
   errorbar(R(i),nanstd(M(:,1)),abs(CI(1)-nanstd(M(:,1))),abs(CI(2)-nanstd(M(:,1))),'o','color',colors(i,:),'markersize',10,'linewidth',3)
   hold on
end
set(gca,'fontsize',20,'linewidth',3,'xtick',R,'xticklabel',{'F','5','10','15','clpX','delta1bp'})
xlim([0 25])
ylim([0.07 0.21])
title('stdev in run duration')
%
%makeFigureBlack(gca)
xlabel('Round')
subplot(1,2,2)
nb = 200;
for i=1:6
    M = aM{i};
   for j=1:nb
      idx = randsample(size(M,1),size(M,1),true);
      stat(j) = nanstd(M(idx,4));
   end
   astat = sort(stat);
   CI = astat([5,195]);
   errorbar(R(i),nanstd(M(:,4)),abs(CI(1)-nanstd(M(:,4))),abs(CI(2)-nanstd(M(:,4))),'o','color',colors(i,:),'markersize',10,'linewidth',3)
   hold on
end
set(gca,'fontsize',20,'linewidth',3,'xtick',R,'xticklabel',{'F','5','10','15','clpX','delta1bp'})
xlim([0 25])
ylim([3.5 7])
xlabel('Round')
title('stdev in run speed')
%makeFigureBlack(gca)
set(gcf,'color','w')
export_fig EvolvingIndividualityClpXDelta1bp -png
%%
colors = [1 1 1;...
          1 1 0;...
          0.9 0.4 0.17;...
          1 0 0];
      
figure('pos',[100 100 1600 500])
subplot(1,2,1)
nb = 200;
for i=1:4
    M = aM{i};
   for j=1:nb
      idx = randsample(size(M,1),size(M,1),true);
      stat(j) = nanstd(M(idx,2));
   end
   astat = sort(stat);
   CI = astat([10,190]);
   errorbar(R(i),nanstd(M(:,2)),abs(CI(1)-nanstd(M(:,2))),abs(CI(2)-nanstd(M(:,2))),'o','color',colors(i,:),'markersize',10,'linewidth',3)
   hold on
end
set(gca,'fontsize',28,'linewidth',3,'xtick',R)
xlim([0 16])
%ylim([0.07 0.21])
makeFigureBlack(gca)
xlabel('Round')
subplot(1,2,2)
nb = 200;
for i=1:4
    M = aM{i};
   for j=1:nb
      idx = randsample(size(M,1),size(M,1),true);
      stat(j) = nanstd(M(idx,3));
   end
   astat = sort(stat);
   CI = astat([5,195]);
   errorbar(R(i),nanstd(M(:,3)),abs(CI(1)-nanstd(M(:,3))),abs(CI(2)-nanstd(M(:,3))),'o','color',colors(i,:),'markersize',10,'linewidth',3)
   hold on
end
set(gca,'fontsize',28,'linewidth',3,'xtick',R)
xlim([0 16])
%ylim([3.5 7])
xlabel('Round')
makeFigureBlack(gca)
%% do a permutation test for these two parameters.
ind = [1,4];
n1 = size(aM{ind(1)},1);
nt = n1 + size(aM{ind(2)},1);
nb = 5000;
Cdata = vertcat(aM{ind(1)},aM{ind(2)});
for k=1:4
    sStat(k) = var(aM{ind(1)}(:,k))/var(aM{ind(2)}(:,k)); % population standard deviation.
    for j=1:nb
        bs1 = randsample(nt,n1,false);
        idx = true(nt,1);
        idx(bs1) = false;
        T(j,k) = var(Cdata(idx,k))/var(Cdata(~idx,k));
    end
end
%%
hist(T(:,4),100)
hold on
sStat(4)
sum(T(:,4)>sStat(4))/nb
%%



