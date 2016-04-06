function moea_d_update

global objectives individuals generations rooms subproblem_neighbors best_so_far subproblem_neighbor rooms records

distance=zeros(individuals,individuals); //���ړI��Ԃ̌̊ԋ���

// �ߋ��̃x�X�gfitness�l�A�ړI���Ƃ�
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

// �̍X�V
// weighted sum approach
for objective_num=1:objectives
  subproblem_fitness(1,1)=subproblem_weight(1,objective_num)*Objective(1,objective_num,generation_num,sample_num);
end
for individual_num=2:individuals
  for objective_num=1:objectives
    subproblem_fitness(1,individual_num) = subproblem_fitness(1,individual_num-1) + ..
    subproblem_weight(individual_num,objective_num) * Objective(individual_num,objective_num,generation_num,sample_num);
  end
end

// �X�V
for individual_num=1:individuals
  if  records(individual_num,1,3) < subproblem_fitness(1,individual_num) // fitness�������Ȃ�����X�V
    for room_num=1:rooms
      records(individual_num,room_num,1:2)=Geno(room_num,1:2,individual_num);
    end
    records(individual_num,:,3)=subproblem_fitness(1,individual_num);
  end
end
for individual_num=1:individuals
  for room_num=1:rooms
    Geno(room_num,1:2,individual_num)=records(individual_num,room_num,1:2);
  end
end

// �ߗ׌�
for individual_num=1:individuals
  for neighbor_num=1:subproblem_neighbors // �v�f: subproblem_neighbors+1�͎��ۂ̏������ɂ͎g���Ȃ�
    if subproblem_neighbor(individual_num,neighbor_num,3) < records(individual_num,1,3) .. // fitness�������Ȃ�����X�V
    & individual_num ~= subproblem_neighbor(individual_num,neighbor_num,1) // ��r�Ώۂ��������g�̂Ƃ����O
//      subproblem_neighbor(individual_num,neighbor_num,3)=subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1)); //�X�V
      subproblem_neighbor(individual_num,neighbor_num,3)=records(individual_num,1,3);
    end
  end
end

// �P�ړI�ŉߋ��̃x�X�gfitness�l�A�ړI���Ƃ�
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

endfunction
