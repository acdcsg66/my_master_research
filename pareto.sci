function pareto

global individuals objectives Objective Pareto generation_num sample_num Schedule

//Parate Ranking (Fonseca，弱パレートはランクを下げる)
Pareto=ones(1,individuals);
win_flag=0;
ovarlap_flag=1; //Objectiveの値が全て同じ場合は1
pause;
for i=1:individuals //比較主体の個体番号
  for j=1:individuals //比較相手の個体番号 
    if i~=j //自分自身との比較を避ける
      for objective_num=1:objectives //下で>=にした時は必要な目的数だけをobjectivesに設定せよ
        if Schedule(generation_num,objective_num)==1
          xi=Objective(i,objective_num,generation_num,sample_num);
          xj=Objective(j,objective_num,generation_num,sample_num);
          if xi>xj // > or >=
            win_flag=1; //少なくとも一回は勝てば良い
          elseif xi<xj //>=の時はここと下は不要？
            ovarlap_flag=0; //Objectiveの値に違いがある
          end //if Objective
        end // if Schedule
      end // for objective_num
      //debug: if win_flag==0 & ovarlap_flag==0 //>=の時はovarlap_flagは不要？
      if win_flag==1 & ovarlap_flag==0 //>=の時はovarlap_flagは不要？
      //if すべての目的関数について勝ってはいない & Objectiveの値に違いがある
        //Pareto(1,i)=Pareto(1,i)+1; //Pareto Rankを一つ下げる //debug: 上げている？
        Pareto(1,i)=Pareto(1,i)-1; //Pareto Rankを一つ下げる //debug: 上げている？
      end // if
      win_flag=0; //reset flag
      ovarlap_flag=1; //reset flag
    end //if i~=j
  end //for j
end //for i
//end Parate Ranking

endfunction