function [confusion] =COF(a,b)
confusion(1,1)=length(find(a==1 & b==1))
confusion(1,2)=length(find(a==1 & b==2))
confusion(1,3)=length(find(a==1 & b==3))
confusion(1,4)=length(find(a==1 & b==4))
confusion(2,1)=length(find(a==2 & b==1))
confusion(2,2)=length(find(a==2 & b==2))
confusion(2,3)=length(find(a==2 & b==3))
confusion(2,4)=length(find(a==2 & b==4))
confusion(3,1)=length(find(a==3 & b==1))
confusion(3,2)=length(find(a==3 & b==2))
confusion(3,3)=length(find(a==3 & b==3))
confusion(3,4)=length(find(a==3 & b==4))
confusion(4,1)=length(find(a==4 & b==1))
confusion(4,2)=length(find(a==4 & b==2))
confusion(4,3)=length(find(a==4 & b==3))
confusion(4,4)=length(find(a==4 & b==4))
confusion(1,5)=confusion(1,1)/sum(confusion(1,:))*100
confusion(2,5)=confusion(2,2)/sum(confusion(2,:))*100
confusion(3,5)=confusion(3,3)/sum(confusion(3,:))*100
confusion(4,5)=confusion(4,4)/sum(confusion(4,:))*100
confusion(5,1)=confusion(1,1)/sum(confusion(:,1))*100
confusion(5,2)=confusion(2,2)/sum(confusion(:,2))*100
confusion(5,3)=confusion(3,3)/sum(confusion(:,3))*100
confusion(5,4)=confusion(4,4)/sum(confusion(:,4))*100