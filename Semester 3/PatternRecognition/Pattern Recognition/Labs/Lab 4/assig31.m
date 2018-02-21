function assig31()

load lab3_1.mat

hits = 0;
false_alarm = 0;

%Count how many correct hits and false alarms were generated
for index = 1:200
    outcome = outcomes(index, :);
    
    hits = hits + isequal([1,1], outcome);
    false_alarm = false_alarm + isequal([0,1], outcome);
end

%We divide the count by the total amount of observations to have the actual
%probability of ocurrence
hit_rate = hits/200
false_alarm_rate = false_alarm/200

% We used the same mean1 and sigma from exercise one
mean1=5;
mean2=8.09;
sigma=2;
    
index=1;
for x=(mean1-3*sigma):0.1:(mean2+3*sigma)
    [array(index,1),array(index,2)]=ROC(mean1,mean2,x);
    index=index+1;    
end

plot(array(:,1),array(:,2),'Displayname','ROC curve (d''=3)');
title('ROC curve for a given (fa,h) value, d''=1.545')
xlabel('False alarm (fa)'), ylabel('Hit (h)');
    axis on, axis normal
hold on
plot(false_alarm_rate, hit_rate,'*');  


hold off;
end


    
   