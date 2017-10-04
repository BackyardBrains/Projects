function [ score ] = getScoreFromSVM( svm, erp )
%     sv = svm.ClassificationSVM.SupportVectors;
%     alphaHat = svm.ClassificationSVM.Alpha;
%     bias = svm.ClassificationSVM.Bias;
%     kfun = svm.ClassificationSVM.KernelParameters.Function;
%     kfunargs = svm.ClassificationSVM.KernelParameters.Scale;
%     %score = kfun(sv,erp,kfunargs{:})'*alphaHat(:) + bias;
% 

    %Alpha coef.
    alpha = svm.ClassificationSVM.Alpha;
    %SupportVectors;
    sv = svm.ClassificationSVM.SupportVectors;
    %Bias.
    b = svm.ClassificationSVM.Bias;
    %Scale set to 'auto' into fitcsvm function.
    s = svm.ClassificationSVM.KernelParameters.Scale;

    w = alpha'*sv; %Is correct matrix multiplication?
    b = -b; %Is correct multiply Bias by -1?
    x = x/s; % Is correct divided my instance by scale of SVM?


    score = erp'*alphaHat(:) + bias;
end

