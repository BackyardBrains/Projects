function [classes, intervals] = preprocessing(data, f1) 
fc = 0.5;
fs = 1666;

%______Normalization____________________________________________________

%for k=1:5
 %   data(1:end, k) = (data(1:end, k) - mean(data(1:end, k)))/std(data(1:end, k));
%end

%______Filtering____________________________________________________

%[b,a] = butter(3,fc/(fs/2),'high');
% data(1:end, 1) = filter(b,a,data(1:end, 1));
% data(1:end, 1) = filter(b,a,data(1:end, 2));
% data(1:end, 1) = filter(b,a,data(1:end, 3));
% data(1:end, 1) = filter(b,a,data(1:end, 4));
% data(1:end, 1) = filter(b,a,data(1:end, 5));

%f1 = diff(data(1:end, 6))<0.5*min(diff(data(1:end, 6)));

%plot();
inside = 0;
%4500
%we need to high pass filter the signal before at 0.1Hz or something like
%that
%and we need to remove average of each interval before we sum them
%also we need to divide by number of intervals in order to get average,
%right now we have just sum, which is proportional but not the same thing
result = zeros(1,length(f1));

indexOfLast = 0;
for i=1:length(f1)
    if(inside>0)
        if(f1(i-1)==1 && f1(i)==0)
            result(indexOfLast) = result(indexOfLast) +1;
        end
        inside = inside +1;
        if(inside > 3000)
            inside = 0;
        end
    end
    if(f1(i)==1)
        
        if(inside == 0)
            inside = inside +1;
            result(i) = 1;
            indexOfLast = i;
        end
    end
    
end
result = result - 2;
result(result==-2) = 0;
allResults = [];

intervals = [];
classes = [];
for(k=1:4)
        indOf1 = find(result==k);
        for i=1:length(indOf1)
            if(((indOf1(i)-100)>1) && indOf1(i)+500<length(f1))
                temp = data(indOf1(i)-100:indOf1(i)+500,1:5);
                tempOneLongVectorThatContainsAllChannels = temp(:);
                intervals = [intervals tempOneLongVectorThatContainsAllChannels];
                classes = [classes k];
                
                
            end
        
        end

end
     
end
