
% DESCRIPTION
% Calculates the number of sites to be surveyed 
%
% SYNTAXIS
% s = tool_findS(psi,p,k,prec,crit)
% where
%       psi: probability of occupancy
%       p: probability of detection
%       k: number of surveys per site (repeated visits)
%       
%       s: number of sites to be surveyed
%

function s = tool_findS(psi,p,k,prec,crit)

    pp=1-(1-p)^k;
    temp1 = psi * ( (1-psi) + (1-pp)/(pp-k*p*(1-p)^(k-1)));
    temp2 = (p*(1-p)/(k*psi)) * pp / (pp-k*p*(1-p)^(k-1));
    temp3 = p * (pp-1)/(pp-k*p*(1-p)^(k-1));
    switch crit
        case 1
            s = (1/prec) * temp1;
        case 2
            s = (1/prec) * ( temp1 + temp2) ;
        case 3
            s = (1/prec) * ( temp1*temp2 - temp3^2) ;
    end

return





