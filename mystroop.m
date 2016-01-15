% A simple implementation of the stroop task  
% Creates a GUI with a colored text at the top and a number of buttons. Based on the
% colours given as input buttons are generated at the bottom with those
% names.
%
%
% Author:  AlexZ82
% Date:  15/1/2016
function mystroop(num_of_trials, the_colours,subj_num)
% MYSTROOP  runs a simple stroop task experiment
%   the_colours = {'yellow','magenta','cyan','red','green','blue','white','black'}
%   MYSTROOP(100, the_colours,1) will run 100 trials using the above
%   colours and save the results in a csv named subject1.csv

possible_colours = length(the_colours);
rand_text = randint(1,num_of_trials,[1,possible_colours])%generate the text of the trials
rand_c = randint(1,num_of_trials,[1,possible_colours])%generate the colour or the trials
subject_choices = NaN(1,num_of_trials)%will be used to store the user's responses
S.bsize = 80;
S.width = ((S.bsize+20)*possible_colours)-20;
S.position=100;
S.colour = randperm(possible_colours,1);
S.CNT = 1;  % This keeps track of the trial.
S.fh = figure('units','pixels',...
              'position',[500 500 S.width+20 500],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Select the button the matches the colour of the word: ',...
              'resize','off');
S.pb(1) = uicontrol('style','text',...
                    'units','pixels',...
                    'position',[10 60 S.width 300],...
                    'fontsize',40,...
                    'string',the_colours{rand_text(S.CNT)},...
                    'Foregroundcolor',the_colours{rand_c(S.CNT)});
for ii = 1:(possible_colours)
    where = (S.position*(ii-1))+10;
    S.pb(ii+1) = uicontrol('style','push',...
                    'units','pixels',...
                    'position',[where 10 S.bsize 30],...
                    'fonts',14,...
                    'str',the_colours{ii});

end
set(S.pb(2:(possible_colours+1)),{'callback'},{{@pb1_call,S}})  % Set callbacks.

         
    function [] = pb1_call(varargin)  
        [h,S] = varargin{[1,3]};
        if  S.CNT < num_of_trials +1           
            %I = find(h == S.pb(:))
            l = get(gcbo,'string');    
            col = strmatch(l, the_colours);
            subject_choices(S.CNT) = col           
            S.CNT = S.CNT + 1;  % The trial counter.            
            if  S.CNT > num_of_trials 
                set(S.pb(1),{'string','Foregroundcolor'},{'Finished','black'}); 
                set(S.pb(2:(possible_colours+1)),{'enable'},{'off'}); 
                saveres(subject_choices,rand_c,rand_text,subj_num);                             
            else
                set(S.pb(1),{'string','Foregroundcolor'},{the_colours{rand_text(S.CNT)},the_colours{rand_c(S.CNT)}});               
                set(S.pb(2:(possible_colours+1)),{'callback'},{{@pb1_call,S}});
            end
         end
    end

    function saveres(subject_choices,rand_c,rand_text,subj_num)
    % SAVERES  saves results to a scv.
    %   SUBJ_NUM is the number of the subject taking the test
    %   RESULTS = SAVERES(C,Col,Text,3) saves results to subject3.csv with three collums responses=C, color=COL and text=Text .
    
        res = [subject_choices;rand_c;rand_text]'                
        filename = ['subject',int2str(subj_num),'.csv'];
        fid = fopen(filename, 'w');
        fprintf(fid, 'responses,color,text\n');
        fclose(fid);
        dlmwrite(filename, res, '-append');    
    end

end
