function [vectorCell] = splitVecbyNaN(x)
% split vector into all the bits that are separated by NaNs
% then return a cell with entries being all the separate vectors

k = 1;
vectorCell = [];
Indices = [0 find(isnan(x)) length(x)+1];

for i = 1:(length(Indices) - 1)
    Temp = x( (Indices(i)+1) : (Indices(i + 1)-1) );
    if ~isempty(Temp)
        vectorCell{k} = Temp;
        k = k+1;
    end
end


end

