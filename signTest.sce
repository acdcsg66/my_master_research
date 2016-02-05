//•„†ŒŸ’è

//Object“Ç‚Ýž‚Ý
//load('Objective.dat','Objective');
//Objective1=Objective;
//load('Objective.dat','Objective');
//Objective2=Objective;

Count=zeros(3,10,4); //(plus,minus,n=plus+minus), genge, obj
for generation_num=5:5:50
  for objective_num=1:4
    for sample_num=1:50
      meanObj1=mean(Objective1(:,objective_num,generation_num,sample_num));
      meanObj2=mean(Objective2(:,objective_num,generation_num,sample_num));
      if (meanObj1-meanObj2)>0
        Count(1,generation_num/5,objective_num)=Count(1,generation_num/5,objective_num)+1;
      elseif (meanObj1-meanObj2)<0
        Count(2,generation_num/5,objective_num)=Count(2,generation_num/5,objective_num)+1;
      end
    end
  end
end
Count(3,:,:)=Count(1,:,:)+Count(2,:,:);
Count