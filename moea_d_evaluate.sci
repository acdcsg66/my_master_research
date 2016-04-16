function moea_d_evaluate

global objectives individuals subproblem_fitness subproblem_weight best_so_far present_objective

distance=zeros(individuals,individuals); //���ړI��Ԃ̌̊ԋ���
Pair=zeros(children,2);

//Tchebycheff
//weighted sum
//subproblem_fitness=zeros(1,individuals);
//for individual_num=1:individuals
//  for objective_num=1:objectives
//    subproblem_fitness(1,individual_num) = subproblem_fitness(1,individual_num) + ..
//    subproblem_weight(individual_num,objective_num) * Objective(individual_num,objective_num,generation_num,sample_num);
//  end
//end
// �P�ړI�ŉߋ��̃x�X�gfitness�l�i�ړI���ƂɁjTchebycheff�p //debug: max()�̎g�����킩��Ȃ��̂Ń��[�v
for individual_num=1:individuals
  for objective_num=1:objectives
    if best_so_far(1,individual_num) < Objective(individual_num,objective_num,generation_num,sample_num) // �E�ӂ̍ő�l����
      best_so_far(1,individual_num) = Objective(individual_num,objective_num,generation_num,sample_num); //fitness
    end
  end
end
///Tchebycheff debug: max()�̎g�����킩��Ȃ��̂Ń��[�v
subproblem_fitness(1,1:individuals)=0;
for individual_num=1:individuals
  for objective_num=1:objectives
    if subproblem_fitness(1,individual_num) < subproblem_weight(individual_num,objective_num) * ..
    abs(Objective(individual_num,objective_num,generation_num,sample_num) - best_so_far(1,individual_num))
      subproblem_fitness(1,individual_num) = subproblem_weight(individual_num,objective_num) * .. //�E�ӂ��ő�l�ɂȂ�ړI���œK������
      abs(Objective(individual_num,objective_num,generation_num,sample_num) - best_so_far(1,individual_num)); 
      present_objective(1,individual_num) = objective_num; //�œK������ړI�ԍ�
    end
  end
end



endfunction
