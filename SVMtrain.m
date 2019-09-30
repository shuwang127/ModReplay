function [accuracy_train, accuracy_test] = SVMtrain()
% SVM training process for distinguishing the modulated replay audio and
% geniune audio. (Model is stored in ./model/SVMmodel.mat)
% Output : accuracy_train - the training accuracy for the SVM model.
%          accuracy_test - the testing accuracy for the SVM model.
% Shu Wang

%% TEST
% clear;
% close all;

%% Set ratio of the training / testing
rtrain = 0.8;

%% Constant path
data_file = './data/Matrix.mat';

%% set parameters
load(data_file);
N = size(Mgenuine, 1);
dim = size(Mgenuine, 2);

%% Generate Label and Matrix
Lgenuine = zeros(N, 1);           % genuine : 0
Lmodreplay = ones(N, 1);          % modreplay : 1
Label = [Lgenuine; Lmodreplay];
Matrix = [Mgenuine; Mmodreplay];

%% Divide training and testing set
seed = randperm(2 * N);
numtrain = ceil(rtrain * 2 * N);
Xtrain = Matrix(seed(1 : numtrain), :);
Ytrain = Label(seed(1 : numtrain), :);
Xtest = Matrix(seed(numtrain+1 : end), :);
Ytest = Label(seed(numtrain+1 : end), :);

%% Train SVM
SVMSTRUCT = svmtrain(Ytrain, Xtrain);

%% Evaluation
tic
[predict_Ytrain, acc_train, ~] = svmpredict(Ytrain, Xtrain, SVMSTRUCT);
[predict_Ytest, acc_test, ~] = svmpredict(Ytest, Xtest, SVMSTRUCT);
t = toc;
accuracy_train = acc_train(1);
accuracy_test = acc_test(1);
disp(['=============================================']);
disp(['Training Acc: ', num2str(accuracy_train), '%']);
disp(['Testing Acc: ', num2str(accuracy_test), '%']);
disp(['Total Time: ', num2str(1000*t), 'ms']);
disp(['Sample Time: ', num2str(1000*t/N), 'ms']);

%% Save the model
save ./model/SVMmodel.mat SVMSTRUCT;

end
