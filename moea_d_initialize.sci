function moea_d_initialize

global objectives individuals rooms subproblem_fitness subproblem_weight subproblem_neighbors Pair children ..
generations rooms subproblem_neighbors subproblem_neighbor records weight weights

weight(:,:)=0; //MOEA/Dで使う重み
subproblem_neighbor(:,:,:)=0; //各個体は近隣の個体を交差させ子個体を生成．neighbor+1はアルゴリズムの都合．3は1(個体番号標）と2（距離），3（評価値）
subproblem_weight(:,:)=0; //それぞれの個体がもつfitnessへの重みベクトル．試行中の初めに一度初期化したら固定
subproblem_fitness(1,:)=0; //個体ごとに単目的化，分解された目的関数．適当に大きな数で初期化
records(:,:,:)=0; //それぞれの個体のfitnessが良好になったか調べる

//// MOEA/Dで用いる重みベクトルを決定 現在は単純に一様分布の乱数から重み決定（個体ごとに，全目的の総和は1） //ToDo: 本当はもっとしっかりとした手法で重みづけ
//for individual_num=1:individuals
//  budget=1;
//  last=1;
//  for objective_num=1:objectives
//    budget=budget*rand();
//    subproblem_weight(individual_num,objective_num)=last-budget;
//    last=budget;
//  end
//end

// MOEA/Dで用いる重みベクトルを決定 現在は単純に一様分布の乱数から重み決定（個体ごとに，全目的の総和は1）
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

// 多目的空間の重みの距離を求める
for individual_num=1:individuals
  for comparison_num=1:individuals
    for objective_num=1:objectives
      distance(individual_num,comparison_num)=distance(individual_num,comparison_num)+(subproblem_weight(individual_num,objective_num)-subproblem_weight(comparison_num,objective_num))^2;
    end
    distance(individual_num,comparison_num)=sqrt(distance(individual_num,comparison_num));
  end
end
// 近隣個体
subproblem_neighbor(:,:,2)=10000 //適当に大きな数で初期化しておく
//subproblem_neighbor(:,1,2)=0 //初めの要素だけ0
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

// 個体の記録
for individual_num=1:individuals
  for room_num=1:rooms
    records(individual_num,room_num,1:2)=Geno(room_num,1:2,individual_num);
  end
end
records(individual_num,:,3)=0; //debug: 0で良い？

endfunction
