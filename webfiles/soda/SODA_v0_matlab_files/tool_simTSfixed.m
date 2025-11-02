%
% DESCRIPTION
% Find best design for a given total effort
%
% SYNTAXIS
% [chosen,chosenbias,chosenvar,chosenMSE] = tool_simTSfixed(psi,p,TS...
%    Kstart,nsims,tolF,doKstart,Kstartbias,Kstartvar,KstartMSE,crit) 
% where
%       psi: probability of occupancy
%       p: probability of detection
%       TS: total effort
%       Kstart: value around which perform simulation check
%       nsims: number of simulations to calculate probs from (e.g.1e4)
%       tolF: tolerance used to decided when to break search
%       doKstart: 1: calculate for Kstart 0:use values given
%       Kstartbias: bias for design with Kstart (no needed if doKstart=0)
%       Kstartvar: var for the design with Kstart (no needed if doKstart=0)
%       KstartMSE: MSE for the design with Kstart (no needed if doKstart=0)
%       crit: criterion for design (1:psiMSE, 2:A-optim, 3:D-optim)
%
%       chosen: best design for given TS
%       chosenbias: bias of best design
%       chosenvar: VC matrix of best design 
%       chosenMSE: MSE matrix of best design
%       

function [chosen,chosenbias,chosenvar,chosenMSE,chosenpempty] = tool_simTSfixed(psi,p,...
          TS,Kstart,nsims,tolF,doKstart,Kstartbias,Kstartvar,KstartMSE,pemptystart,crit)   
  
  %start with Kstart    
  kkk = Kstart;
  sss = floor(TS/kkk);
  chosen = [kkk,sss];     
  if (doKstart)     
    [probs,mybias,myvar,myMSE,pempty,msg] = tool_designsim(psi,p,sss,kkk,nsims);
    disp(msg);
    chosenMSE=myMSE;chosenbias=mybias;chosenvar=myvar;
  else
    chosenMSE=KstartMSE;chosenbias=Kstartbias;chosenvar=Kstartvar;
    chosenpempty=pemptystart;
  end
  chosencrits = [chosenMSE(1,1),trace(chosenMSE),det(chosenMSE)];  
        
  %continue checking larger K
  for kkk=(Kstart+1):1:(TS/2)
    sss = floor(TS/kkk);
    [probs,mybias,myvar,myMSE,pempty,msg] = tool_designsim(psi,p,sss,kkk,nsims);
    crits = [myMSE(1,1),trace(myMSE),det(myMSE)];        
    disp(msg);        
    if (crits(crit)<chosencrits(crit)) chosen = [kkk,sss]; chosenMSE=myMSE;
        chosenbias = mybias; chosenvar = myvar; chosencrits = crits;
        chosenpempty = pempty;
    else if crits(crit)>(tolF*chosencrits(crit)) break;end
    end
  end
    
  %continue checking smaller K
  for kkk=(Kstart-1):-1:2
    sss = floor(TS/kkk);
    [probs,mybias,myvar,myMSE,pempty,msg] = tool_designsim(psi,p,sss,kkk,nsims);
    crits = [myMSE(1,1),trace(myMSE),det(myMSE)];
    disp(msg);
    if (crits(crit)<chosencrits(crit)) chosen = [kkk,sss]; chosenMSE=myMSE;
        chosenbias = mybias;chosenvar = myvar; chosencrits = crits;
        chosenpempty = pempty;
    else if crits(crit)>(tolF*chosencrits(crit)) break;end
    end
  end
    
end

