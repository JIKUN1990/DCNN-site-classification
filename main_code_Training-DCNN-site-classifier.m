% Code by Kun Ji at 2022/07/12

%Purpose: Construct and train the DCNN models as proposed in Ji et al（2022）
% Please refer to “Site classification as a deep-learning based image recognition task”
% If have any questions, please contact with authors.(jikun@iem.ac.cn)
% Please make sure that the deeplearning toolbox had been installed on your Matlab before running the code.
clc
clear
%% Training data and validation data
load Trainingdata-Japan-1649sites-Zhu2021.mat % input image with 64*64 pixels
% images = double(reshape(HVSR_Curve_images(1:1404,:)',64,64,1404));
labels=NEHRP_site_class % 1:E site calss; 2:D site class; 3:C site class; 4:A+B site class; 
% for i=1:1:32
%     subplot(4,8,i);
%     imshow(uint8(images(:,:,i))*255)
% end
number_folds=5; % number of folds;
inputdata=HVSR_Curve_images; % input image
k=1; % ranging from 1 to the total number of folds;
[X_train,Y_train,X_val,Y_val]=cross_validation_stratified_sampling(number_folds,inputdata,labels,k)
%% DCNN model parameters
layers = [...
    imageInputLayer([64,64,1]);
    convolution2dLayer(1,4,'padding','same');
    batchNormalizationLayer();
    reluLayer()
    
    convolution2dLayer(3,4,'padding','same');
    batchNormalizationLayer();
    reluLayer()
    maxPooling2dLayer(2,'Stride',2);
    
    convolution2dLayer(3,8,'padding','same');
    batchNormalizationLayer();
    reluLayer()
    maxPooling2dLayer(2,'Stride',2);
    %
    convolution2dLayer(3,16,'padding','same');
    batchNormalizationLayer();
    reluLayer()
    maxPooling2dLayer(2,'Stride',2);
    
    convolution2dLayer(3,32,'padding','same');
    batchNormalizationLayer();
    reluLayer()
    maxPooling2dLayer(2,'Stride',2);
    
    
    dropoutLayer(0.5,"Name","dropout")
    fullyConnectedLayer(4);
    
    softmaxLayer();
    classificationLayer(),...
    ];

options = trainingOptions('sgdm',...
    'MiniBatchSize',50, ...
    'MaxEpochs',50,...
    'ValidationData',{X_val,Y_val},...
    'Verbose',true, ...
    'ValidationFrequency',30,...
    'Shuffle','every-epoch', ...
    'LearnRateSchedule','piecewise', ...
    'InitialLearnRate',1e-2,...
    'LearnRateDropFactor',0.2, ...
    'LearnRateDropPeriod',5, ...
    'validationPatience',10,...
    'Plots','training-progress');

net_cnn = trainNetwork(X_train,Y_train,layers,options);

%% Confusion Matrix for training dataset
subplot(1,2,1)
[trainLabel score]= classify(net_cnn,X_train);
precision = sum(testLabel==Y_train)/numel(trainLabel);
a=double(Y_train)
b=double(trainLabel)
confusion=COF(a,b)
disp(['Accuracy rate(%)=',num2str(precision*100),'%'])
aa={'E';'D';'C';'A+B'}
cm=confusionchart(confusion(1:4,1:4),categorical(aa))
cm.FontSize=15
cm.FontName='TimesNewroman'
cm.XLabel='predicted site class'
cm.YLabel='true site class'
cm.Title='training dataset'
cm.ColumnSummary = 'column-normalized'
cm.RowSummary = 'row-normalized'

subplot(1,2,2)
%%Confusion Matrix for training dataset
[validationLabel score]= classify(net_cnn,X_val);
precision = sum(validationLabel==Y_val)/numel(validationLabel);
a=double(Y_val)
b=double(validationLabel)
confusion=COF(a,b)
disp(['Accuracy rate(%)=',num2str(precision*100),'%'])
aa={'E';'D';'C';'A+B'}
cm=confusionchart(confusion(1:4,1:4),categorical(aa))
cm.FontSize=15
cm.FontName='TimesNewroman'
cm.XLabel='predicted site class'
cm.YLabel='true site class' 
cm.Title='validtaion dataset'
cm.ColumnSummary = 'column-normalized'
cm.RowSummary = 'row-normalized'


