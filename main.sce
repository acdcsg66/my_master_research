//(c)2006-2008 Makoto Inoue
//Takagi-Lab, Graduate School of Design, Kyushu University

//多目的最適化手法をNSGA-IIからMOEA/Dに変更

lines(0);

//関数を組み込む
exec randGeno.sci
exec growPheno.sci
exec evaluate.sci
exec pareto.sci
exec selectPair.sci
exec geneManipulate.sci
exec planFig.sci
exec pseudoEvaluate.sci
exec schedule.sci
exec moea_d_initialize.sci
exec moea_d_evaluate.sci
exec moea_d_selectPair.sci
//exec moea_d_update.sci
//exec randGeno_and_growPheno.sci
exec optim_nsga2.sci
exec output_nsga2_default.sci
exec crossover_ga_default.sci
exec mutation_ga_default.sci
exec DominationRank.sci
exec pareto_filter.sci
exec init_param.sci
exec add_param.sci
exec get_param.sci
exec is_param.sci
exec init_ga_default.sci
exec coding_ga_identity.sci
//exec gettext.sci
exec growPheno_nsga2.sci
exec evaluate_nsga2.sci

//グローバル変数
global x_span y_span rooms individuals Geno Pheno objectives Objective Pareto ..
generations generation_num Pair GenoBinary children ChildBinary Child mutationRate records ..
Desirable_area Desirable_proportion sigma_share exponent_share sample_num subproblem_fitness ..
subproblem_weight subproblem_neighbor subproblem_neighbors best_so_far weight weights BIG_NUM ..
initial_num pop_opt fobj_pop_opt

//定数設定
x_span=7+5;//span to x-direction
y_span=7;//span to y-direction
rooms=7;//number of room-type
objectives=6;//Area,Proportion,Circulation,Sunlight,InnerWall,Pipe,IEC
generations=200;//世代数
samples=10;//サンプル数は2以上にしないと行列の都合でエラーが出る？
individuals=21; //個体数
sigma_share=49/4; //0<シェアリング(半径)<=(x_span*y_span) 
exponent_share=1;
children=individuals; //1世代で作る子供の数(親と子供を総入替えするので同じ数にした)
Geno=zeros(rooms,2,individuals); //ゲノタイプ（遺伝子型）
Objective=zeros(individuals,objectives,generations,samples);

BIG_NUM=10000; // とりあえず適当な大きな数
weight=zeros(individuals,objectives); //MOEA/Dで使う重み
weights=objectives*2; //MOEA/Dで使う重みの分割数
Desirable_area=[20,16,12,12,12,9,1]; //Area Size - LR,DK,BR1,BR2,BR3,WA,Path
Desirable_proportion(1:rooms,1:2)=0.5; // 2は縦:横の比．現在はすべて正方形が最良
subproblem_neighbors=3; //近隣個体の数（次で説明）
subproblem_neighbor=zeros(individuals,subproblem_neighbors+1,3); //各個体は近隣の個体を交差させ子個体を生成．neighbor+1はアルゴリズムの都合．3は1(個体番号標）と2（距離），3（評価値）
subproblem_weight=zeros(individuals,objectives); //それぞれの個体がもつfitnessへの重みベクトル．試行中の初めに一度初期化したら固定
subproblem_fitness=zeros(1,individuals); //個体ごとに単目的化，分解された目的関数．適当に大きな数で初期化
records=zeros(individuals,rooms,2); //それぞれの個体のfitnessが良好になったか調べる

Pheno=zeros(x_span+2,y_span+2,individuals); //部屋の間取り設計を入れる
initial_num=0; //NSGA-IIの初期化で使用，試行が変わったら初期化をする

//個体・目的・世代・サンプル数ごとの評価値
mutationRate=0.01; //突然変異率0～1

// NSGA-II Scilabのライブラリを使用．
//growPheno();
//evaluate();

//  f1_x1 = x(1);
//  g_x2  = 1 + 9 * sum((x(2:$)-x(1)).^2) / (length(x) - 1);
//  h     = 1 - sqrt(f1_x1 / g_x2);

//  f(1,1) = f1_x1;
//  f(1,2) = g_x2 * h;

//endfunction
// Problem dimension
dim = objectives;

// Example of use of the genetic algorithm
funcname    = 'deb_1';
PopSize     = individuals;
Proba_cross = 1;
Proba_mut   = mutationRate;
NbGen       = 1; //mainのループでgeneration_numは管理
NbCouples   = children;
//Log         = %T;
Log         = %F;
nb_disp     = 10; // Nb point to display from the optimal population
pressure    = 0.1;

// Min boundary function
function Res = min_bd_zdt1(n)
  //Res = zeros(n,1);
  Res = [2,2,2,2,2,2,2,2,2,2,2,2,2,2]; //rooms(x,y)
endfunction

// Max boundary function
function Res = max_bd_zdt1(n)
  //Res = ones(n,1);
  x=x_span+2;
  y=y_span+2;
  Res = [x,x,x,x,x,x,x,y,y,y,y,y,y,y]; //rooms(x,y)
endfunction

function f=deb_1(x) //関数を呼ぶときはindividual_numをiにしないといけない
  global Geno Objective Pheno rooms
  Objective(i,:,generation_num,sample_num)=0;
  Pheno(:,:,i)=0;
  for room_num=1:rooms
    Geno(room_num,1,i)=int8(x(room_num));
    Geno(room_num,2,i)=int8(x(rooms+room_num));
  end
  growPheno_nsga2();
  evaluate_nsga2();
  //pseudoEvaluate();
  f(1,1:6) = [Objective(i,1,generation_num,sample_num)*(-1), Objective(i,2,generation_num,sample_num)*(-1), ..
              Objective(i,3,generation_num,sample_num)*(-1), Objective(i,4,generation_num,sample_num)*(-1), ..
              Objective(i,5,generation_num,sample_num)*(-1), Objective(i,6,generation_num,sample_num)*(-1)];

