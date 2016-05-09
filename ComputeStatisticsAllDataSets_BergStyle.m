%% 20160509 -- YOU DO NOT NEED TO RUN THIS TO GENERATE FIGURES.  This is a processing
% script to generate data that is used downstream to make figures.
% this script goes from the tracking algorithm output to a full
% characterization of behavioral statistics, run-tumble analysis, circling,
% cell size, run lengths, etc are all computed.  The raw data from Harry's
% tracking experiments are in /Data/RawTracking.  The output of this script
% is in /Data/ProcessedTracking and all datasets are appended with
% '_RTstats.mat'.

% /Depedencies/ NEEDS TO BE IN THE PATH.
%% names of available datasets are here:
d = {'FounderAggregateFiveMinute','pE5o','pE10o','EvolvedAggregateFiveMinute','pEvolvedChangingOD','pFounderChangingOD',...
    'pFounderFull','pEvolvedFull','pRP437120','pclpX','pdelta1bp'};
% 20160307 -- some modifications to the Shimadzu detector.  Put global
% upper and lower bounds on alpha (0.4,1).  
%% for each dataset of interest compute the run and tumble statistics for all 
% individuals. aveRunSpeed is the average speed computed for each run.
% runSpeeds is the speeds for all frames called as runs.
wThresh = 0.17; circlerFrac = 0.65;
localDir = pwd;
for ind = [1]
    ind
    load([localDir,'/Data/RawTracking/',d{ind}])
    for i = 1:numel(p)
        p = IntegratedBergRunTumbleDetector(p,i);
        %p(i).trajectory(:,13) = vertcat(filtW,nan);
        [p(i).TD, p(i).RD, p(i).trajectory(:,14),p(i).RTtimes,p(i).aveRunSpeed] = getTumbleRunDurationsLabelEventsReturnTime(p(i));
        idxOW = p(i).trajectory(:,14);
        idxOW(isnan(idxOW)) = 0 ;
        idxOW = logical(idxOW);
        runIdx = ~logical(p(i).trajectory(:,12));
        p(i).runSpeeds = p(i).trajectory(idxOW&runIdx,6);
        
        wIdx = ~logical(p(i).trajectory(:,12)); % compute a smoothed size vector.
        s = p(i).trajectory(:,3);
        s(wIdx) = nan;
        p(i).smSize = nansmoothing(s,500);
        
        % compute the run lengths and add this to the p structure as .RL
        p = computeRunLengths(p,i);
        
        p(i).CirclerWThresh = wThresh;
        p(i).circlerFrac = circlerFrac;
        if nanmean(p(i).TD)>0.4
            p(i).tumbler = 1;
        else
            p(i).tumbler = 0;
        end
    end
    p = markCirclersSign(p,wThresh,circlerFrac);
    M = [];
    for i=1:length(p)
       M(i,1) = nanmean(p(i).RD);
       M(i,2) = nanstd(p(i).RD);
       M(i,3) = nanmean(p(i).TD);
       M(i,4) = nanmean(p(i).runSpeeds);
    end
    save([pwd,'/Data/ProcessedTracking/',d{ind},'_RTstats.mat'],'M','p')
end
%%
% high cE miss some cells in evolved very badly.  178, 256,222,304
% the issue is when you have very "wiggly" runs which seems to happen in
% evolved then the threshold is very high and many tumbles are missed.  Put
% an upper bound on the threshold.


