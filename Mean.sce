generation_num=25;
Mean=zeros(4,20);
for objective_num=1:4
  for sample_num=1:50
    Mean(objective_num,sample_num)=mean(Objective(:,objective_num,generation_num,sample_num));
  end
end
Mean'

//('Objective.dat',Objective)