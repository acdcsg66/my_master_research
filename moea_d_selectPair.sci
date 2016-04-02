function moea_d_selectPair

global objectives individuals subproblem_fitness subproblem_weight subproblem_neighbors Pair children generations rooms subproblem_neighbors best_so_far subproblem_neighbor

//親個体選択
for children_num=1:children

  //parent1
  parent1=0;
  rand('seed',getdate('s'))
  roulette=rand();
  for candidate_num=1:subproblem_neighbors
    if roulette<=(candidate_num/subproblem_neighbors)
      parent1=subproblem_neighbor(children_num,candidate_num,1);
      break
    end //if
  end // for children_num

  //parent2
  parent2=0;
  while parent2==0
    rand('seed',getdate('s'))
    roulette=rand();
    for candidate_num=1:subproblem_neighbors //debug: 親個体1を除外して近隣個体群を構成しなおさないで良いか？
      if roulette<=(candidate_num/subproblem_neighbors) & parent1~=candidate_num //parent1~=parent2
        parent2=subproblem_neighbor(children_num,candidate_num,1);
        break
      end //if
    end // for children_num
  end //while

  Pair(children_num,1)=parent1;
  Pair(children_num,2)=parent2;

end //for children_num

endfunction
