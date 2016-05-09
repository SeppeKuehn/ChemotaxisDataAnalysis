clc%% created 20160307 -- comparing the run tumble statistics for rounds 1-5-10-15.
% I would like to look at raw distributions.
%% can we rule out the possibility that the long run durations are not just
% from a biased sample due to the size of the chamber?
%% run duration distributions:
R = [1,5,10,15];
dataset= {'FounderAggregateFiveMinute','pE5o','pE10o','EvolvedAggregateFiveMinute'};

aRD = cell(1,4); aTD = cell(1,4); aVR = cell(1,4);
for j=1:length(dataset)
    load([pwd,'/Data/ProcessedTracking/',dataset{j},'_RTstats'])
    m=1;
    for i=1:length(p)
        if p(i).tumbler==1 || p(i).circler==1
            continue
        end
        tmp = p(i).RD;
        tmp = tmp(tmp>0.1);
        aRD{j} = [aRD{j},tmp];
        aTD{j} = [aTD{j},p(i).TD];
        aVR{j} = [aVR{j},p(i).aveRunSpeed];
        m=m+1;
    end
    N(j) = m-1;
    fN(j) = (m-1)/length(p);
end
%%
%% make a plot for talks of run durations.
colors = [1 1 1;...
          1 1 0;...
          0.9 0.4 0.17;...
          1 0 0];
figure('pos',[100 100 1400 900])
for i=1:4
    [~,~,~,hl(i)] = computeRTdurationConfidenceAndPlot(aRD{i},200,colors(i,:));
    hold on
end
set(gca,'fontsize',36,'linewidth',3,'ytick',[10^-4,10^-3,10^-2,10^-1,10^0])
makeFigureBlack(gca)
l = legend([hl(1),hl(2),hl(3),hl(4)],{'round 1','round 5','round 10','round 15'});
set(l,'textcolor','white')
xlim([0 9])
ylim([10^-5 1])
xlabel('Run time [s]','fontsize',40)
ylabel({'Fraction of runs','longer than given time'},'fontsize',40)
%l.textcolor = 'white';
export_fig([pwd,'/Output/RunDurationDistributions1_5_10_15'],'-png')
%% make a plot of run speeds.
colors = [1 1 1;...
          1 1 0;...
          0.9 0.4 0.17;...
          1 0 0];
figure('pos',[100 100 1400 900])

for i=1:4
    bins = [0:0.03333*40:60];
    [n,b] = hist(aVR{i},bins,'centers');
    plot(b,n/sum(n),'color',colors(i,:),'linewidth',4)
    hold on
    % xlim([0 2])
end
box off
makeFigureBlack(gca)
set(gca,'fontsize',36,'linewidth',3)
l = legend({'round 1','round 5','round 10','round 15'});
set(l,'textcolor','white','fontsize',28)
xlabel('Run speed [\mum/s]','fontsize',40)
ylabel('Probability','fontsize',40)
export_fig([pwd,'/Output/RunSpeedDistributions1_5_10_15'],'-png')



%%
colors = [1 1 1;...
          1 1 0;...
          0.9 0.4 0.17;...
          1 0 0];
figure('pos',[100 100 1400 900])
for i=1:4
    [~,~,~,hl(i)] = computeRTdurationConfidenceAndPlot(aTD{i},200,colors(i,:));
    hold on
end
set(gca,'fontsize',36,'linewidth',3,'ytick',[10^-4,10^-3,10^-2,10^-1,10^0])
makeFigureBlack(gca)
l = legend([hl(1),hl(2),hl(3),hl(4)],{'round 1','round 5','round 10','round 15'});
set(l,'textcolor','white')
%xlim([0 9])
%ylim([10^-5 1])
xlabel('{$\tau_t$ [s]}','fontsize',40,'Interpreter','latex')
ylabel('1-CDF','fontsize',40)
%l.textcolor = 'white';
%export_fig RunDurationEvolution -png

%% INDIVIDUAL LEVELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%
col = 'kcmg';
bins = [0:3*0.03333:10];
for i=[1:4]
   for j=1:400
       %subplot(1,4,i)
       [n,b] = hist(aRDi{j,i},bins);
       N{i}(j,:) = n/sum(n);
       semilogy(b,n/sum(n),[col(i),'.'])
       hold on
   end
   xlim([0 7])
   ylim([10^-3 1])
end
%% look at the population average distribution.
for i=1:4
   semilogy(b,nanmean(N{i}))
   hold all
end
% these population averages are consistent with the aggregate.  as they
% should be.  The thing is that the mean of these distributions does not
% change substantially -- it is mostly in the variance.


%% look at the means.
col = 'kcmg';
for i=1:4
   for j=1:400
       M(j,i) = nanmean(aRDi{j,i});
   end
   [n,b] = hist(M(:,i),[0:0.05:1]);
   stairs(b,n/sum(n),col(i))
   hold all
end
plot(M)
%%
col = 'kcmg';
for i=1:4
   for j=1:400
       M(j,i) = nanmean(aTDi{j,i});
   end
   [n,b] = hist(M(:,i),[0:0.01:0.2]);
   stairs(b,n/sum(n),col(i))
   hold all
end
%% look
col = 'kcmg';
for i=1:4
   for j=1:400
       M(j,i) = nanmean(aVRi{j,i});
   end
   [n,b] = hist(M(:,i),[1:3:60]);
   stairs(b,n/sum(n),col(i))
   hold all
end





