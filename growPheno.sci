function growPheno

global individuals rooms x_span y_span rooms Geno Pheno Desirable_area seed_distance growth_area
//select_prob room_available seed_distance growth_area seed_distance ..
//end_flag common_flag  Direction_flag room_flag count

//フェノタイプ（表現型）雛形の作成
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
Pheno=zeros(x_span+2,y_span+2,individuals);
Pheno(1,1:y_span+2,:)=8,Pheno(x_span+2,2:y_span+1,:)=9;
Pheno(2:x_span+2,1,:)=10;
Pheno(2:x_span+2,y_span+2,:)=10;

end_flag=0; // 成長をやめることを判断するフラグ
common_flag=0; // 汎用フラグ

select_prob=zeros(rooms,individuals); // 選択確率計算に必要
room_available=zeros(rooms,individuals); // 選択確率計算に必要
seed_distance=zeros(rooms,4,individuals); // 種から部屋の端までの距離
growth_area=zeros(rooms,4,individuals); // 各方向ごとに成長できるエリアの面積
Direction_flag=zeros(rooms,4,individuals); // 部屋、方向ごとに成長するかを判断するフラグ
room_flag=zeros(rooms,individuals); // 部屋単位で成長できるかを判断するフラグ(Direction_flagが一つでも立てばこれも立つ)
dir_prob=zeros(rooms,4,individuals); // 方向選択に必要

//put Geno points into Pheno
for individual_num=1:individuals
  for room_num=1:rooms
    //Point means coordinate of seed
    Point=Geno(room_num,1:2,individual_num);
    //there is overlap problem on next line
    Pheno(Point(1),Point(2),individual_num)=room_num;
  end
end

