function moea_d_update

global objectives individuals generations rooms subproblem_neighbors best_so_far subproblem_neighbor

distance=zeros(individuals,individuals); //���ړI��Ԃ̌̊ԋ���

// �ߋ��̃x�X�gfitness�l�A�ړI���Ƃ�
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

// �ߗ׌�
for individual_num=1:individuals
  for neighbor_num=1:subproblem_neighbors // �v�f: subproblem_neighbors+1�͎��ۂ̏������ɂ͎g���Ȃ�
    if subproblem_neighbor(individual_num,neighbor_num,3) < subproblem_fitness(1,individual_num) .. // fitness�������Ȃ�����X�V
    & individual_num ~= subproblem_neighbor(individual_num,neighbor_num,1) // ��r�Ώۂ��������g�̂Ƃ����O
      subproblem_neighbor(individual_num,neighbor_num,3)=subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1)); //�X�V
    end
  end
end

// �P�ړI�ŉߋ��̃x�X�gfitness�l�A�ړI���Ƃ�
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

endfunction
