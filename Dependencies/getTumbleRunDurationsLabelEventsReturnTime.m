function [tumbleDurations, runDurations, label, RTtimes,runSpeed] = getTumbleRunDurationsLabelEventsReturnTime(p)
%UNTITLED2 This will return a vector of run durations and a vector of
% tumble durations. Only runs and tumbles that occurred entirely off
% the wall will be counted.
% p will need to already be analyzed for runs and tumbles

timeStep = .0333; % How long is each frame?

tumbleDurations = [];
runDurations = [];
timeTumble = []; % when the runs and tumbles occurred.
timeRun = [];
runSpeed = [];
for i = 1:numel(p)
    idx = (p(i).trajectory(:,9) == 0);
    runTumbleVectorOffWall = p(i).trajectory(:,12);
    runTumbleVectorOffWall(idx) = NaN;  
    Speed = p(i).trajectory(:,6);
    %keyboard
    % = SplitVec(runTumbleVectorOffWall,'equal','split');
    [z,t] = SplitVec(runTumbleVectorOffWall,'equal','split','bracket'); 
    
    
    label = cell(size(z));
    for j=1:length(z)
        label{j} = nan(size(z{j}));
    end
    for j = 2:(numel(z)-1)
        if z{j}(1) == 1
            if and(z{j-1}(1)==0,z{j+1}(1)==0)
                tumbleDurations = [tumbleDurations numel(z{j})];
                timeTumble = [timeTumble t(j,1)];
                label{j} = zeros(size(z{j}));
                
            end
        elseif z{j}(1) == 0
            if and(z{j-1}(1)==1,z{j+1}(1)==1)
                runDurations = [runDurations numel(z{j})];
                timeRun = [timeRun t(j,1)];
                runSpeed = [runSpeed, nanmean(Speed(t(j,1):t(j,2)))];
                label{j} = ones(size(z{j}));
            end
        end
    end

end
tumbleDurations = tumbleDurations*timeStep;
runDurations = runDurations*timeStep;
label = vertcat(label{:});
RTtimes = {timeTumble',timeRun'};
end
