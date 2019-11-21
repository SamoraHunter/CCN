function [meanRTselection] = meanRTselection(indsubj)

%Function takes the trial row number as the selection, then finds the mean
%of all the participants selected. The output is a single value,
%corresponding to the mean of all of the trials in the input vector. 

load('lab4data.mat')

totalofmeans = 0

counter = 0

for i = indsubj

counter = counter +1;

a = mean(RT(i,:));

totalofmeans = totalofmeans + a;

end

meanRTselection = totalofmeans/counter