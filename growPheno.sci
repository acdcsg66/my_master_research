function growPheno

// 2016/02/11 部屋を目標面積に比例して選択＆成長させる、成長の方向は成長可能なエリアが最小or最大な方へ

global individuals rooms x_span y_span rooms Geno Pheno Desirable_area
//select_prob room_available seed_distance growth_area seed_distance ..
//end_flag common_flag  Direction_flag room_flag count

//フェノタイプ（表現型）雛形の作成
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
Pheno=zeros(x_span+2,y_span+2,individuals);
Pheno(1,1:y_span+2,:)=8,Pheno(x_span+2,2:y_span+1,:)=9;
Pheno(2:x_span+2,1,:)=10;
Pheno(2:x_span+2,y_span+2,:)=10;

//end_flag=0; // 成長をやめることを判断するフラグ
//common_flag=0; // 汎用フラグ

//debug: 実際にindividualで分けないといけないのはPoint、Phenoだけ？
Direction_flag=zeros(rooms,4,individuals); // 部屋、方向ごとに成長するかを判断するフラグ
room_flag=zeros(rooms,individuals); // 部屋単位で成長できるかを判断するフラグ(Direction_flagが一つでも立てばこれも立つ)
end_flag=0;
select_prob=zeros(rooms,individuals); // 選択確率計算に必要
room_available=zeros(rooms,individuals); // 選択確率計算に必要
growth_area=zeros(rooms,4,individuals); // 各方向ごとに成長できるエリアの面積

dir_prob=zeros(4,individuals); // 方向選択に必要、部屋が変わるごとに更新

seed_distance=zeros(rooms,4,individuals); // 種から部屋の端までの距離、たぶん毎回ゼロで更新する必要はなし

Point=zeros(rooms,2,individuals); // 種のx軸、y軸座標、ここでは更新必要なし

//put Geno points into Pheno
for individual_num=1:individuals
  for room_num=1:rooms
    //Point means coordinate of seed
    Point(room_num,:,individual_num)=Geno(room_num,1:2,individual_num);
    //there is overlap problem on next line
    Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num),individual_num)=room_num;
  end
end

//成長可能エリアのカウント
for individual_num=1:individuals
  end_flag=0;
  while end_flag==0
    //リセット
    growth_area(:,:,individual_num)=0;
    Direction_flag(:,:,individual_num)=0;
    room_flag(:,individual_num)=0;
    select_prob(:,individual_num)=0;
    room_available(:,individual_num)=0;
    for room_num=1:rooms
      dir_prob(:,:)=0;
      //種から各方向のエリア端までの距離(seed_distance)を計算
      common_flag=0;
      //North
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-1,Point(room_num,2,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,1,individual_num)=seed_distance(room_num,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //North
      common_flag=0;
      //East
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+1<=y_span+2 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,2,individual_num)=seed_distance(room_num,2,individual_num)+1;
          else
            common_flag=1;
          end // if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //East
      common_flag=0;
      //South
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1<=x_span+2// 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1,Point(room_num,2,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,3,individual_num)=seed_distance(room_num,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //South
      common_flag=0;
      //West
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,4,individual_num)=seed_distance(room_num,4,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //West
      common_flag=0;
      
      //成長可能エリアを計算
      count=1;
      //North
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num) // 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-count>=1 // 成長方向、エリアはみ出さない（成長方向）なら
            if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-count,unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-count,unit,individual_num)~=11 // スペースが空白じゃないならフラグを立ててループを抜ける
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
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+count<=y_span+2 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+count,individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+count,individual_num)~=11
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
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+count<=x_span+2 // エリアはみ出さない（成長方向）なら
            if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+count,unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+count,unit,individual_num)~=11
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
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-count>=1 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-count,individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-count,individual_num)~=11
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
        if growth_area(room_num,direction_num,individual_num)>0 
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
      room_num=1;
      while select_room==0
        if rand_num<=select_prob(room_num,individual_num)// & select_prob(room_num,individual_num)~=0
          select_room=room_num;
        else
          room_num=room_num+1;
        end
      end
//      for room_num=1:rooms
//        if rand_num>=select_prob(room_num,individual_num) & select_prob(room_num,individual_num)~=0
//          select_room=room_num;
//        end
//      end
//pause

      //方向選択 成長エリアが最大or最小を選択。
      //最大、仕様で部屋番号＝添え字だけでなく部屋の大きさも代入しないといけないみたい
      //[dir_size,select_dir]=maxi(growth_area(select_room,1:4,individual_num));

      //最小、ゼロを除外しないとダメなので個別に
      select_dir=0;
      min_growth=100000; //適当に大きな数
      for dir_count=1:4
        if growth_area(select_room,dir_count,individual_num)~=0 ..
        & growth_area(select_room,dir_count,individual_num) < min_growth
          select_dir=dir_count;
        end
      end

      //成長      
      //North
      if Direction_flag(select_room,1,individual_num)==1 & select_dir==1
        for unit=(Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num)):(Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num))
          if Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num),unit,individual_num)==select_room ..
          & Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num)-1,unit,individual_num)==0
            Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num)-1,unit,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //East
      if Direction_flag(select_room,2,individual_num)==1 & select_dir==2
        for unit=Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num):Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)
          if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num),individual_num)==select_room ..
          & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num)+1,individual_num)==0
            Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num)+1,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //South
      if Direction_flag(select_room,3,individual_num)==1 & select_dir==3
        for unit=Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num):Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num)
          if Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num),unit,individual_num)==select_room ..
            Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)+1,unit,individual_num)==0
            Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)+1,unit,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //West
      if Direction_flag(select_room,4,individual_num)==1 & select_dir==4
        for unit=Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num):Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)
          if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num),individual_num)==select_room ..
          & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num)-1,individual_num)==0
            Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num)-1,individual_num)=select_room;
          end
        end
      end // if Direction_flag
//      //North East
//      if Direction_flag(select_room,1,individual_num)==1 & Direction_flag(select_room,2,individual_num)==1 ..
//       & Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num)-1,Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num)+1,individual_num)==0
//        Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num)-1,Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num)+1,individual_num)=select_room;
//      end
//      //South East
//      if Direction_flag(select_room,3,individual_num)==1 & Direction_flag(select_room,2,individual_num)==1 ..
//        & Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)+1,Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num)+1,individual_num)==0
//        Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)+1,Point(room_num,2,individual_num)+seed_distance(select_room,2,individual_num)+1,individual_num)=select_room;
//      end
//      //South West
//      if Direction_flag(select_room,3,individual_num)==1 & Direction_flag(select_room,4,individual_num)==1 ..
//        & Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)+1,Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num)-1,individual_num)==0
//        Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)+1,Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num)-1,individual_num)=select_room;
//      end
//      //North West
//      if Direction_flag(select_room,1,individual_num)==1 & Direction_flag(select_room,4,individual_num)==1 ..
//        & Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,individual_num)+1,Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num)-1,individual_num)==0
//        Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,individual_num)-1,Point(room_num,2,individual_num)-seed_distance(select_room,4,individual_num)-1,individual_num)=select_room;
//      end  
    end // 成長条件
//  pause
  end //while
//  pause
end //individual_num

//pause

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

//それぞれの部屋の面積を数える(debug用)
room_size_count=zeros(11,individuals);
for individual_num=1:individuals
  for y=2:y_span+1
    for x=2:x_span+1
     room_size_count(Pheno(x,y,individual_num),individual_num)=room_size_count(Pheno(x,y,individual_num),individual_num)+1;
    end
  end
end
pause


endfunction
