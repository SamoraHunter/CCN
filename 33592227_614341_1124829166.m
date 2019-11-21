function [output] = week5analysis(pwd)
%3359222701
%Load files
files = dir(pwd);
for f = 3:size(files)
tempfile=load(files(f).name);
%extract id variable
id=(files(f).name(4:end));
%remove first 10 practice trials
tempfile([1,2,3,4,5,6,7,8,9,10],:) = [];
%correct percentage condition one

correctCond1 = ((sum(tempfile([1:40],2)))/40)*100;
%correct percentage condition two
correctCond2 = ((sum(tempfile([41:end],2)))/50)*100;
%Mean of correct RT's from condition 1
Cond1mean = mean(tempfile(tempfile([1:40],2)==1,3));
%Mean of correct RT's from condition 2
Cond2mean = (tempfile(tempfile([41:end],2)==1,3));
%Compute difference of RT between condition 1 and 2
DifferenceRT = Cond1mean - Cond2mean;
%Compute difference of percentage correct conditions 1 and 2
DifferenceCorrect = correctCond1 - correctCond2;
%save variables as output
output(f,1:3) = [id DifferenceCorrect DifferenceRT]



end

%disp(output)

save ('output', 'output', '-ASCII')
