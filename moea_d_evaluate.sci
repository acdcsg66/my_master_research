function moea_d_evaluate

global objectives individuals subproblem_fitness subproblem_weight


// weighted sum approach
for objective_num=1:objectives
  subproblem_fitness(1,1)=subproblem_weight(1,objective_num)*Objective(1,objective_num,generation_num,sample_num);
end
for individual_num=2:individuals
  for objective_num=1:objectives
    subproblem_fitness(1,individual_num) = subproblem_fitness(1,individual_num-1) + ..
    subproblem_weight(individual_num,objective_num) * Objective(individual_num,objective_num,generation_num,sample_num);
  end
end

endfunction