endfunction

// Setting paramters of optim_nsga2 function 
ga_params = init_param();
// Parameters to adapt to the shape of the optimization problem
ga_params = add_param(ga_params,'minbound',min_bd_zdt1(dim));
ga_params = add_param(ga_params,'maxbound',max_bd_zdt1(dim));
ga_params = add_param(ga_params,'dimension',dim);
ga_params = add_param(ga_params,'beta',0);
ga_params = add_param(ga_params,'delta',0.1);
// Parameters to fine tune the Genetic algorithm.
// All these parameters are optional for continuous optimization.
// If you need to adapt the GA to a special problem. 
ga_params = add_param(ga_params,'init_func',init_ga_default);
//ga_params = add_param(ga_params,'init_func',randGeno_and_growPheno());
ga_params = add_param(ga_params,'crossover_func',crossover_ga_default);
ga_params = add_param(ga_params,'mutation_func',mutation_ga_default);
ga_params = add_param(ga_params,'codage_func',coding_ga_identity);
ga_params = add_param(ga_params,'nb_couples',NbCouples);
ga_params = add_param(ga_params,'pressure',pressure);


getdate()

//main loop////////////////////////////////////////////////////////////////////
schedule();
for sample_num=1:samples
  planFig();
  rand('seed',sample_num)//NSGA-II
  //randGeno();
  //moea_d_initialize(); // MOEA/D
  for generation_num=1:generations
    //// MOGA
    //growPheno();
    ////IEC(Display&Evaluate)
    ////xset("wpdim",700,300)
    //evaluate();
    //pseudoEvaluate();
    //pareto();
    ////Objective(:,:,generation_num,sample_num)
    //selectPair();
    //geneManipulate(); 
        
    //// MOEA/D 上のmoead_initialize()もMOEA/Dで使用
    //growPheno();
    ////IEC(Display&Evaluate)
    ////xset("wpdim",700,300)
    //evaluate();
    //pseudoEvaluate();
    //moea_d_evaluate(); //evaluate()で単目的のfitnessを出し，moea_d()で多目的に評価
    //moea_d_update(); //debug: これからMOEA/D用に修正
    ////pareto(); //debug: たぶんMOEA/Dではいらない．結果出力で必要？
    ////Objective(:,:,generation_num,sample_num)
    //moea_d_selectPair(); //MOEA/Dの方法で親個体選択
    //geneManipulate(); 
    
    // NSGA-II
    [pop_opt, fobj_pop_opt, pop_init, fobj_pop_init] = optim_nsga2(deb_1, PopSize,NbGen, Proba_mut, Proba_cross, Log, ga_params);
//    for individual_num=1:individuals
//      for room_num=1:rooms
//        Geno(room_num,1,individual_num)=int8(pop_opt(individual_num)(room_num));
//        Geno(room_num,2,individual_num)=int8(pop_opt(individual_num)(rooms+room_num));
//      end
//    end
//    for individual_num=1:individuals
//      for objective_num=1:objectives
//        Objective(individual_num,objective_num,generation_num,sample_num)=(-1)*fobj_pop_opt(individual_num,objective_num);
//      end
//    end

  end //for generation_num
  for individual_num=1:individuals
    subplot(3,7,individual_num);
    Matplot(Pheno(:,:,individual_num),'040'); //xgrid();
  end
//pause
end //for sample_num
///////////////////////////////////////////////////////////////////////////////
getdate()


////4目的のグラフ
//ObjectiveMean=zeros(generations,4);
//for generation_num=1:generations
//    for objective_num=1:4
//      ObjectiveMean(generation_num,objective_num)=..
//      mean(Objective(:,objective_num,generation_num,:));
//    end
//end
//scf(); //Open New Figure
//xgrid();
//plot2d(1:generations,ObjectiveMean,rect=[0,0.5,generations,1],style=[1,1,1,1,1,1,1]);
//A=gca();
//P=A.children.children;
//P(4).line_style=1; P(4).thickness=2;
//P(3).line_style=2; P(3).thickness=2;
//P(2).line_style=3; P(2).thickness=2;
//P(1).line_style=4; P(1).thickness=2;
//xtitle('4 Objectives','Generation','Fitness');
//legend('Obj1 Area Size','Obj2 Proportion','Obj3 Circulation','Obj4 Sunlighting',4); 


//6目的のグラフ
ObjectiveMean=zeros(generations,6);
for generation_num=1:generations
    for objective_num=1:6
      ObjectiveMean(generation_num,objective_num)=..
      mean(Objective(:,objective_num,generation_num,:));
    end
end
scf(); //Open New Figure
xgrid();
plot2d(1:generations,ObjectiveMean,rect=[0,0,generations,1],style=[1,1,1,1,1,1,1]);
A=gca();
P=A.children.children;
P(6).line_style=1; P(6).thickness=2;
P(5).line_style=2; P(5).thickness=2;
P(4).line_style=3; P(4).thickness=2;
P(3).line_style=4; P(3).thickness=2;
P(2).line_style=5; P(2).thickness=2;
P(1).line_style=6; P(1).thickness=2;
//P(7).line_style=6; P(7).thickness=2;
xtitle('6 Objectives','Generation','Fitness');
legend('Obj1 Area Size','Obj2 Proportion','Obj3 Circulation','Obj4 Sunlighting','Obj5 Wall','Obj6 Duct',4);


beep

save('Objective.dat',Objective)
