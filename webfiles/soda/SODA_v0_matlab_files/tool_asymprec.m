
% DESCRIPTION
% Calculates the asymptotic properties of the estimators
%
% SYNTAXIS
% [Sigma,prec,msg] = tool_asymprec(psi,p,k,s,crit)
% where
%     psi: probability of occupancy
%       p: probability of detection
%       k: number of surveys per site (repeated visits)       
%       s: number of sites to be surveyed
%
%   Sigma: VC matrix 
%     msg: message with asymptotic properties summary
%

function [Sigma,msg] = tool_asymprec(psi,p,k,s)

  pp=1-(1-p)^k;
  varpsi      = psi/s * ( (1-psi) + (1-pp)/(pp-k*p*(1-p)^(k-1)));
  varp        = (p*(1-p)/(s*k*psi)) * pp / (pp-k*p*(1-p)^(k-1));
  covarpsip   = p/s * (pp-1)/(pp-k*p*(1-p)^(k-1));   
  Sigma=[varpsi covarpsip; covarpsip varp];
   
  msg = sprintf([' asymptotic properties','\n',' varpsi = ',...
     num2str(Sigma(1,1),'%0.4f'),' varp = ',num2str(Sigma(2,2),'%0.4f'),...
     ' covar = ',num2str(Sigma(1,2),'%0.4f'),'\n',' crit A = ',...
     num2str(trace(Sigma),'%0.4f'),' crit D = ',num2str(det(Sigma),'%.3e')]);    

return





