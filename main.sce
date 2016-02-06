//(c)2006-2008 Makoto Inoue
//Takagi-Lab, Graduate School of Design, Kyushu University

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

//グローバル変数
global x_span y_span rooms individuals Geno Pheno objectives Objective Pareto ..
generations generation_num Pair GenoBinary children ChildBinary Child mutationRate ..
sigma_share exponent_share sample_num

//定数設定
x_span=7+5;//span to x-direction
y_span=7;//span to y-direction
rooms=7;//number of room-type
objectives=4;//Area,Proportion,Circulation,Sunlight,InnerWall,Pipe,IEC
generations=50;//世代数
samples=50;//サンプル数は2以上にしないと行列の都合でエラーが出る？
individuals=21; //個体数
sigma_share=49/4; //0<シェアリング(半径)<=(x_span*y_span)
exponent_share=1; //
children=individuals; //1世代で作る子供の数(親と子供を総入替えするので同じ数にした)
Geno=zeros(rooms,2,individuals); //ゲノタイプ（遺伝子型）
Objective=zeros(individuals,objectives,generations,samples);
//個体・目的・世代・サンプル数ごとの評価値
mutationRate=0.01; //突然変異率0～1

draw_picture=zeros(x_span+2,y_span+2);

getdate()
//main loop////////////////////////////////////////////////////////////////////
schedule();
for sample_num=1:samples
  planFig();
  randGeno();
  for generation_num=1:generations
    growPheno();
    //IEC(Display&Evaluate)
    //xset("wpdim",700,300)
    for individual_num=1:individuals
      subplot(3,7,individual_num);
      Matplot(Pheno(:,:,individual_num),'040'); //xgrid();
    end
    evaluate();
    pseudoEvaluate();
    pareto();
    //Objective(:,:,generation_num,sample_num)
    selectPair();
    geneManipulate(); 
  end //for generation_num
//debug: 場所を上に移動
//  for individual_num=1:individuals
//    subplot(3,7,individual_num);
//    Matplot(Pheno(:,:,individual_num),'040'); //xgrid();
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
//ObjectiveMean=zeros(generations,6);
//for generation_num=1:generations
//    for objective_num=1:6
//      ObjectiveMean(generation_num,objective_num)=..
//      mean(Objective(:,objective_num,generation_num,:));
//    end
//end
//scf(); //Open New Figure
//xgrid();
//plot2d(1:generations,ObjectiveMean,rect=[0,0,generations,1],style=[1,1,1,1,1,1,1]);
//A=gca();
//P=A.children.children;
//P(6).line_style=1; P(6).thickness=2;
//P(5).line_style=2; P(5).thickness=2;
//P(4).line_style=3; P(4).thickness=2;
//P(3).line_style=4; P(3).thickness=2;
//P(2).line_style=5; P(2).thickness=2;
//P(1).line_style=6; P(1).thickness=2;
////P(7).line_style=6; P(7).thickness=2;
//xtitle('6 Objectives','Generation','Fitness');
//legend('Obj1 Area Size','Obj2 Proportion','Obj3 Circulation','Obj4 Sunlighting','Obj5 Wall','Obj6 Duct',4);


beep

//save('Objective.dat',Objective)
