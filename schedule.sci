function schedule

global Schedule generations objectives

//1の時にparetoで評価する
//実行の前にScheduleを確認すること
Schedule=zeros(generations,objectives);

//Schedule(:,7)=1;
Schedule(:,1:4)=1;
//Schedule(:,7)=1;
//Schedule(:,1:6)=1;

for n=5:5:50 //begin:step:end
  //Schedule(n,1:4)=0;
  Schedule(n,7)=1; //場合によって0を入れることも出来る
end

endfunction
