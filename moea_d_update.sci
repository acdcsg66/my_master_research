function moea_d_update

global objectives individuals generations rooms subproblem_neighbors best_so_far subproblem_neighbor

distance=zeros(individuals,individuals); //多目的空間の個体間距離

// 過去のベストfitness値、目的ごとに
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

// 多目的空間の個体間距離を求める
for individual_num=1:individuals
  for comparison_num=1:individuals
    for objective_num=1:objectives
      distance(individual_num,comparison_num)=distance(individual_num,comparison_num)+(Objective(individual_num,objective_num,generation_num,sample_num)-Objective(comparison_num,objective_num,generation_num,sample_num))^2;
    end
    distance(individual_num,comparison_num)=sqrt(distance(individual_num,comparison_num));
  end
end
// 近隣個体 debug: ゼロの例外処理
subproblem_neighbor(:,:,2)=10000 //適当に大きな数で初期化しておく
subproblem_neighbor(:,1,2)=0 //初めの要素だけ0
for individual_num=1:individuals
  for comparison_num=1:individuals
    for neighbor_num=subproblem_neighbors:(-1):1 // 要素: subproblem_neighbors+1は実際の処理時には使われない
      if subproblem_neighbor(individual_num,neighbor_num,2) > distance(individual_num,comparison_num) .. // より距離の近い個体を発見したら
      & individual_num ~= comparison_num // 比較対象が自分自身のとき除外
        subproblem_neighbor(individual_num,neighbor_num+1,1)=subproblem_neighbor(individual_num,neighbor_num,1); // 現在個体から見て比較個体より距離が遠い個体をずらしてから代入
        subproblem_neighbor(individual_num,neighbor_num+1,2)=subproblem_neighbor(individual_num,neighbor_num,2);
        subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //個体番号代入
        subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //距離代入
      elseif subproblem_neighbor(individual_num,neighbor_num,1) == 0 .. //まだ代入されていないならそのまま代入
      & individual_num ~= comparison_num // 比較対象が自分自身のとき除外
        subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //個体番号代入
        subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //距離代入
      end
    end
  end
end

// 単目的で過去のベストfitness値、目的ごとに
for objective_num=1:objectives
  best_so_far(1,objective_num)=max(Objective(:,objective_num,generation_num,sample_num),'r');
end

endfunction
