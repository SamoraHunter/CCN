function [meanRTthresholded] = meanRTthresholded(indsubj,RTtrh)

%Function takes the input of the participants we want and a threshold value

%Function computes the mean returning one value representing the mean of
%all trials from participants we are interested in which meet the
%thresholding criteria.
%The instruction was not clear if this is the desired result, or whether
%several means, one for each participant is required. 


load('lab4data.mat')

counter = 0

totaltotalRT = 0

for i = indsubj

totalunderthreshold = 0;

counterforthreshold = 0;

a = RT(i,:);

for j = 1:10

b = a(j);

if b < RTtrh

totalunderthreshold = totalunderthreshold + b;

counterforthreshold = counterforthreshold + 1;

else

end

end

totalunderthreshold = totalunderthreshold/counterforthreshold;

%meanforthresholded = totalunderthreshold/counter;

totaltotalRT = totaltotalRT + totalunderthreshold;

counter = counter +1;

end

meanRTthresholded = totaltotalRT / counter

end