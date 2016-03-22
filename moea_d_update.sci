function moea_d_update

global objectives individuals generations rooms subproblem_neighbors best_so_far subproblem_neighbor

distance=zeros(individuals,individuals); //���ړI��Ԃ̌̊ԋ���

// �ߋ��̃x�X�gfitness�l�A�ړI���Ƃ�
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

// ���ړI��Ԃ̌̊ԋ��������߂�
for individual_num=1:individuals
  for comparison_num=1:individuals
    for objective_num=1:objectives
      distance(individual_num,comparison_num)=distance(individual_num,comparison_num)+(Objective(individual_num,objective_num,generation_num,sample_num)-Objective(comparison_num,objective_num,generation_num,sample_num))^2;
    end
    distance(individual_num,comparison_num)=sqrt(distance(individual_num,comparison_num));
  end
end
// �ߗ׌� debug: �[���̗�O����
subproblem_neighbor(:,:,2)=10000 //�K���ɑ傫�Ȑ��ŏ��������Ă���
subproblem_neighbor(:,1,2)=0 //���߂̗v�f����0
for individual_num=1:individuals
  for comparison_num=1:individuals
    for neighbor_num=subproblem_neighbors:(-1):1 // �v�f: subproblem_neighbors+1�͎��ۂ̏������ɂ͎g���Ȃ�
      if subproblem_neighbor(individual_num,neighbor_num,2) > distance(individual_num,comparison_num) .. // ��苗���̋߂��̂𔭌�������
      & individual_num ~= comparison_num // ��r�Ώۂ��������g�̂Ƃ����O
        subproblem_neighbor(individual_num,neighbor_num+1,1)=subproblem_neighbor(individual_num,neighbor_num,1); // ���݌̂��猩�Ĕ�r�̂�苗���������̂����炵�Ă�����
        subproblem_neighbor(individual_num,neighbor_num+1,2)=subproblem_neighbor(individual_num,neighbor_num,2);
        subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //�̔ԍ����
        subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //�������
      elseif subproblem_neighbor(individual_num,neighbor_num,1) == 0 .. //�܂��������Ă��Ȃ��Ȃ炻�̂܂ܑ��
      & individual_num ~= comparison_num // ��r�Ώۂ��������g�̂Ƃ����O
        subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //�̔ԍ����
        subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //�������
      end
    end
  end
end

// �P�ړI�ŉߋ��̃x�X�gfitness�l�A�ړI���Ƃ�
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

endfunction
