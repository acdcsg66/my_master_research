function growPheno

//2016_02_06 サイズ目標に応じて確率的に部屋選択、成長可能な全方向に成長
global individuals rooms x_span y_span rooms Geno Pheno Desirable_area ..
seed_distance growth_area Direction_flag select_num

//フェノタイプ（表現型）雛形の作成
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
Pheno=zeros(x_span+2,y_span+2,individuals);
Pheno(1,1:y_span+2,:)=8,Pheno(x_span+2,2:y_span+1,:)=9;
Pheno(2:x_span+2,1,:)=10;
Pheno(2:x_span+2,y_span+2,:)=10;

//end_flag=0; // 成長をやめることを判断するフラグ
//common_flag=0; //汎用フラグ
//count=1; //成長可能エリア計算用
seed_distance=zeros(rooms,4); // 種から部屋の端までの距離
growth_area=zeros(rooms,4); // 各方向ごとに成長できるエリアの面積
select_prob=zeros(rooms,1); // 選択確率計算に必要
room_available=zeros(rooms,1); // 選択確率計算に必要
Direction_flag=zeros(rooms,4); // 部屋、方向ごとに成長するかを判断するフラグ
room_flag=zeros(rooms,1); //部屋が成長できるかを判断するフラグ


//put Geno points into Pheno
for individual_num=1:individuals
  for room_num=1:rooms
    //Point means coordinate of seed
    Point=Geno(room_num,1:2,individual_num);
    //there is overlap problem on next line
    Pheno(Point(1),Point(2),individual_num)=room_num;
  end
end

