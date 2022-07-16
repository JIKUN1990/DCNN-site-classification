function[X_train,Y_train,X_val,Y_val]=cross_validation_stratified_sampling(number_folds,inputdata,labels,k)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Purpose: To automatically seperate the whole dataset into validation and
%training folds


scala = 1/number_folds;
for i=1:length(unique(labels))
    class_index= find(labels==i);
    indexa{i}=randperm(length(class_index));
end


train_x=[];
train_y=[];
test_x=[];
test_y=[];
for label=1:length(unique(labels))
    index=indexa{label};
    class_index_s = find(labels==label);
    half = int32(length(class_index_s)*scala);
    if k<number_folds
        test = class_index_s(index((k-1)*half+1:k*half)); 
    else
        test = class_index_s(index((k-1)*half+1:end));
    end
    train = setdiff(class_index_s,test);   
    test_x = [test_x;inputdata(test,1:end)];
    test_y = [test_y;labels(test)];
    train_x = [train_x;inputdata(train,1:end)];
    train_y = [train_y;labels(train)];
end

images = double(reshape(train_x(1:length(train_y),:)',64,64,length(train_y)));
X_train= reshape(images, [64,64,1,length(images)]);
Y_train = categorical(train_y);
images=[];
images = double(reshape(test_x(1:length(test_y),:)',64,64,length(test_y)));
X_val= reshape(images, [64,64,1,length(images)]);
Y_val = categorical(test_y);
end