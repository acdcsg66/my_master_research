function moea_d_update

global objectives individuals generations rooms subproblem_neighbors subproblem_neighbor rooms ..
records tche_records present_objective subproblem_fitness generation_num sample_num

distance=zeros(individuals,individuals); //���ړI��Ԃ̌̊ԋ���

// �X�V
for individual_num=1:individuals
  if tche_records(individual_num,present_objective(1,individual_num)) > subproblem_fitness(1,individual_num) // fitness���Ⴍ�Ȃ�����i��Tchebycheff�͍ŏ������Ȃ̂Łj�X�V
    for room_num=1:rooms
      records(individual_num,room_num,1:2)=Geno(room_num,1:2,individual_num);
    end
    tche_records(individual_num,present_objective(1,individual_num)) = subproblem_fitness(1,individual_num);
  end
end
// fitness���ǍD�ɂȂ����̂��X�V�����i����ȊO�͓����l����������j
for individual_num=1:individuals
  for room_num=1:rooms
    Geno(room_num,1:2,individual_num)=records(individual_num,room_num,1:2);
  end
end

distance=zeros(individuals,individuals);

// ���ړI��Ԃ̌̂ǂ����̋��������߂�
for individual_num=1:individuals
  for comparison_num=1:individuals
    for objective_num=1:objectives
      distance(individual_num,comparison_num)=distance(individual_num,comparison_num)..
      +(Objective(individual_num,objective_num,generation_num,sample_num)-Objective(comparison_num,objective_num,generation_num,sample_num))^2;
    end
    distance(individual_num,comparison_num)=sqrt(distance(individual_num,comparison_num));
  end
end

// �ߗ׌�
for individual_num=1:individuals
  for comparison_num=1:individuals
    for neighbor_num=subproblem_neighbors:(-1):1 // �v�f: subproblem_neighbors+1�͎��ۂ̏������ɂ͎g���Ȃ�
      if subproblem_neighbor(individual_num,neighbor_num,2) > distance(individual_num,comparison_num) .. // ��苗���̋߂��̂𔭌�������
      & individual_num ~= comparison_num // ��r�Ώۂ��������g�̂Ƃ����O
        subproblem_neighbor(individual_num,neighbor_num+1,1)=subproblem_neighbor(individual_num,neighbor_num,1); // ���݌̂��猩�Ĕ�r�̂�苗���������̂����炵�Ă�����
        subproblem_neighbor(individual_num,neighbor_num+1,2)=subproblem_neighbor(individual_num,neighbor_num,2);
        subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //�̔ԍ����
        subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //�������
      //elseif subproblem_neighbor(individual_num,neighbor_num,2) == 0 .. //�܂��������Ă��Ȃ��Ȃ炻�̂܂ܑ��
      //& individual_num ~= comparison_num // ��r�Ώۂ��������g�̂Ƃ����O
      //  subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //�̔ԍ����
      //  subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //�������
      //  pause
      end
    end
  end
end
// �ߗ׌̂�fitness����
for individual_num=1:individuals
  for neighbor_num=1:subproblem_neighbors
    subproblem_neighbor(individual_num,neighbor_num,3)=subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1));
  end
end
//for individual_num=1:individuals
//  for neighbor_num=1:subproblem_neighbors // �v�f: subproblem_neighbors+1�͎��ۂ̏������ɂ͎g���Ȃ�
//    if subproblem_neighbor(individual_num,neighbor_num,3) < subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1))
//    //if subproblem_neighbor(individual_num,neighbor_num,3) < records(subproblem_neighbor(individual_num,neighbor_num,1),1,3) // fitness�������Ȃ�����X�V
//    //& individual_num ~= subproblem_neighbor(individual_num,neighbor_num,1) // ��r�Ώۂ��������g�̂Ƃ����O
//      subproblem_neighbor(individual_num,neighbor_num,3)=subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1)); //�X�V
//      //subproblem_neighbor(individual_num,neighbor_num,3)=records(subproblem_neighbor(individual_num,neighbor_num,1),1,3);
//    end
//  end
//end

endfunction
