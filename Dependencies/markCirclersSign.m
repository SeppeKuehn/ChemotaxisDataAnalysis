function [ p1 ] = markCirclersSign(p,wThresh,frac)
%markCirclers 
%   Pass the function a p structure, a threshold for omega, and a
%   fraction. The function will go through each individual in the
%   p-structure. For each individual it will analyze every run-event that
%   is more than 10 or more frames long, including ones that hit the wall.
%   Don't worry though, the frames that are near the wall are not
%   considered. In each of those run events, we use the sign.


p1 = p;

% I was calculating run tumbles inside the function. I imagine you will
% pass it a p structure where the 12th column is already made
%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:numel(p1)
%     %you should use your tumble detector here
%     %note that this tumble detector returns 1 when tumbling, 0 when
%     %running. that is important for when i use logical indexing to make all
%     %tumbling frames NaN
%     RT = identifyTumblesEmbo(p1(i).trajectory,.6,20,1,0); 
%     p1(i).trajectory(:,12) = RT;
% end


for i = 1:numel(p1)
    p1w = p1(i).trajectory(:,7); %These are the omegas
    
    % Make all omegas on the wall NaN
    idx = p1(i).trajectory(:,9);
    idx = ~idx;
    idx = logical(idx);
    p1w(idx) = NaN;

    % Make all omegas when tumbling NaN
    idx = p1(i).trajectory(:,12);
    idx = logical(idx);
    p1w(idx) = NaN;
    
    p1w = transpose(p1w); %Needs to be transposed to work with the splitVecbyNaN function
    
    %We want to a cell array of all the run events (in the form of a vector
    %of omegas) so we call the splitVecbyNaN function which will split p1w
    %at the NaNs and remove the NaNs.
    vectorCellArray = splitVecbyNaN(p1w); 
    
    %For each of those run events we will find the abs(mean(omega)) and put it in
    %meanOmegaVec. We will discard any run events that have fewer than 8
    %frames.
    meanSignVec = [];
    for j = 1:numel(vectorCellArray)
        if numel(vectorCellArray{j})>7
            meanSignVec = [meanSignVec abs(mean(sign(vectorCellArray{j})))];
        end
    end
    
    % Add that meanSignVec to the p structure
    p1(i).meanSignVec = meanSignVec;
    
    % Label the p structure as a circler or not
    if (sum(meanSignVec>wThresh)/numel(meanSignVec)) < frac
        p1(i).circler = 0;
    else
        p1(i).circler = 1;
    end
    
end


end

