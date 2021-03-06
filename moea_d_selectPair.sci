function moea_d_selectPair

global objectives individuals subproblem_fitness subproblem_weight subproblem_neighbors Pair children generations rooms subproblem_neighbors subproblem_neighbor

//親個体選択
for children_num=1:children

  //parent1
  flag=0;
  parent1=0;
  //rand('seed',getdate('s'))
  roulette=rand();
  for candidate_num=1:subproblem_neighbors
    if roulette<=(candidate_num/subproblem_neighbors) & flag==0
      parent1=subproblem_neighbor(children_num,candidate_num,1);
      flag=1;
    end //if
  end // for children_num

  //parent2
  flag=0;
  while flag==0
    parent2=parent1; // 同じ親になのに誤ってflagを立てるのを防止
    //rand('seed',getdate('s'))
    roulette=rand();
    for candidate_num=1:subproblem_neighbors //debug: 親個体1を除外して近隣個体群を構成しなおさないで良いか？
      if roulette<=(candidate_num/subproblem_neighbors) & flag==0
        parent2=subproblem_neighbor(children_num,candidate_num,1);
        if parent1~=parent2
          flag=1;
        end
      end //if
    end // for children_num
  end //while

  Pair(children_num,1)=parent1;
  Pair(children_num,2)=parent2;
  
end //for children_num

endfunction
