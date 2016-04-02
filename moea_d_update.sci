function moea_d_update

global objectives individuals generations rooms subproblem_neighbors best_so_far subproblem_neighbor

distance=zeros(individuals,individuals); //多目的空間の個体間距離

// 過去のベストfitness値、目的ごとに
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

// 近隣個体
for individual_num=1:individuals
  for neighbor_num=1:subproblem_neighbors // 要素: subproblem_neighbors+1は実際の処理時には使われない
    if subproblem_neighbor(individual_num,neighbor_num,3) < subproblem_fitness(1,individual_num) .. // fitnessが高くなったら更新
    & individual_num ~= subproblem_neighbor(individual_num,neighbor_num,1) // 比較対象が自分自身のとき除外
      subproblem_neighbor(individual_num,neighbor_num,3)=subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1)); //更新
    end
  end
end

// 単目的で過去のベストfitness値、目的ごとに
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

endfunction
