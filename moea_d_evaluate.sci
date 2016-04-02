function moea_d_evaluate

global objectives individuals subproblem_fitness subproblem_weight

distance=zeros(individuals,individuals); //多目的空間の個体間距離
Pair=zeros(children,2);

// 単目的で過去のベストfitness値（目的ごとに）Tchebycheff用
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

// weight_sum or Tchebycheff選択
//weight_sum  //debug: 本当はsum()を使いたかったけどうまく動かなかったのでforループ
for individual_num=1:individuals
  subproblem_fitness(1,individual_num)=subproblem_weight(individual_num,1)*Objective(individual_num,1,generation_num,sample_num);
end
for individual_num=1:individuals
  for objective_num=2:objectives
    subproblem_fitness(1,individual_num)=subproblem_fitness(1,individual_num) + ..
    subproblem_weight(individual_num,objective_num)*Objective(individual_num,objective_num,generation_num,sample_num);
  end
end
///Tchebycheff
//これから作成

endfunction
