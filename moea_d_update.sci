function moea_d_update

global objectives individuals generations rooms subproblem_neighbors subproblem_neighbor rooms ..
records tche_records present_objective subproblem_fitness generation_num sample_num

distance=zeros(individuals,individuals); //多目的空間の個体間距離

// 更新
for individual_num=1:individuals
  if tche_records(individual_num,present_objective(1,individual_num)) > subproblem_fitness(1,individual_num) // fitnessが低くなったら（←Tchebycheffは最小化問題なので）更新
    for room_num=1:rooms
      records(individual_num,room_num,1:2)=Geno(room_num,1:2,individual_num);
    end
    tche_records(individual_num,present_objective(1,individual_num)) = subproblem_fitness(1,individual_num);
  end
end
// fitnessが良好になった個体が更新される（それ以外は同じ値が代入される）
for individual_num=1:individuals
  for room_num=1:rooms
    Geno(room_num,1:2,individual_num)=records(individual_num,room_num,1:2);
  end
end

distance=zeros(individuals,individuals);

// 多目的空間の個体どうしの距離を求める
for individual_num=1:individuals
  for comparison_num=1:individuals
    for objective_num=1:objectives
      distance(individual_num,comparison_num)=distance(individual_num,comparison_num)..
      +(Objective(individual_num,objective_num,generation_num,sample_num)-Objective(comparison_num,objective_num,generation_num,sample_num))^2;
    end
    distance(individual_num,comparison_num)=sqrt(distance(individual_num,comparison_num));
  end
end

// 近隣個体
for individual_num=1:individuals
  for comparison_num=1:individuals
    for neighbor_num=subproblem_neighbors:(-1):1 // 要素: subproblem_neighbors+1は実際の処理時には使われない
      if subproblem_neighbor(individual_num,neighbor_num,2) > distance(individual_num,comparison_num) .. // より距離の近い個体を発見したら
      & individual_num ~= comparison_num // 比較対象が自分自身のとき除外
        subproblem_neighbor(individual_num,neighbor_num+1,1)=subproblem_neighbor(individual_num,neighbor_num,1); // 現在個体から見て比較個体より距離が遠い個体をずらしてから代入
        subproblem_neighbor(individual_num,neighbor_num+1,2)=subproblem_neighbor(individual_num,neighbor_num,2);
        subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //個体番号代入
        subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //距離代入
      //elseif subproblem_neighbor(individual_num,neighbor_num,2) == 0 .. //まだ代入されていないならそのまま代入
      //& individual_num ~= comparison_num // 比較対象が自分自身のとき除外
      //  subproblem_neighbor(individual_num,neighbor_num,1)=comparison_num; //個体番号代入
      //  subproblem_neighbor(individual_num,neighbor_num,2)=distance(individual_num,comparison_num); //距離代入
      //  pause
      end
    end
  end
end
// 近隣個体のfitnessを代入
for individual_num=1:individuals
  for neighbor_num=1:subproblem_neighbors
    subproblem_neighbor(individual_num,neighbor_num,3)=subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1));
  end
end
//for individual_num=1:individuals
//  for neighbor_num=1:subproblem_neighbors // 要素: subproblem_neighbors+1は実際の処理時には使われない
//    if subproblem_neighbor(individual_num,neighbor_num,3) < subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1))
//    //if subproblem_neighbor(individual_num,neighbor_num,3) < records(subproblem_neighbor(individual_num,neighbor_num,1),1,3) // fitnessが高くなったら更新
//    //& individual_num ~= subproblem_neighbor(individual_num,neighbor_num,1) // 比較対象が自分自身のとき除外
//      subproblem_neighbor(individual_num,neighbor_num,3)=subproblem_fitness(1,subproblem_neighbor(individual_num,neighbor_num,1)); //更新
//      //subproblem_neighbor(individual_num,neighbor_num,3)=records(subproblem_neighbor(individual_num,neighbor_num,1),1,3);
//    end
//  end
//end

endfunction
