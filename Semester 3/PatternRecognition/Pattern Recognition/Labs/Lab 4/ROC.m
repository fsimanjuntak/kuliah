function [fa,h]=ROC(mean1, mean2,x)
%False alarm is 1 minus the cumulative integral up to the x* point of the
%first curve
fa=1-normcdf(x,mean1,2);

%Hit is 1 minus the cumulative integral up to the x* point of the second
%curve
h=1-normcdf(x,mean2,2);
end