function [ out ] = plotSVMData( data )

out = [];

coeff = pca(data.trainingInputs);
reducedDimension = coeff(:,1:3);
reducedData = data.trainingInputs * reducedDimension;


indexes = data.trainingOutputs==1;
plot(reducedData(indexes,1),reducedData(indexes,3),'ro')
hold on;
indexes = data.trainingOutputs~=1;
plot(reducedData(indexes,1),reducedData(indexes,3),'go')



end