function SODA_v0
 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %                           PREPARE GUI                              %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[360,500,610,385],...
       'NumberTitle','off','Toolbar','none','MenuBar','none',...
       'Resize','off');
   colorfig = get(f,'Color');
   
   rfY=290;
 
   %  Construct the components.
   hp1 = uipanel('Title','Assumptions','FontSize','default',...
         'BackgroundColor',colorfig,'Units','pixels',...
         'Position',[250,rfY,110,80]);   
   hinputpsi  = uicontrol('Style','edit','String','0.2',...
                'Position',[295,rfY+40,55,20],'Callback',{@inputpsi_Callback});
   htitlepsi  = uicontrol('Style','text','String','psi',...
                'Position',[260,rfY+37,35,20],'BackgroundColor',colorfig,...
                'HorizontalAlignment','center');     
   hinputp    = uicontrol('Style','edit','String','0.3',...
                'Position',[295,rfY+10,55,20],'Callback',{@inputp_Callback});
   htitlep    = uicontrol('Style','text','String','p',...
                'Position',[260,rfY+7,35,20],'BackgroundColor',colorfig,...
                'HorizontalAlignment','center');   
                        
   hinputnits = uicontrol('Style','edit','String', '10000',...
                'Position',[295,rfY-30,55,20],'Callback',{@inputnits_Callback});       
   htitlenits = uicontrol('Style','text','String','n. sims',...
                'Position',[255,rfY-33,40,20],'BackgroundColor',colorfig);                            
                       
   ha   = axes('Units','Pixels','Position',[50,rfY-100,180,175]);       
   
   houttitle = uicontrol('Style','text','String','RESULTS',...
              'Position',[160,rfY-170,100,40],'BackgroundColor',colorfig);   
   houtf = uicontrol('Style','frame','Position',[50,20,310,125]);                    
   hout = uicontrol('Style','text','String','','HorizontalAlignment','left',...
              'Position',[51,21,308,123],'BackgroundColor',[1 1 1]);           
   
   hpg1 = uipanel('Title','Find design','FontSize','default',...
         'BackgroundColor',colorfig,'Units','pixels',...
         'Position',[375,rfY-125,215,205]);           
        
   hp2 = uipanel('Title','Requirements','FontSize','default',...
         'BackgroundColor',colorfig,'Units','pixels',...
         'Position',[387,rfY-20,130,83]);     
   hinputTS   = uicontrol('Style','edit','String','350',...
                'Position',[453,rfY+20,55,20],'Callback',{@inputTS_Callback}); 
   htitleTS   = uicontrol('Style','text','String','max TS',...
                'Position',[405,rfY+18,45,20],'BackgroundColor',colorfig);
   hinputvar  = uicontrol('Style','edit','String', '0.0056',...
                'Position',[453,rfY-10,55,20],'Callback',{@inputvar_Callback}); 
   htitlevar  = uicontrol('Style','text','String','qual thres',...
                'Position',[400,rfY-13,50,20],'BackgroundColor',colorfig);  
      
   hp3 = uipanel('Title','Priority','FontSize','default',...
         'BackgroundColor',colorfig,'Units','pixels',...
         'Position',[387,rfY-110,95,83]);     
   hinputpriorA = uicontrol('Style','radiobutton','String','precision',...
                'Position',[400,rfY-70,70,20],'Value',1,'BackgroundColor',...
                colorfig,'Callback',{@inputpriorA_Callback});   
   hinputpriorB = uicontrol('Style','radiobutton','String','min effort',...
                'Position',[400,rfY-95,70,20],'Value',0,'BackgroundColor',...
                colorfig,'Callback',{@inputpriorB_Callback});     
   
   hp4 = uipanel('Title','Criterion','FontSize','default',...
         'BackgroundColor',colorfig,'Units','pixels',...
         'Position',[495,rfY-110,85,83]);     
   hinputcrit1  = uicontrol('Style','radiobutton','String','psi MSE',...
                'Position',[505,rfY-65,70,20],'Value',1,'BackgroundColor',...
                colorfig,'Callback',{@inputcrit1_Callback});   
   hinputcrit2  = uicontrol('Style','radiobutton','String','A-opt',...
                'Position',[505,rfY-85,70,20],'Value',0,'BackgroundColor',...
                colorfig,'Callback',{@inputcrit2_Callback},'enable','on'); 
   hinputcrit3  = uicontrol('Style','radiobutton','String','D-opt',...
                'Position',[505,rfY-105,70,20],'Value',0,'BackgroundColor',...
                colorfig,'Callback',{@inputcrit3_Callback},'enable','on');      
              
   hrun = uicontrol('Style','Pushbutton','String','Run',...
          'Position',[530,rfY-20,50,75],'Callback',{@run_Callback}); 
      
   hpg2 = uipanel('Title','Evaluate design','FontSize','default',...
         'BackgroundColor',colorfig,'Units','pixels',...
         'Position',[375,30,215,117]);  
   hp5 = uipanel('Title','Design parameters','FontSize','default',...
         'BackgroundColor',colorfig,'Units','pixels',...
         'Position',[387,45,130,83]);      
   hinputS   = uicontrol('Style','edit','String', '50',...
                'Position',[453,85,55,20],'Callback',{@inputS_Callback}); 
   htitleS   = uicontrol('Style','text','String','sites',...
                'Position',[400,82,50,20],'BackgroundColor',colorfig);
   hinputK  = uicontrol('Style','edit','String', '7',...
                'Position',[453,55,55,20],'Callback',{@inputK_Callback}); 
   htitleK  = uicontrol('Style','text','String','replicates',...
                'Position',[400,52,50,20],'BackgroundColor',colorfig);        
   hrun2 = uicontrol('Style','Pushbutton','String','Test',...
          'Position',[530,45,50,75],'Callback',{@run2_Callback}); 

   
   % Change units to normalized so components resize automatically
   set([f,hp1,hinputpsi,htitlepsi,hinputp,htitlep,hp2,hinputTS,htitleTS,...
       hinputvar,htitlevar,hinputnits,htitlenits,hp3,hinputpriorA,...
       hinputpriorB,hp4,hinputcrit1,hinputcrit2,hinputcrit3,hrun,ha,...
       houttitle,hout,houtf,hp5,hpg1,hpg2,hinputK,htitleK,hinputS,...
       htitleS,hrun2],'Units','normalized');
  
   % Initialize input variables
   mypsi = 0.2; myp = 0.3; maxTS = 350; maxMSE = 0.0056;
   crit = 1; %1: MSE psi, 2: A-optim, 3: D-optim
   critst = 'psi MSE';
   prior = 1; %1: min MSE, cc: min TS
   priorst = 'precision';
   nsims = 1e4;
   numrun = 0;
   myfigfont = 9;
   myK = 7; myS = 50;
  
   % Initialize plot space
   set(gca,'Box','on','XLim',[0 1], 'YLim',[0 1],'FontSize',myfigfont,...
       'YTick',0:0.2:1,'XTick',0:0.2:1);
   ylabel('\psi','FontWeight','default','FontSize',myfigfont);
   xlabel('p','FontWeight','default','FontSize',myfigfont);
   
   % Centre and make GUI visible
   set(f,'Name','SODA - Single-season Occupancy study Design Assistant - v0 (beta)')
   movegui(f,'center')
   set(f,'Visible','on');
 
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %                         CALLBACK FUNCTIONS                         %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Callback functions automatically have access to component handles  
   % and initialized data because they are nested at a lower level
  
   function inputpsi_Callback(source,eventdata)         
        if isnan(str2double(get(source,'string'))) 
            errordlg('You must enter a numeric value','Bad Input','modal');
        else 
            mypsi = str2double(get(source,'string'));
        end        
        if ((mypsi>1)||(mypsi<0.01)) 
            errordlg('Psi must be in the range 0.01-1','Bad Input','modal');
            mypsi =max(min(1,mypsi),0.01);            
        end
        %limit the number of decimals for clarity
        mypsi = round(mypsi*100)/100;         
        set(source,'string',num2str(mypsi));        
   end

   function inputp_Callback(source,eventdata)         
        if isnan(str2double(get(source,'string'))) 
            errordlg('You must enter a numeric value','Bad Input','modal');
        else
            myp = str2double(get(source,'string'));
        end
        if ((myp>1)||(myp<0.01)) 
            errordlg('P must be in the range 0.01-1','Bad Input','modal');
            myp =max(min(1,myp),0.01);
        end
       %limit the number of decimals for clarity        
       myp = round(myp*100)/100; 
       set(source,'string',num2str(myp));        
   end
 
   function inputTS_Callback(source,eventdata)       
      if isnan(str2double(get(source,'string'))) 
          errordlg('You must enter a numeric value','Bad Input','modal');
      else
          maxTS = str2double(get(source,'string'));
      end 
      % force it to be integer
      maxTS = floor(maxTS); set(source,'string',num2str(maxTS));
   end 

   function inputvar_Callback(source,eventdata)       
      if isnan(str2double(get(source,'string'))) 
          errordlg('You must enter a numeric value','Bad Input','modal');
      else
          maxMSE = str2double(get(source,'string'));
      end 
   end 

   function inputpriorA_Callback(source,eventdata) 
    if (get(hinputpriorA,'Value') == get(hinputpriorA,'Max'))
        prior = 1; set(hinputpriorB,'Value',0);
        priorst = 'precision'; 
    else 
        set(hinputpriorA,'Value',1);     
    end
   end

   function inputpriorB_Callback(source,eventdata) 
    if (get(hinputpriorB,'Value') == get(hinputpriorB,'Max'))
        prior = 0;set(hinputpriorA,'Value',0);
        priorst = 'minimize total effort'; 
    else 
        set(hinputpriorB,'Value',1);     
    end
   end

   function inputcrit1_Callback(source,eventdata) 
    if (get(hinputcrit1,'Value') == get(hinputcrit1,'Max'))
        crit = 1;set(hinputcrit2,'Value',0);set(hinputcrit3,'Value',0);
        critst = 'psi MSE';
    else 
        set(hinputcrit1,'Value',1);     
    end
   end

   function inputcrit2_Callback(source,eventdata) 
    if (get(hinputcrit2,'Value') == get(hinputcrit2,'Max'))
        crit = 2;set(hinputcrit1,'Value',0);set(hinputcrit3,'Value',0);
        critst = 'A-optimality';
    else 
        set(hinputcrit2,'Value',1);     
    end
   end

   function inputcrit3_Callback(source,eventdata) 
    if (get(hinputcrit3,'Value') == get(hinputcrit3,'Max'))
        crit = 3;set(hinputcrit2,'Value',0);set(hinputcrit1,'Value',0);
        critst = 'D-optimality';
    else 
        set(hinputcrit3,'Value',1);     
    end
   end

   function inputnits_Callback(source,eventdata)       
      if isnan(str2double(get(source,'string')))
          errordlg('You must enter a numeric value','Bad Input','modal');
      else
          nsims = str2double(get(source,'string'));
      end       
      % force it to be integer and at least 10
      nsims = max(10,floor(nsims)); set(source,'string',num2str(nsims));
   end 

   function inputS_Callback(source,eventdata)       
      if isnan(str2double(get(source,'string'))) 
          herr = errordlg('You must enter a numeric value','Bad Input','modal');
      else
          myS = str2double(get(source,'string'));
      end 
      if (myS<1)
          errordlg('Number of sites must be larger than 1','Bad Input','modal');
          myS =max(1,myS);
      end      
      % force it to be integer
      myS = floor(myS); set(source,'string',num2str(myS));
   end 

   function inputK_Callback(source,eventdata)       
      if isnan(str2double(get(source,'string'))) 
          errordlg('You must enter a numeric value','Bad Input','modal');
      else
          myK = str2double(get(source,'string'));
      end   
      % force it to be integer
      myK = floor(myK); set(source,'string',num2str(myK));
      if (myK<=1)
            myK =max(myK,2);
            set(source,'string',num2str(myK));
            errordlg('number of replicates must be at least 2','Bad Input','modal');
      end         
   end 



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %                        MAIN PROCESSING FUNCTION                    %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   function run_Callback(source,eventdata)
       
     % prepare and clean plot and output panel
     plot(0.5,0.5,'w');
     set(gca,'Box','on','XLim',[0 1], 'YLim',[0 1],'FontSize',myfigfont,...
        'YTick',0:0.2:1,'XTick',0:0.2:1);
     ylabel('\psi','FontWeight','default','FontSize',myfigfont);
     xlabel('p','FontWeight','default','FontSize',myfigfont);
     set(hout,'string','');pause(0.1);
     numrun = numrun+1;
     tstart = tic;
        
     % write user input to auxiliary window
     disp(' '); disp(' ');disp([' RUN ',num2str(numrun),'  ',datestr(now),' - STUDY DESIGN']);
     disp(' ----------------------------------------------------------');
     disp(' -> user input');        
     disp([' psi = ',num2str(mypsi),' p = ',num2str(myp),' max TS = ',...
            num2str(maxTS),' maxMSE = ',num2str(maxMSE)]);
     disp([' criterion for design: ',critst]);
     disp([' priority for design: ',priorst]);
     disp([' ',num2str(nsims),' iterations']);        
        
     % find Koptim based on asymptotic properties      
     disp(' -> best design based on asymptotic properties');
     Kopt = tool_Koptim(mypsi,myp,crit);
     
     % find corresponding s      
     smax = floor(maxTS/Kopt);
     if (prior==1)
         s = smax;
     else
         s = ceil(tool_findS(mypsi,myp,Kopt,maxMSE,crit));
         if (s > smax) s = smax; end;  % limit s so than TS<TSmax  - CK
     end 
     disp([' K = ',num2str(Kopt),' s = ',num2str(s)]);
        
     % evaluate asymptotic properties of selected design
     [Sigma,msg] = tool_asymprec(mypsi,myp,Kopt,s);
     disp(msg);       
        
     % evaluate selected design via simulations
     disp(' -> evaluating "asymptotic" design via simulations');
     [probs,mybias_m,myvar_m,myMSE_m,pempty,msg] = tool_designsim(mypsi,myp,s,Kopt,nsims);
     crits = [myMSE_m(1,1),trace(myMSE_m),det(myMSE_m)];
     disp(msg);
               
     % compare asymptotic & real psi MSE to decide whether need sims
     if (abs(Sigma(1,1)-myMSE_m(1,1))<1e-4)       %threshold - CK
         disp(' asymptotic approx good enough');  
         do_sims=0;
     else
         disp(' -> proceeding to do simulations:');
         do_sims=1;
     end
        
     % continue design via simulations
     chosen = [Kopt,s];
     chosenMSE = myMSE_m; chosenbias = mybias_m; chosenvar = myvar_m;
     chosenpempty=pempty;     chosencrits = crits;
     tolF = 1.2;    %tolerance to decide when to break search - CK
               
     if (do_sims)
       if (prior==1)
         disp(msg);
         [chosen,chosenbias,chosenvar,chosenMSE,chosenpempty] = tool_simTSfixed(mypsi,myp,...
         maxTS,Kopt,nsims,tolF,0,chosenbias,chosenvar,chosenMSE,chosenpempty,crit);     
         chosencrits = [chosenMSE(1,1),trace(chosenMSE),det(chosenMSE)];
       else  % (prior == 2)                        
          %first check for TS identified by asymptotic approx
          TS1 = chosen(1)*chosen(2);disp([' evaluating TS ~ ',num2str(TS1)]);
          disp(msg);
          [chosen,chosenbias,chosenvar,chosenMSE,chosenpempty] = tool_simTSfixed(mypsi,myp,...
          TS1,Kopt,nsims,tolF,0,chosenbias,chosenvar,chosenMSE,chosenpempty,crit);
          chosencrits = [chosenMSE(1,1),trace(chosenMSE),det(chosenMSE)];
          
          %if no good design found try increasing effort
          if ((chosencrits(crit)>maxMSE)&&(TS1~=maxTS))  
            %check for max TS  
            TS2 = maxTS;disp([' evaluating TS ~ ',num2str(TS2)]);  
            [best,bestbias,bestvar,bestMSE,bestpempty] = tool_simTSfixed(mypsi,myp,...
            TS2,Kopt,nsims,tolF,1,-1,-1,-1,-1,crit);
            bestcrits = [bestMSE(1,1),trace(bestMSE),det(bestMSE)];
            if (bestcrits(crit)>maxMSE) docont=0;
            else docont=1; 
                 chosen=best; chosenbias=bestbias;
                 chosenvar=bestvar;chosenMSE=bestMSE;
                 chosencrits = bestcrits; chosenpempty = bestpempty;
            end;
            
            %if max TS design was good look for design with intermediate TS    
            while (((TS2-TS1)>10)&&docont)
                TSm = round((TS1+TS2)/2);disp([' evaluating TS ~ ',num2str(TSm)]);
                [best,bestbias,bestvar,bestMSE,bestpempty] = tool_simTSfixed(mypsi,myp,...
                TSm,Kopt,nsims,tolF,1,-1,-1,-1,-1,crit);
                bestcrits = [bestMSE(1,1),trace(bestMSE),det(bestMSE)];
                if (bestcrits(crit)>maxMSE) TS1 = TSm;
                else TS2 = TSm;
                     chosen=best; chosenbias=bestbias;
                     chosenvar=bestvar;chosenMSE=bestMSE;
                     chosencrits = bestcrits; chosenpempty = bestpempty;
                end
            end
          end

        end %if prior
      end %if do sims
        
        
      % evaluate design against given project targets
      mymessage2 = sprintf('');
      mymessage4 = sprintf(['\n',' (for alternatives check auxiliary window)']);
      
      %CK - if just over maxTS (if round instead of ceil)
      if ((chosencrits(crit)>maxMSE)||(chosen(1)*chosen(2)>maxTS))
          mymessage2 = sprintf([' no design found to achieve targets!','\n']); 
          mymessage4 = sprintf('');
      end      

      % display message in output panel
      mymessage = sprintf([' suggested design:','\n',' K=',...
                  num2str(chosen(1)),' replicates, s=',num2str(chosen(2)),...
                  ' sites (TS=',num2str(chosen(1)*chosen(2)),')','\n',...
                  ' psi: bias=',num2str(chosenbias(1),'%+0.4f'),' var=',...
                  num2str(chosenvar(1,1),'%0.4f'),' MSE=',num2str(chosenMSE(1,1),'%0.4f'),...
                  '\n','   p: bias=',num2str(chosenbias(2),'%+0.4f'),' var=',...
                  num2str(chosenvar(2,2),'%0.4f'),' MSE=',num2str(chosenMSE(2,2),'%0.4f'),...
                  '\n','      critA=',num2str(trace(chosenMSE),'%0.4f'),...
                  ' critD=',num2str(det(chosenMSE),'%.3e')...
                  '\n',' empty histories = ',num2str(100*chosenpempty,'%0.1f'),'%%']);                 
      mymessage3=sprintf('\n');
      set(hout,'FontName','FixedWidth','string',[mymessage3,mymessage2,mymessage,mymessage4]);

      % display message in aux window    
      disp(' ..........................................................');
      disp([mymessage2,mymessage]);
      disp(' ..........................................................');
            
      % plot selected design
      tool_plot([probs(:,5),probs(:,4),probs(:,3)],[],{'.',9});
      ylabel('\psi','FontWeight','default','FontSize',myfigfont);
      xlabel('p','FontWeight','default','FontSize',myfigfont);
      set(gca,'Box','on','XLim',[0 1], 'YLim',[0 1],'FontSize',myfigfont,'YTick',0:0.2:1,'XTick',0:0.2:1);      

      % run time
      telapsed = toc(tstart);
      melapsed = floor(telapsed/60);
      selapsed = telapsed - melapsed*60;
      disp([' total runtime: ',num2str(melapsed),' min ',num2str(selapsed,'%0.1f'),' sec']);      
        
   end 


   function run2_Callback(source,eventdata)
       
        % prepare and clean plot and output panel
        plot(0.5,0.5,'w');
        set(gca,'Box','on','XLim',[0 1], 'YLim',[0 1],'FontSize',myfigfont,'YTick',0:0.2:1,'XTick',0:0.2:1);
        ylabel('\psi','FontWeight','default','FontSize',myfigfont);
        xlabel('p','FontWeight','default','FontSize',myfigfont);
        set(hout,'string','');
        pause(0.1); numrun = numrun+1;
        tstart = tic;
        disp(' '); disp(' ');disp([' RUN ',num2str(numrun),'  ',datestr(now),' - EVALUATION of given design']);
        disp(' ----------------------------------------------------------');
        disp(' -> user input');        
        disp([' psi = ',num2str(mypsi),' p = ',num2str(myp),' K = ',...
             num2str(myK),' s = ',num2str(myS),' (TS = ',num2str(myK*myS),')']);
        disp([' ',num2str(nsims),' iterations']);
        
        % evaluate asymptotic properties of selected design
        [Sigma,msg] = tool_asymprec(mypsi,myp,myK,myS);
        disp(msg);
        
        % evaluate given design via simulation
        disp(' -> evaluating given design via simulations');
        [probs,mybias_m,myvar_m,myMSE_m,pempty,msg] = tool_designsim(mypsi,myp,myS,myK,nsims);      
        disp(msg);
        
        % display message in output panel
        mymessage = sprintf([' design:','\n',' K=',...
                  num2str(myK),' replicates, s=',num2str(myS),...
                  ' sites (TS=',num2str(myK*myS),')','\n',...
                  ' psi: bias=',num2str(mybias_m(1),'%+0.4f'),' var=',...
                  num2str(myvar_m(1,1),'%0.4f'),' MSE=',num2str(myMSE_m(1,1),'%0.4f'),...
                  '\n','   p: bias=',num2str(mybias_m(2),'%+0.4f'),' var=',...
                  num2str(myvar_m(2,2),'%0.4f'),' MSE=',num2str(myMSE_m(2,2),'%0.4f'),...
                  '\n','      critA=',num2str(trace(myMSE_m),'%0.4f'),...
                  ' critD=',num2str(det(myMSE_m),'%.3e'),...
                  '\n',' empty histories = ',num2str(100*pempty,'%0.1f'),'%%']);             
        mymessage3=sprintf('\n');
        set(hout,'FontName','FixedWidth','string',[mymessage3,mymessage]);        

        % display message in aux window        
        disp(' ..........................................................');
        disp(mymessage);
        disp(' ..........................................................');
                
        % plot selected design
        tool_plot([probs(:,5),probs(:,4),probs(:,3)],[],{'.',9});
        ylabel('\psi','FontWeight','default','FontSize',myfigfont);
        xlabel('p','FontWeight','default','FontSize',myfigfont);
        set(gca,'Box','on','XLim',[0 1],'YLim',[0 1],'FontSize',myfigfont,'YTick',0:0.2:1,'XTick',0:0.2:1);
        
        % run time        
        telapsed = toc(tstart);
        melapsed = floor(telapsed/60);
        selapsed = telapsed - melapsed*60;
        disp([' total runtime: ',num2str(melapsed),' min ',num2str(selapsed,'%0.1f'),' sec']);        
        
        
   end



end 