for individual_num=1:individuals
  end_flag=0;
  while end_flag==0
    seed_distance=zeros(rooms,4); // 種から部屋の端までの距離、4方向
    growth_area=zeros(rooms,4); // 各方向ごとに成長できるエリアの面積
    select_prob=zeros(rooms,1); // 選択確率計算に必要
    room_available=zeros(rooms,1); // 選択確率計算に必要
    Direction_flag=zeros(rooms,4); // 部屋、方向ごとに成長するかを判断するフラグ
    room_flag=zeros(rooms,1); // 部屋単位で成長できるかを判断するフラグ(Direction_flagが一つでも立てばこれも立つ)
    //成長可能エリアのカウント
    for room_num=1:rooms
      //種から各方向のエリア端までの距離(seed_distance)を計算
      //種座標更新、seed_distanceリセット
      Point=Geno(room_num,1:2,individual_num);
      //North
      common_flag=0;
      while common_flag==0
        if Point(1)-seed_distance(room_num,1)>=1 // エリアをはみ出さないかチェック
          if Pheno(Point(1)-seed_distance(room_num,1),Point(2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,1)=seed_distance(room_num,1)+1;
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
        if Point(2)+seed_distance(room_num,2)<=y_span // エリアをはみ出さないかチェック
          if Pheno(Point(1),Point(2)+seed_distance(room_num,2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,2)=seed_distance(room_num,2)+1;
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
        if Point(1)+seed_distance(room_num,3)<=x_span// エリアをはみ出さないかチェック
          if Pheno(Point(1)+seed_distance(room_num,3),Point(2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,3)=seed_distance(room_num,3)+1;
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
        if Point(2)-seed_distance(room_num,4)>=1// エリアをはみ出さないかチェック
          if Pheno(Point(1),Point(2)-seed_distance(room_num,4),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,4)=seed_distance(room_num,4)+1;
          else //debug: elseがうまく対応していないかも（自動インデントがおかしかった．単にeditorの問題？）
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //West    
      //成長可能エリアを計算
      //North
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(2)-seed_distance(room_num,4):-1:Point(2)+seed_distance(room_num,2) // 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(1)-seed_distance(room_num,1)-count>=1 // 成長方向、エリアはみ出さない（成長方向）なら
            if Pheno(Point(1)-seed_distance(room_num,1)-count,unit,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,1)=growth_area(room_num,1)+(seed_distance(room_num,4)+seed_distance(room_num,2)+1); // 一片の長さ、+1=種のセル
        count=count+1;
      end //North
      //East
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(1)-seed_distance(room_num,1):Point(1)+seed_distance(room_num,3)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(2)+seed_distance(room_num,2)+count<=y_span // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(2)+seed_distance(room_num,2)+count,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,2)=growth_area(room_num,2)+(seed_distance(room_num,1)+seed_distance(room_num,3)+1); // 一片の長さ、+1=種のセル
        count=count+1;
      end //East
      //South
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(2)-seed_distance(room_num,4):Point(2)+seed_distance(room_num,2)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(1)+seed_distance(room_num,3)+count<=x_span // エリアはみ出さない（成長方向）なら
            if Pheno(Point(1)+seed_distance(room_num,3)+count,unit,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,3)=growth_area(room_num,3)+(seed_distance(room_num,4)+seed_distance(room_num,2)+1); // 一片の長さ、+1=種のセル
        count=count+1;
      end //South
      //West
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(1)-seed_distance(room_num,1):-1:Point(1)+seed_distance(room_num,3)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(2)-seed_distance(room_num,4)-count>=1 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(2)-seed_distance(room_num,4)-count,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,4)=growth_area(room_num,4)+(seed_distance(room_num,1)+seed_distance(room_num,3)+1); // 一片の長さ、+1=種のセル
        count=count+1;
      end //West
      count=1;
      common_flag=0;

    end //room_num
    
    // 成長できる部屋、方向にフラグを立てる
    for room_num=1:rooms
      for direction_num=1:4
        if (growth_area(room_num,direction_num)>0)
          Direction_flag(room_num,direction_num)=1;
          room_flag(room_num,1)=1; //debug: overloadの問題
        end //if
      end //direction_num
    end //room_num

    //終了判定
    end_flag=1;
    for room_num=1:rooms
      if room_flag(room_num,1)==1
        end_flag=0;
      end
    end
  
    if end_flag==0 //成長判定
      //選択確率計算
      for room_num=1:rooms // 成長できる部屋を候補にする
        if room_flag(room_num,1)==1
          room_available(room_num,1) = Desirable_area(room_num);
        end//if
      end
      for room_num=1:rooms // 選択確率を計算
        select_prob(room_num,1) ..
        = (room_available(room_num,1)/sum(room_available(:,1))) ..
          +select_prob(room_num,1);
      end
    
      //選択
      select_num=0;
      rand_num=rand();//0~1の一様分布乱数
      for room_num=1:rooms
        if rand_num<=select_prob(room_num,1)
          select_num=room_num;
        end
      end

      //成長
      room_num=select_num
      //North
      if Direction_flag(room_num,1)==1
        for unit=Point(2)-seed_distance(room_num,4):-1:Point(2)+seed_distance(room_num,2)
          Pheno(Point(1)-seed_distance(room_num,1)-1,unit,individual_num)=room_num;
        end
      end // if Direction_flag
      //East
      if Direction_flag(room_num,2)==1
        for unit=Point(1)-seed_distance(room_num,1):Point(1)+seed_distance(room_num,3)
          Pheno(unit,Point(2)+seed_distance(room_num,2)+1,individual_num)=room_num;
        end
      end // if Direction_flag
      //South
      if Direction_flag(room_num,3)==1
        for unit=Point(2)-seed_distance(room_num,4):Point(2)+seed_distance(room_num,2)
          Pheno(Point(1)+seed_distance(room_num,3)+1,unit,individual_num)=room_num;
        end
      end // if Direction_flag
      //West
      if Direction_flag(room_num,4)==1
        for unit=Point(1)-seed_distance(room_num,1):-1:Point(1)+seed_distance(room_num,3)
          Pheno(unit,Point(2)-seed_distance(room_num,4)-1,individual_num)=room_num;
        end
      end // if Direction_flag
      //North Eeast
      if Direction_flag(room_num,1)==1 & Direction_flag(room_num,2)==1
        Pheno(Point(1)-seed_distance(room_num,1)-1,Point(2)+seed_distance(room_num,2)+1,individual_num)=room_num;
      end
      //South Eeast
      if Direction_flag(room_num,3)==1 & Direction_flag(room_num,2)==1
        Pheno(Point(1)+seed_distance(room_num,3)+1,Point(2)+seed_distance(room_num,2)+1,individual_num)=room_num;
      end
      //South West
      if Direction_flag(room_num,3)==1 & Direction_flag(room_num,4)==1
        Pheno(Point(1)+seed_distance(room_num,3)+1,Point(2)-seed_distance(room_num,4)-1,individual_num)=room_num;
      end
      //North West
      if Direction_flag(room_num,1)==1 & Direction_flag(room_num,4)==1
        Pheno(Point(1)-seed_distance(room_num,1)-1,Point(2)-ssseed_distance(room_num,4)-1,individual_num)=room_num;
      end
    end //if 成長判定
end //while
pause
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
