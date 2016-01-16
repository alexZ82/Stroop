% Process results from running the stroop task across subject 
% Prints an .eps file with boxplots from bootstraping the results
%
% Author:  AlexZ82
% Date:  16/1/2016
function [matchColor, matchText] = processStroopfilesI(number_of_files)
% PROCESSSTROOPFILESI  processes the results from running the stroop file.
% Assumes that the results are saved in the same folder and are named
% subject1.csv - subjectX.csv where X=number_of_files.
% Returns 
%   matchColor= a matrix with the accuracies of the subjects to the
%   color of the world (correct hit)
%   matchText= a matrix with the accuracies of the subjects to the text of
%   the world (miss)


    filename = 'subject'
    matchColor = NaN(1, number_of_files)
    matchText = NaN(1, number_of_files)
    for i = 1:number_of_files
        thename = [filename, int2str(i), '.csv']
        res = csvread(thename,1,0)
        matchColor(i) = sum(res(:,1) ==res(:,2))/length(res)
        matchText(i) = sum(res(:,1)==res(:,3)&res(:,3)~=res(:,2))/length(res)
    end
       
    ci_matchColor =  bootstrp(1000,@mean,matchColor);
    ci_matchText =  bootstrp(1000,@mean,matchText);    
    boxplot([ci_matchColor,ci_matchText],'notch','on','labels',{'match Color','match Text'})   
    title('Results')
    print(gcf,'-depsc2','stroopStudy.eps')
    set(gcf,'renderer','painters')
end