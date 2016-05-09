function[tVec] = Berg_RT_detector_while(SW,LA,alpha)

% do the RT detection.
tVec = false(1,length(SW)); % specifiying tumble
SW(:,2) = abs(SW(:,2)); % need to make all angles positive!
LA = abs(LA);

tVec(1:3) = SW(1:3,2) > alpha;
fL = length(SW)-3;
i=4;
notdone = true;
while notdone
    
    if all(SW(i:i+3,2) < alpha)
        running = true;
        tVec(i) = false;
        while running
            if i>fL
                notdone = false;
                break
            end
            
            if SW(i,2) > alpha && SW(i+1,2) > alpha
                   tVec(i) = true;
                   running = false;
                   i = i+1;
            elseif SW(i,2) > alpha && LA(i) > alpha
                   running = false;
                   tVec(i) = true;
                   i = i+1;
            else
                    tVec(i) = false;
                    i = i+1;
            end
        end
    else
        tVec(i) = true;
        if i>fL
            notdone = false;
            break
        end
        i = i+1;
    end
    
    if i>fL
        notdone = false;
    end
end

