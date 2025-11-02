
% DESCRIPTION
% Calculates the optimum K based on asymptotic properties
%
% SYNTAXIS
% Kopt = tool_Koptim(psi,p,crit)
% where
%       psi: probability of occupancy
%       p: probability of detection
%       crit: criterion to calculate Kopt 
%            (1: psi var, 2: A-optimality, 3: D-optimality)
%       

function Kopt = tool_Koptim(psi,p,crit)

TS=5e5;       %Kopt independent of TS. High to avoid ceiling effect   
for k=2:1:50
    Sigma = tool_asymprec(psi,p,k,ceil(TS/k));
    switch crit
        case 1
            temp(k-1) = Sigma(1,1);
        case 2
            temp(k-1) = trace(Sigma);
        case 3
            temp(k-1) = det(Sigma);
    end
    [a1,b1] = min(temp); 
    Kopt = b1+1;
end
