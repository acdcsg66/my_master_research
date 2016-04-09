function moea_d_evaluate

global objectives individuals subproblem_fitness subproblem_weight

distance=zeros(individuals,individuals); //���ړI��Ԃ̌̊ԋ���
Pair=zeros(children,2);

// �P�ړI�ŉߋ��̃x�X�gfitness�l�i�ړI���ƂɁjTchebycheff�p
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

// weight_sum or Tchebycheff�I��
//weighted sum
subproblem_fitness=zeros(1,individuals);
for individual_num=1:individuals
  for objective_num=1:objectives
    subproblem_fitness(1,individual_num) = subproblem_fitness(1,individual_num) + ..
    subproblem_weight(individual_num,objective_num) * Objective(individual_num,objective_num,generation_num,sample_num);
  end
end
///Tchebycheff
//���ꂩ��쐬

endfunction
