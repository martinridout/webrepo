% DESCRIPTION
% Builds the -log likelihood function for the 1sp model with constant
% probability of occupancy (psi) and detection (p) based on the summary of 
% the detection history (SD and mysum)
%
% SYNTAXIS
% loglik = tool_loglik(params, SD, mysum, s, k, lin)
% where
%       params: [psi,p] where the likelihood function is to evaluated
%       SD: number of sites where species detected
%       mysum: number of ones in the history
%       s: number of sites
%       k: number of replicates
%       lin: 1 if params in linear domain, otherwise assumed logit domain
%

function loglik = tool_loglik(params, SD, mysum, s, k, lin)
    if (lin)
        psi         = params(1);   
        p           = params(2);  
    else 
        psi         = 1/(1+exp(-params(1)));  
        p           = 1/(1+exp(-params(2)));
    end
    % avoid log of zero
    psi=min(max(psi,1e-12),1-1e-12);
    p=min(max(p,1e-12),1-1e-12);
    
    loglik = -(SD*log(psi)+mysum*log(p)+(k*SD-mysum)*log(1-p)+(s-SD)*log((1-psi)+psi*(1-p)^k));
return


