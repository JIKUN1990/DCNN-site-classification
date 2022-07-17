% Code by Kun Ji at 2022/07/12
%Purpose: Classification examples using trained DCNN classifiers in Ji et al（2022）
% Please refer to“Site classification as a deep-learning based image recognition task”for further detail
% If have any questions,please contact with authors(jikun@iem.ac.cn).
clc
clear
%% Input dataset
load('Trainingdata-Japan-1649sites-Zhu2021.mat') % Sites in Japan （which was used as training dataset）
%load('Testdata-EU-217sites.mat') % Sites in Europe
labels=NEHRP_site_class;
samplesize=length(labels);
images = double(reshape(HVSR_Curve_images(1:samplesize,:)',64,64,samplesize));
X_test= reshape(images, [64,64,1,length(images)]);
Y_test = categorical(labels);
%% Load three trained CNN classifiers
load CNN_classifier1&2&3_for_curves&slope.mat
%%Classifier 1
[testLabel,score] = classify(net_cnn,X_test);
precision = sum(testLabel==Y_test)/numel(testLabel);
a=double(Y_test)
b=double(testLabel)
confusion1=COF(a,b)
%%classifier 2
for i=1:samplesize
    if double(testLabel(i))==1 && double(Y_test(i))==1
        test_picklabel(i)=1;
    elseif double(testLabel(i))==2 && double(Y_test(i))==1
        test_picklabel(i)=1;
    elseif double(testLabel(i))==1 && double(Y_test(i))==2
        test_picklabel(i)=1;
    elseif double(testLabel(i))==2 && double(Y_test(i))==2
        test_picklabel(i)=1;
    else
        test_picklabel(i)=999;
    end
end
X_test_pick1=X_test(:,:,:,find(test_picklabel==1));
Y_test_pick1=Y_test(find(test_picklabel==1));
[testLabel1,score] = classify(net_cnn_pick,X_test_pick1);
% precision = sum(testLabel1==Y_test_pick1)/numel(testLabel1);
a=double(Y_test_pick1)
b=double(testLabel1)
confusion2=COF(a,b)
%%classifier 3
for i=1:samplesize
    if double(testLabel(i))==3 && double(Y_test(i))==3
        test_picklabel(i)=1
    elseif double(testLabel(i))==4 && double(Y_test(i))==3
        test_picklabel(i)=1
    elseif double(testLabel(i))==4 && double(Y_test(i))==4
        test_picklabel(i)=1
    elseif double(testLabel(i))==3 && double(Y_test(i))==4
        test_picklabel(i)=1
    else
        test_picklabel(i)=999
    end
end
X_test_pick2=X_test(:,:,:,find(test_picklabel==1));
Y_test_pick2=Y_test(find(test_picklabel==1));
[testLabel2,score] = classify(net_cnn_pick2,X_test_pick2);
a=double(Y_test_pick2)
b=double(testLabel2)
confusion3=COF(a,b)
%% Confusion matrix
confusion_t=confusion1;
confusion_t(1,1)=confusion2(1,1);
confusion_t(1,2)=confusion2(1,2);
confusion_t(2,1)=confusion2(2,1);
confusion_t(2,2)=confusion2(2,2);
confusion_t(3,3)=confusion3(3,3);
confusion_t(3,4)=confusion3(3,4);
confusion_t(4,3)=confusion3(4,3);
confusion_t(4,4)=confusion3(4,4);
%% Plot
aa={'E';'D';'C';'A+B'}
cm=confusionchart(confusion_t(1:4,1:4),categorical(aa))
cm.FontSize=15
cm.FontName='TimesNewroman'
cm.XLabel='predicted site class'
cm.YLabel='true site class'
cm.Title='Test using multiple classifiers'
cm.ColumnSummary = 'column-normalized'
cm.RowSummary = 'row-normalized'