//成長可能エリアのカウント
for individual_num=1:individuals
  end_flag=0;
  while end_flag==0
    for room_num=1:rooms
      //Point means coordinate of seed
      Point=Geno(room_num,1:2,individual_num);
      //種から各方向のエリア端までの距離(seed_distance)を計算
      common_flag=0;
      //North
      while common_flag==0
        if Point(1)-seed_distance(room_num,1,individual_num)>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(1)-seed_distance(room_num,1,individual_num),Point(2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,1,individual_num)=seed_distance(room_num,1,individual_num)+1;
          else //debug: elseがうまく対応していないかも（自動インデントがおかしかった．単にeditorの問題？）
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //North
      common_flag=0;
      //East
      while common_flag==0
        if Point(2)+seed_distance(room_num,2,individual_num)<=y_span // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(1),Point(2)+seed_distance(room_num,2,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,2,individual_num)=seed_distance(room_num,2,individual_num)+1;
          else //debug: elseがうまく対応していないかも（自動インデントがおかしかった．単にeditorの問題？）
            common_flag=1;
          end // if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //East
      common_flag=0;
      //South
      while common_flag==0
        if Point(1)+seed_distance(room_num,3,individual_num)<=x_span// 全体のエリアをはみ出さないかチェック
          if Pheno(Point(1)+seed_distance(room_num,3,individual_num),Point(2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,3,individual_num)=seed_distance(room_num,3,individual_num)+1;
          else //debug: (（自動インデントがおかしかった．単にeditorの問題？）
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //South
      common_flag=0;
      //West
      while common_flag==0
        if Point(2)-seed_distance(room_num,4,individual_num)>=1// 全体のエリアをはみ出さないかチェック
          if Pheno(Point(1),Point(2)-seed_distance(room_num,4,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,4,individual_num)=seed_distance(room_num,4,individual_num)+1;
          else //debug: elseがうまく対応していないかも（自動インデントがおかしかった．単にeditorの問題？）
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //West
    
      //成長可能エリアを計算
      count=1;
      common_flag=0;
      //North
      while common_flag==0
        for unit=Point(2)-seed_distance(room_num,4,individual_num):Point(2)+seed_distance(room_num,2,individual_num) // 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(1)-seed_distance(room_num,1,individual_num)-count>=1 // 成長方向、エリアはみ出さない（成長方向）なら
            if Pheno(Point(1)-seed_distance(room_num,1,individual_num)-count,unit,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,1,individual_num)=growth_area(room_num,1,individual_num)+(seed_distance(room_num,4,individual_num)+seed_distance(room_num,2,individual_num)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end
      end //North
      common_flag=0;
      //East
      count=1;
      while common_flag==0
        for unit=Point(1)-seed_distance(room_num,1,individual_num):Point(1)+seed_distance(room_num,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(2)+seed_distance(room_num,2,individual_num)+count<=y_span // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(2)+seed_distance(room_num,2,individual_num)+count,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,2,individual_num)=growth_area(room_num,2,individual_num)+(seed_distance(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end
      end //East
      common_flag=0;
      //South
      count=1;
      while common_flag==0
        for unit=Point(2)-seed_distance(room_num,4,individual_num):Point(2)+seed_distance(room_num,2,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(1)+seed_distance(room_num,3,individual_num)+count<=x_span // エリアはみ出さない（成長方向）なら
            if Pheno(Point(1)+seed_distance(room_num,3,individual_num)+count,unit,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,3,individual_num)=growth_area(room_num,3,individual_num)+(seed_distance(room_num,4,individual_num)+seed_distance(room_num,2,individual_num)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end
      end //South
      common_flag=0;
      //West
      count=1;
      while common_flag==0
        for unit=Point(1)-seed_distance(room_num,1,individual_num):Point(1)+seed_distance(room_num,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(2)-seed_distance(room_num,4,individual_num)-count>=1 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(2)-seed_distance(room_num,4,individual_num)-count,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,4,individual_num)=growth_area(room_num,4,individual_num)+(seed_distance(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end
      end //West
      common_flag=0;
    end //room_num
    
    // 成長できる部屋、方向にフラグを立てる
    for room_num=1:rooms
      for direction_num=1:4
        if (growth_area(room_num,direction_num,individual_num)>0) //& (Direction_flag(room_num,direction_num,individual_num)==0)
          Direction_flag(room_num,direction_num,individual_num)=1;
          room_flag(room_num,individual_num)=1; //debug: overloadの問題
        end //if
      end //direction_num
    end //room_num
  
//    pause

    //終了判定
    end_flag=1;
    for room_num=1:rooms
      if room_flag(room_num,individual_num)==1
        end_flag=0;
      end
    end
  
    if end_flag==0 // 成長条件（一つでも成長できる部屋があれば）
      //選択確率計算
      for room_num=1:rooms // 成長できない部屋を除外
        if room_flag(room_num,individual_num)==1
          room_available(room_num,individual_num) = Desirable_area(room_num);
        else
          room_available(room_num,individual_num) = 0;
        end//if
      end
      room_sum=0;
      for room_num=1:rooms // 選択確率を計算、ルーレット選択
        if room_available(room_num,individual_num)~=0
          room_sum = room_available(room_num,individual_num)/sum(room_available(1:rooms,individual_num))+ room_sum;
          select_prob(room_num,individual_num) = room_sum;
        else
          select_prob(room_num,individual_num) = 0;
        end
      end

      //部屋選択
      select_room=0;
      rand_num=rand();//0~1の一様分布乱数
      for room_num=1:rooms
        if rand_num>=select_prob(room_num,individual_num) & select_prob(room_num,individual_num)~=0
          select_room=room_num;
        end
      end

      //方向選択
      dir_sum=0;
      for count=1:4
        if Direction_flag(select_room,count,individual_num)~=0
          dir_sum=Direction_flag(select_room,count,individual_num)/sum(Direction_flag(select_room,1:4,individual_num))+dir_sum;
          dir_prob(select_room,count,individual_num) = dir_sum;
        else
          dir_prob(select_room,count,individual_num) = 0;
        end
      end
      select_dir=0;
      rand_num=rand();//0~1の一様分布乱数
      for count=1:4
        if rand_num>=dir_prob(select_room,count,individual_num) & dir_prob(room_num,count,individual_num)~=0
          select_dir=count;
        end
      end
      //Point means coordinate of seed
      Point=Geno(select_room,1:2,individual_num);
pause
      //成長      
      //North
      if Direction_flag(select_room,1)==1 & select_dir==1
        for unit=(Point(2)-seed_distance(select_room,4,individual_num)):(Point(2)+seed_distance(select_room,2,individual_num))
          if Pheno(Point(1)-seed_distance(select_room,1,individual_num),unit,individual_num)==select_room
            Pheno(Point(1)-seed_distance(select_room,1,individual_num)-1,unit,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //East
      if Direction_flag(select_room,2)==1 & select_dir==2
        for unit=Point(1)-seed_distance(select_room,1,individual_num):Point(1)+seed_distance(select_room,3,individual_num)
          if Pheno(unit,Point(2)+seed_distance(select_room,2,individual_num),individual_num)==select_room
            Pheno(unit,Point(2)+seed_distance(select_room,2,individual_num)+1,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //South
      if Direction_flag(select_room,3)==1 & select_dir==3
        for unit=Point(2)-seed_distance(select_room,4,individual_num):Point(2)+seed_distance(select_room,2,individual_num)
          if Pheno(Point(1)+seed_distance(select_room,3,individual_num),unit,individual_num)==select_room
            Pheno(Point(1)+seed_distance(select_room,3,individual_num)+1,unit,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //West
      if Direction_flag(select_room,4)==1 & select_dir==4
        for unit=Point(1)-seed_distance(select_room,1,individual_num):Point(1)+seed_distance(select_room,3,individual_num)
          if Pheno(unit,Point(2)-seed_distance(select_room,4,individual_num),individual_num)==select_room
            Pheno(unit,Point(2)-seed_distance(select_room,4,individual_num)-1,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //North East
      if Direction_flag(select_room,1)==1 & Direction_flag(select_room,2)==1 ..
        & Pheno(Point(1)-seed_distance(select_room,1,individual_num)-1,Point(2)+seed_distance(select_room,2,individual_num)+1,individual_num)==0
        Pheno(Point(1)-seed_distance(select_room,1,individual_num)-1,Point(2)+seed_distance(select_room,2,individual_num)+1,individual_num)=select_room;
      end
      //South East
      if Direction_flag(select_room,3)==1 & Direction_flag(select_room,2)==1 ..
        & Pheno(Point(1)+seed_distance(select_room,3,individual_num)+1,Point(2)+seed_distance(select_room,2,individual_num)+1,individual_num)==0
        Pheno(Point(1)+seed_distance(select_room,3,individual_num)+1,Point(2)+seed_distance(select_room,2,individual_num)+1,individual_num)=select_room;
      end
      //South West
      if Direction_flag(select_room,3)==1 & Direction_flag(select_room,4)==1 ..
        & Pheno(Point(1)+seed_distance(select_room,3,individual_num)+1,Point(2)-seed_distance(select_room,4,individual_num)-1,individual_num)==0
        Pheno(Point(1)+seed_distance(select_room,3,individual_num)+1,Point(2)-seed_distance(select_room,4,individual_num)-1,individual_num)=select_room;
      end
      //North West
      if Direction_flag(select_room,1)==1 & Direction_flag(select_room,4)==1 ..
        & Pheno(Point(1)+seed_distance(select_room,3,individual_num)+1,Point(2)-seed_distance(select_room,4,individual_num)-1,individual_num)==0
        Pheno(Point(1)-seed_distance(select_room,1,individual_num)-1,Point(2)-seed_distance(select_room,4,individual_num)-1,individual_num)=select_room;
      end  
    end // 成長条件
  end //while
end //individual_num

// 0(void space)->11(void space)
for individual_num=1:individuals
  for y=2:y_span+1
    for x=2:x_span+1
      if Pheno(x,y,individual_num)==0
        Pheno(x,y,individual_num)=11;
      end
    end
  end
end

endfunction
