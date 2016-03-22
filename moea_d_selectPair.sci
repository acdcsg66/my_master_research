function moea_d_selectPair

global objectives individuals subproblem_fitness subproblem_weight subproblem_neighbors Pair children generations rooms subproblem_neighbors best_so_far subproblem_neighbor

distance=zeros(individuals,individuals); //多目的空間の個体間距離
Pair=zeros(children,2);

// 単目的で過去のベストfitness値（目的ごとに）Tchebycheff用
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

// weight_sum or Tchebycheff選択
//weight_sum  //debug: 本当はsum()を使いたかったけどうまく動かなかったのでforループ
for objective_num=1:objectives
  subproblem_fitness(1,1)=subproblem_weight(1,objective_num)*Objective(1,objective_num,generation_num,sample_num);
end
for individual_num=2:individuals
  for objective_num=1:objectives
    subproblem_fitness(1,individual_num)=subproblem_fitness(1,individual_num-1) + ..
    subproblem_weight(individual_num,objective_num)*Objective(individual_num,objective_num,generation_num,sample_num);
  end
end
///Tchebycheff
//これから作成

//親個体選択
for children_num=1:children

  //parent1
  parent1=0;
  roulette=rand();
  for candidate_num=1:subproblem_neighbors
    if roulette<=(subproblem_neighbor(children_num,candidate_num,1)/subproblem_neighbors)
      parent1=candidate_num;
      break
    end //if
  end // for children_num

  //parent2
  parent2=0;
  while parent2==0
    roulette=rand();
    for candidate_num=1:subproblem_neighbors //debug: 親個体1を除外して近隣個体群を構成しなおさないで良いか？
      if roulette<=(subproblem_neighbor(children_num,candidate_num,1)/subproblem_neighbors) & parent1~=candidate_num //parent1~=parent2
        parent2=candidate_num;
        break
      end //if
    end // for children_num
  end //while

  Pair(children_num,1)=parent1;
  Pair(children_num,2)=parent2;

end //for children_num

endfunction
