
% DESCRIPTION
% Simulates a design (s,k) given some parameter assumptions (psi, p).
% Calculates the probability of each type of history via simulation. 
% Histories are summarized by the pair (SD, mysum) and MLEs are obtained
% with an optimization. Finally it calculates estimator bias and variance
%
% SYNTAXIS
% [probs,mybias_m,myvar_m,myMSE_m,msg] = tool_designsim(psi,p,s,k,nsims,doprint)
% where
%       psi: probability of occupancy
%       p: probability of detection
%       s: number of sites
%       k: number of replicates
%       nsims: number of simulations to calculate probs from (e.g.1e4)
%
%       probs: returns a matrix with nrows=nr possible histories, SD (1st 
%       column), mysum (2nd), the history probability (3rd), estimated psi 
%       (4th) and estimated p (5th). 
%       mybias_m: estimated bias of the estimators
%       myvar_m: estimated VC matrix of the estimators
%       myMSE_m: estimated MSE matrix of the estimators
%       pemtpy: prob empty history (from sims, theoretical is (1-psi*pp)^s
%       msg: string with output results to be printed out of the function
%       
% CREATION
% Gurutzeta Guillera
% v0.0 - 05Sep09 - version for tool based on probhistories1sp
%

function [probs,mybias_m,myvar_m,myMSE_m,pempty,msg] = tool_designsim(psi,p,s,k,nsims)

    %Generate and summarize histories
    for jjj=1:1:nsims
        Sp = binornd(s,psi);
        temp = binornd(k,p,1,Sp);
        summhist(jjj,:) = [sum(temp~=0),sum(temp)];
    end

    %Calculate probability of each history and solve
    jjj=0;iii=1;
    
    %treat first empty histories    
    mytemp = find(summhist(:,1)==0);
    pempty = length(mytemp)/nsims;
    summhist(mytemp,:)=NaN * ones(length(mytemp),2);
    probs(iii,:)=[0,0,pempty,NaN,NaN]; % MLE not unique in this case    
    
    for zzz = 1:nsims
        if isfinite(summhist(zzz,1))  %histories already counted set to NaN
            SD = summhist(zzz,1);
            mysum = summhist(zzz,2);                      
            iii=iii+1;
            probs(iii,1:2)=[SD,mysum];
            %Calculate and store probabilities for all potential histories
            temp = summhist(find(summhist(:,1)==summhist(zzz,1)),2);
            probs(iii,3) = (length(find(temp==mysum)))/nsims;
            %Set these histories to NaN
            mytemp = find(summhist(:,1)==summhist(zzz,1));
            mytemp2 = find(summhist(mytemp,2)==summhist(zzz,2));
            summhist(mytemp(mytemp2),:)=NaN * ones(length(mytemp2),2);            
            %Solve MLE (1 optim)             
            if ((s-SD)/s)<((1-mysum/(s*k)).^k)
                probs(iii,4:5) = [1,mysum/(s*k)];
            else
            myoptions = optimset('Display','off');
            estimates = fminsearch(@(params)tool_loglik(params, SD, mysum,s,k,0),[0,0],myoptions);           
            probs(iii,4:5) = 1./(1+exp(-estimates));  %to linear
            end       
        end
    end
     
    % calculate estimator properties excluding empty histories    
    temp = probs(2:end,:);
    temp(:,3) = temp(:,3)/sum(temp(:,3));
    mymeanpsi = sum(temp(:,4).*temp(:,3));
    mybiaspsi = mymeanpsi-psi;
    mymeanp = sum(temp(:,5).*temp(:,3));
    mybiasp = mymeanp-p;    
    myvarpsi = sum((temp(:,4)-mymeanpsi).^2 .*temp(:,3));
    myvarp = sum((temp(:,5)-mymeanp).^2 .*temp(:,3));
    mycovar = sum((temp(:,4)-mymeanpsi).*(temp(:,5)-mymeanp).*temp(:,3));     
    mybias_m = [mybiaspsi,mybiasp]; 
    myvar_m = [myvarpsi,mycovar;mycovar,myvarp]; 
    myMSE_m = myvar_m + mybias_m'*mybias_m;
    
    % message summarizing estimator properties
    msg = sprintf([' K = ',num2str(k),' s = ',num2str(s),' (TS = ',num2str(k*s),')',...
                   '\n','   biaspsi = ',num2str(mybias_m(1),'%+0.4f'),...
                   '    biasp = ',num2str(mybias_m(2),'%+0.4f'),...
                   '\n','    varpsi = ',num2str(myvar_m(1,1),'%+0.4f'),...
                   '     varp = ',num2str(myvar_m(2,2),'%+0.4f'),...
                   '    covar = ',num2str(myvar_m(2,1),'%+0.4f'),...
                   '\n','    MSEpsi = ',num2str(myMSE_m(1,1),'%+0.4f'),...
                   '     MSEp = ',num2str(myMSE_m(2,2),'%+0.4f'),...
                   '     psip = ',num2str(myMSE_m(2,1),'%+0.4f'),...                   
                   '\n','     critA = ',num2str(trace(myMSE_m),'%+0.4f'),...
                   '    critD = ',num2str(det(myMSE_m),'%+.3e'),...
                   '\n','     empty histories = ',num2str(100*pempty,'%0.1f'),'%%']);     
               
               
end
