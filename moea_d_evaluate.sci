function moea_d_evaluate

global objectives individuals subproblem_fitness subproblem_weight best_so_far present_objective

distance=zeros(individuals,individuals); //多目的空間の個体間距離
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
// 単目的で過去のベストfitness値（目的ごとに）Tchebycheff用 //debug: max()の使い方わからないのでループ
for individual_num=1:individuals
  for objective_num=1:objectives
    if best_so_far(1,individual_num) < Objective(individual_num,objective_num,generation_num,sample_num) // 右辺の最大値を代入
      best_so_far(1,individual_num) = Objective(individual_num,objective_num,generation_num,sample_num); //fitness
    end
  end
end
///Tchebycheff debug: max()の使い方わからないのでループ
subproblem_fitness(1,1:individuals)=0;
for individual_num=1:individuals
  for objective_num=1:objectives
    if subproblem_fitness(1,individual_num) < subproblem_weight(individual_num,objective_num) * ..
    abs(Objective(individual_num,objective_num,generation_num,sample_num) - best_so_far(1,individual_num))
      subproblem_fitness(1,individual_num) = subproblem_weight(individual_num,objective_num) * .. //右辺が最大値になる目的を最適化する
      abs(Objective(individual_num,objective_num,generation_num,sample_num) - best_so_far(1,individual_num)); 
      present_objective(1,individual_num) = objective_num; //最適化する目的番号
    end
  end
end



endfunction
