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
exec moea_d_update.sci

//グローバル変数
global x_span y_span rooms individuals Geno Pheno objectives Objective Pareto ..
generations generation_num Pair GenoBinary children ChildBinary Child mutationRate tche_records tche_records present_num ..
Desirable_area Desirable_proportion sigma_share exponent_share sample_num subproblem_fitness ..
subproblem_weight subproblem_neighbor subproblem_neighbors BIG_NUM best_so_far

//定数設定
BIG_NUM=10000; //適当に大きな数
x_span=7+5;//span to x-direction
y_span=7;//span to y-direction
rooms=7;//number of room-type
objectives=6;//Area,Proportion,Circulation,Sunlight,InnerWall,Pipe,IEC
generations=50;//世代数
samples=10;//サンプル数は2以上にしないと行列の都合でエラーが出る？
individuals=21; //個体数
//sigma_share=49/4; //0<シェアリング(半径)<=(x_span*y_span) //debug: NSGA-II用？
//exponent_share=1;
children=individuals; //1世代で作る子供の数(親と子供を総入替えするので同じ数にした)
Desirable_area=[20,16,12,12,12,9,1]; //Area Size - LR,DK,BR1,BR2,BR3,WA,Path
Desirable_proportion(1:rooms,1:2)=0.5; // 2は縦:横の比．現在はすべて正方形が最良
best_so_far=zeros(1,individuals); //各目的ごとに過去のbest fitness（単目的評価）
subproblem_neighbors=5; //近隣個体の数（次で説明）
subproblem_neighbor=zeros(individuals,subproblem_neighbors+1,3); //各個体は近隣の個体を交差させ子個体を生成．neighbor+1はアルゴリズムの都合．3は1(個体番号標）と2（距離），3（評価値）
subproblem_weight=zeros(individuals,objectives); //それぞれの個体がもつfitnessへの重みベクトル．試行中の初めに一度初期化したら固定
subproblem_fitness=zeros(1,individuals); //個体ごとに単目的化，分解された目的関数．適当に大きな数で初期化
records=zeros(individuals,rooms,2); //記録1　更新するかどうかを決める（各個体の部屋の種座標とfitnessを保存）
tche_records(1:individuals,1:objectives)=BIG_NUM; // 記録2 Tchebycheff methodで最適化する目的関数
present_num=0; //最適化する目的番号
//sorted_distance=zeros();
Geno=zeros(rooms,2,individuals); //ゲノタイプ（遺伝子型）
Objective=zeros(individuals,objectives,generations,samples);
//個体・目的・世代・サンプル数ごとの評価値
mutationRate=0.01; //突然変異率0～1

getdate()

//main loop////////////////////////////////////////////////////////////////////
schedule();
for sample_num=1:samples
  planFig();
  randGeno();
  moea_d_initialize(); // MOEA/D
  for generation_num=1:generations
    //// NSGA-II
    //growPheno();
    ////IEC(Display&Evaluate)
    ////xset("wpdim",700,300)
    //evaluate();
    //pseudoEvaluate();
    //pareto();
    ////Objective(:,:,generation_num,sample_num)
    //selectPair();
    //geneManipulate(); 
    
    // MOEA/D 上のmoead_initialize()もMOEA/Dで使用
    growPheno();
    //IEC(Display&Evaluate)
    //xset("wpdim",700,300)
    evaluate();
    pseudoEvaluate();
    moea_d_evaluate(); //evaluate()で単目的のfitnessを出し，moea_d()で多目的に評価
    //pareto(); //debug: たぶんMOEA/Dではいらない．結果出力で必要？
    //Objective(:,:,generation_num,sample_num)
    moea_d_selectPair(); //MOEA/Dの方法で親個体選択
    geneManipulate(); 
    moea_d_update(); //debug: これからMOEA/D用に修正

  end //for generation_num
  for individual_num=1:individuals
    subplot(3,7,individual_num);
    Matplot(Pheno(:,:,individual_num),'040'); //xgrid();
  end

end //for sample_num
///////////////////////////////////////////////////////////////////////////////
getdate()


//4目的のグラフ
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
