function pseudoEvaluate
global individuals Pareto Pair children x_span y_span Pheno Objective ..
generation_num sample_num

//擬似人間用目標フェノタイプ（表現型）
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
targets=2;//必要に応じて目標の間取り数を設定し，下で間取りを定義すること
TargetPheno=zeros(x_span+2,y_span+2,targets);
TargetPheno(:,:,1)=[
 8  8  8  8  8  8  8  8  8;
10  3  3  3  7  4  4  4 10;
10  3  3  3  7  4  4  4 10;
10  3  3  3  7  4  4  4 10;
10  3  3  3  7  4  4  4 10;
10  6  6  2  2  2  2  2 10;
10  6  6  2  2  2  2  2 10;
10  6  6  2  2  2  2  2 10;
10  6  6  6  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  9  9  9  9  9  9  9 10];
//左右反転
TargetPheno(:,:,2)=[
 8  8  8  8  8  8  8  8  8;
10  4  4  4  7  3  3  3 10;
10  4  4  4  7  3  3  3 10;
10  4  4  4  7  3  3  3 10;
10  4  4  4  7  3  3  3 10;
10  2  2  2  2  2  6  6 10;
10  2  2  2  2  2  6  6 10;
10  2  2  2  2  2  6  6 10;
10  1  1  1  1  6  6  6 10;
10  1  1  1  1  5  5  5 10;
10  1  1  1  1  5  5  5 10;
10  1  1  1  1  5  5  5 10;
10  1  1  1  1  5  5  5 10;
10  9  9  9  9  9  9  9 10]; 

//目標の間取りと出来た間取りの差を求める
Difference=zeros(individuals,targets);
for individual_num=1:individuals //比較主体の個体番号 
  for target_num=1:targets //比較相手の個体番号
    for x=2:x_span+1
      for y=2:y_span+1
        phenoRoom=Pheno(x,y,individual_num);
        targetRoom=TargetPheno(x,y,target_num);
        //(PhenoとTargetが異なる)且つ（PhenoがBR1～3かつTargetがBR1～3）でない
        if phenoRoom~=targetRoom & ..
          ~((phenoRoom==3 | phenoRoom==4 | phenoRoom==5) & ..
            (targetRoom==3 | targetRoom==4 | targetRoom==5))
          Difference(individual_num,target_num)=..
          Difference(individual_num,target_num)+1;
        end //if
      end //for y
    end //for x
  end //for target_num
end //for individual_num

//良い方（小さい方）を選択する
DifferenceBetter=zeros(individuals,1);
for individual_num=1:individuals
  DifferenceBetter(individual_num,1)=min(Difference(individual_num,:));
end
best=min(DifferenceBetter);
worst=max(DifferenceBetter);
width=(worst-best)/5;//１点の幅

//ここでは1点から0.2刻みで0.2までをIEC評価点としている．ベストは1点
if best==worst
  Objective(:,7,generation_num,sample_num)=1;
else
  for individual_num=1:individuals
    if     DifferenceBetter(individual_num,1)>=worst-width
      Objective(individual_num,7,generation_num,sample_num)=0.2;
    elseif DifferenceBetter(individual_num,1)>=worst-2*width
      Objective(individual_num,7,generation_num,sample_num)=0.4;
    elseif DifferenceBetter(individual_num,1)>=worst-3*width
      Objective(individual_num,7,generation_num,sample_num)=0.6;
    elseif DifferenceBetter(individual_num,1)>=worst-4*width
      Objective(individual_num,7,generation_num,sample_num)=0.8;
    else
      Objective(individual_num,7,generation_num,sample_num)=1;
    end // if
  end //for individual_num    
end //if


endfunction 
