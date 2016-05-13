function moea_d_initialize

global objectives individuals rooms subproblem_fitness subproblem_weight subproblem_neighbors Pair children ..
generations rooms subproblem_neighbors subproblem_neighbor records weight weights

weight(:,:)=0; //MOEA/D�Ŏg���d��
subproblem_neighbor(:,:,:)=0; //�e�̂͋ߗׂ̌̂����������q�̂𐶐��Dneighbor+1�̓A���S���Y���̓s���D3��1(�̔ԍ��W�j��2�i�����j�C3�i�]���l�j
subproblem_weight(:,:)=0; //���ꂼ��̌̂�����fitness�ւ̏d�݃x�N�g���D���s���̏��߂Ɉ�x������������Œ�
subproblem_fitness(1,:)=0; //�̂��ƂɒP�ړI���C�������ꂽ�ړI�֐��D�K���ɑ傫�Ȑ��ŏ�����
records(:,:,:)=0; //���ꂼ��̌̂�fitness���ǍD�ɂȂ��������ׂ�

//// MOEA/D�ŗp����d�݃x�N�g�������� ���݂͒P���Ɉ�l���z�̗�������d�݌���i�̂��ƂɁC�S�ړI�̑��a��1�j //ToDo: �{���͂����Ƃ�������Ƃ�����@�ŏd�݂Â�
//for individual_num=1:individuals
//  budget=1;
//  last=1;
//  for objective_num=1:objectives
//    budget=budget*rand();
//    subproblem_weight(individual_num,objective_num)=last-budget;
//    last=budget;
//  end
//end

// MOEA/D�ŗp����d�݃x�N�g�������� ���݂͒P���Ɉ�l���z�̗�������d�݌���i�̂��ƂɁC�S�ړI�̑��a��1�j
for individual_num=1:individuals
  for weight_num=1:weights
    weight(individual_num,weight_num)=(weight_num/sum(1:weights));
  end
  objective_num=1;
  while objective_num<=objectives
    //rand('seed',getdate('s'))
    rand_num=rand();
    if weight(individual_num,(int(rand_num*weights)+1)) ~= 0
      subproblem_weight(individual_num,objective_num)=weight(individual_num,(int(rand_num*weights)+1));
      weight(individual_num,(int(rand_num*weights)+1))=0;
      objective_num=objective_num+1;
    end
  end
end
// weighted sum approach
//for individual_num=1:individuals
//  subproblem_fitness(1,individual_num)=subproblem_weight(individual_num,1)*Objective(individual_num,1,generation_num,sample_num);
//end
//for individual_num=1:individuals
//  for objective_num=2:objectives
//    subproblem_fitness(1,individual_num) = subproblem_fitness(1,individual_num-1) + ..
//    subproblem_weight(individual_num,objective_num) * Objective(individual_num,objective_num,generation_num,sample_num);
//  end
//end

// weighted sum approach
//subproblem_fitness=zeros(1,individual_num);
for individual_num=1:individuals
  for objective_num=1:objectives
    subproblem_fitness(1,individual_num) = subproblem_fitness(1,individual_num) + ..
    subproblem_weight(individual_num,objective_num) * Objective(individual_num,objective_num,generation_num,sample_num);
  end
end

distance=zeros(individuals,individuals);

// ���ړI��Ԃ̏d�݂̋��������߂�
for individual_num=1:individuals
  for comparison_num=1:individuals
    for objective_num=1:objectives
      distance(individual_num,comparison_num)=distance(individual_num,comparison_num)+(subproblem_weight(individual_num,objective_num)-subproblem_weight(comparison_num,objective_num))^2;
    end
    distance(individual_num,comparison_num)=sqrt(distance(individual_num,comparison_num));
  end
end
// �ߗ׌�
subproblem_neighbor(:,:,2)=10000 //�K���ɑ傫�Ȑ��ŏ��������Ă���
//subproblem_neighbor(:,1,2)=0 //���߂̗v�f����0
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

// �̂̋L�^
for individual_num=1:individuals
  for room_num=1:rooms
    records(individual_num,room_num,1:2)=Geno(room_num,1:2,individual_num);
  end
end
records(individual_num,:,3)=0; //debug: 0�ŗǂ��H

endfunction
