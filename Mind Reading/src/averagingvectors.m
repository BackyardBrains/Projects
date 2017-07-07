
%________Averaging vectors_______________________________________________

function [classesAveraged, averaged] = averagingvectors(classes, intervals)
averaged = [];
classesAveraged = [];
howManyToaverage  = 5;
numberOfVectors = round(size(intervals,2)/howManyToaverage);
indexOfStart = 1;
for i=1:numberOfVectors
    if((indexOfStart+(howManyToaverage-1))<= length(classes))
        if(classes(indexOfStart)==classes(indexOfStart+(howManyToaverage-1)))

            averaged = [averaged mean(intervals(:,indexOfStart:indexOfStart+(howManyToaverage-1)),2)];
            classesAveraged = [classesAveraged classes(indexOfStart)];

        end
     indexOfStart = indexOfStart+howManyToaverage;
    end
end







