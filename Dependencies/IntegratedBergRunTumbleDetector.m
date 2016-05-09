function[p] = IntegratedBergRunTumbleDetector(p,bug)
[SW,v] = getVelocitiesOmega_BergStyle(p(bug).trajectory(:,1:2));
SW(:,1) = SW(:,1)*0.15/0.0333;
p(bug).trajectory(:,6:7) = SW; % NOTE I AM OVERWRITING THE OLD VERSION OF SPEED AND OMEGA.
% this results in some serious smoothing going on.  
% conversion for microscope -- 0.15um/pixel, 0.0333 s/frame.
cE = 5;
delta = 3;
alpha = 0.5;
LA = ComputeSixFrameAngles(v,delta);
SW(:,2) = abs(SW(:,2));
LA = abs(LA);
for i=1:10
    oldalpha(i) = alpha;
    %RT = Berg_RT_detector(SW,LA,alpha);
    RT = Berg_RT_detector_while(SW,LA,alpha);
    idx = logical(p(bug).trajectory(:,9));
    alpha = cE*nanmedian(SW(idx&~RT',2));
    if alpha < 0.4;
        alpha = 0.4;
    end
    if alpha >1
        alpha = 1;
    end
end
p(bug).trajectory(:,12) = RT;
p(bug).oldalpha = oldalpha;
p(bug).v = v;
p(bug).cE = cE;
end

%%%%%%%%%%%%%%%%%%% SUB-FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%

function[LargeAngles] = ComputeSixFrameAngles(v,delta)

% In addition to what we have above, I need a vector of changes in angle computed
% for three frames before and after each frame.  Computed.
%delta = 3;
for i=1:length(v)
   if i<delta+1
       sv = nansum(v(:,1:i),2);
       ev = nansum(v(:,i:i+delta),2);
   elseif i>length(v)-delta
       sv = nansum(v(:,i-delta:i),2);
       ev = nansum(v(:,i:end),2);
   else
       sv = nansum(v(:,i-delta:i),2);
       ev = nansum(v(:,i:i+delta),2);
   end
    Zsv = sv(1)+1i*sv(2);
    Zev = ev(1)+1i*ev(2);
    
    Rotated = exp(1i*(angle(Zsv)-angle(Zev)));
    LargeAngles(i) = -1*angle(Rotated);  % NOTE sign fixed 20101018
end
end
%%%%%%%%%%%%%%%%%%% SUB-FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%
function [SW,v] = getVelocitiesOmega_BergStyle(tmpT)
if size(tmpT,1)>size(tmpT,2)
   tmpT = tmpT'; 
end
% takes a raw trajectory and returns a matrix with speed and omega in
% columsn.
    v(1,:) = gradient(tmpT(1,:));
    v(2,:) = gradient(tmpT(2,:));  % THIS IS THE ONLY CHANGE RELATIVE TO BEFORE.
    %v(1,:) = tmpT(1,2:end)-tmpT(1,1:end-1);
    %v(2,:) = tmpT(2,2:end)-tmpT(2,1:end-1);


    speed = sqrt(v(1,:).^2 + v(2,:).^2);
    Omega = [getOmega(v),nan];
%    wall = w(1:end-1)|w(2:end);
    SW = horzcat(speed',Omega');
end

%GET OMEGA %
function [Omega] = getOmega(v)
       Z = v(1,:)+1i*v(2,:);      
       AbsTheta = angle(Z);
       Rotated = exp(1i*(AbsTheta(1:end-1)-AbsTheta(2:end)));
       Omega = -1*angle(Rotated);  % NOTE sign fixed 20101018
end