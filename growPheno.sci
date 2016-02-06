function growPheno

global individuals rooms x_span y_span rooms Geno Pheno Desirable_area

//フェノタイプ（表現型）雛形の作成
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
Pheno=zeros(x_span+2,y_span+2,individuals);
Pheno(1,1:y_span+2,:)=8,Pheno(x_span+2,2:y_span+1,:)=9;
Pheno(2:x_span+2,1,:)=10;
Pheno(2:x_span+2,y_span+2,:)=10;

end_flag=0; // 成長をやめることを判断するフラグ
//Direction_flag=zeros(rooms,4); // 部屋、方向ごとに成長するかを判断するフラグ
seed_distance=zeros(rooms,4,individuals); // 種から部屋の端までの距離
growth_area=zeros(rooms,4,individuals); // 各方向ごとに成長できるエリアの面積

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
  while end_flag==0
    Direction_flag=zeros(rooms,4); // 部屋、方向ごとに成長するかを判断するフラグ
    room_flag=zeros(rooms); // 部屋単位で成長できるかを判断するフラグ(Direction_flagが一つでも立てばこれも立つ)
    select_prob=zeros(rooms,individuals); // 選択確率計算に必要
    room_available=zeros(rooms,individuals); // 選択確率計算に必要

    for room_num=1:rooms
      //Point means coordinate of seed
      Point=Geno(room_num,1:2,individual_num);
      //there is overlap problem on next line
      Pheno(Point(1),Point(2),individual_num)=room_num;
      for direction_num=1:4
        //種から各方向のエリア端までの距離(seed_distance)を計算
        //North
        while 1
          if Point(1)-seed_distance(1)>=1 // エリアをはみ出さないかチェック
            if Pheno(Point(1)-seed_distance(1),Point(2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
              seed_distance(1)=seed_distance(1)+1;
            else //debug: elseがうまく対応していないかも（自動インデントがおかしかった．単にeditorの問題？）
              break;
            end //if
          else //if エリアをはみ出す
            break;
          end//if
        end //North
        //East
        while 1
          if Point(2)+seed_distance(2)<=y_span // エリアをはみ出さないかチェック
            if Pheno(Point(1),Point(2)+seed_distance(2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
              seed_distance(2)=seed_distance(2)+1;
            else //debug: elseがうまく対応していないかも（自動インデントがおかしかった．単にeditorの問題？）
              break;
            end // if
          else //if エリアをはみ出す
            break;
          end//if
        end //East
        //South
        while 1
          if Point(1)+seed_distance(3)<=x_span// エリアをはみ出さないかチェック
            if Pheno(Point(1)+seed_distance(3),Point(2),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
              seed_distance(3)=seed_distance(3)+1;
            else //debug: (（自動インデントがおかしかった．単にeditorの問題？）
              break;
            end //if
          else //if エリアをはみ出す
            break;
          end//if
        end //South
        //West
        while 1
          if Point(2)-seed_distance(4)>=1// エリアをはみ出さないかチェック
            if Pheno(Point(1),Point(2)-seed_distance(4),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
              seed_distance(4)=seed_distance(4)+1;
            else //debug: elseがうまく対応していないかも（自動インデントがおかしかった．単にeditorの問題？）
              break;
            end //if
          else //if エリアをはみ出す
            break;
          end//if
        end //West
      
        //成長可能エリアを計算
        count=1;
        //North
        while 1
          for unit=Point(2)-seed_distance(4):Point(2)+seed_distance(2) // 成長と垂直方向、範囲をはみ出すことはないはず
            if Point(1)-seed_distance(1)-count>=1 // 成長方向、エリアはみ出さない（成長方向）なら
              if Pheno(Point(1)-seed_distance(1)-count,unit,individual_num)~=0
                break;break;
              end
            else
              break;break;
            end
          end //for
          growth_area=growth_area+(seed_distance(4)+seed_distance(2)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end //North
        //East
        count=1;
        while 1
          for unit=Point(1)-seed_distance(1):Point(1)+seed_distance(3)// 成長と垂直方向、範囲をはみ出すことはないはず
            if Point(2)+seed_distance(2)+count<=y_span // エリアはみ出さない（成長方向）なら
              if Pheno(unit,Point(2)+seed_distance(2)+count,individual_num)~=0
                break;break;
              end
            else
              break;break;
            end
          end //for
          growth_area=growth_area+(seed_distance(1)+seed_distance(3)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end //East
        //South
        count=1;
        while 1
          for unit=Point(2)-seed_distance(4):Point(2)+seed_distance(2)// 成長と垂直方向、範囲をはみ出すことはないはず
            if Point(1)+seed_distance(3)+count<=x_span // エリアはみ出さない（成長方向）なら
              if Pheno(Point(1)+seed_distance(3)+count,unit,individual_num)~=0
                break;break;
              end
            else
              break;break;
            end
          end //for
          growth_area=growth_area+(seed_distance(4)+seed_distance(2)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end //South
        //West
        count=1;
        while 1
          for unit=Point(1)-seed_distance(1):Point(1)+seed_distance(3)// 成長と垂直方向、範囲をはみ出すことはないはず
            if Point(2)-seed_distance(4)-count>=1 // エリアはみ出さない（成長方向）なら
              if Pheno(unit,Point(2)-seed_distance(4)-count,individual_num)~=0
                break;break;
              end
            else
              break;break;
            end
          end //for
          growth_area=growth_area+(seed_distance(1)+seed_distance(3)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end //West
      end //direction_num
    end //room_num
    
    // 成長できる部屋、方向にフラグを立てる
    for room_num=1:rooms
      for direction_num=1:4
        if (growth_area(room_num,direction_num,individual_num)~=0) & (Direction_flag(room_num,direction_num)==0)
          Direction_flag(room_num,direction_num)=1;
          room_flag(room_num)=1; //debug: overloadの問題
        end //if
      end //direction_num
    end //room_num

    //選択確率計算
    for room_num=1:rooms // 成長できない部屋を除外
      if room_flag(room_num)==1
        room_available(room_num,individual_num) = Desirable_area(room_num);
      end//if
    end
    for room_num=1:rooms // 選択確率を計算
      select_prob(room_num,individual_num) = (room_available(room_num,individual_num)/sum(room_available))+select_prob(room_num,individual_num);
    end
  
    //選択
    rand_num=rand();//0~1の一様分布乱数
    for room_num=1:rooms
      if rand_num<=select_prob(room_num)
        select_num=room_num;
      else
        break
      end
    end

    //成長
    room_num=select_num
    //North
    if Direction_flag(room_num,1)==1
      for unit=Point(2)-seed_distance(4):Point(2)+seed_distance(2)
        Pheno(Point(1)-seed_distance(1),unit,individual_num)=room_num;
      end
    end // if Direction_flag
    //East
    if Direction_flag(room_num,2)==1
      for unit=Point(1)-seed_distance(1):Point(1)+seed_distance(3)
        Pheno(unit,Point(2)+seed_distance(2),individual_num)=room_num;
      end
    end // if Direction_flag
    //South
    if Direction_flag(room_num,3)==1
      for unit=Point(2)-seed_distance(4):Point(2)+seed_distance(2)
        Pheno(Point(1)+seed_distance(3),unit,individual_num)=room_num;
      end
    end // if Direction_flag
    //West
    if Direction_flag(room_num,4)==1
      for unit=Point(1)-seed_distance(1):Point(1)+seed_distance(3)
        Pheno(unit,Point(2)-seed_distance(4),individual_num)=room_num;
      end
    end // if Direction_flag
    //North Eeast
    if Direction_flag(room_num,1)==1 & Direction_flag(room_num,2)==1
      Pheno(Point(1)-seed_distance(1)-1,Point(2)+seed_distance(2)+1,individual_num)=room_num;
    end
    //South Eeast
    if Direction_flag(room_num,3)==1 & Direction_flag(room_num,2)==1
      Pheno(Point(1)+seed_distance(3)+1,Point(2)+seed_distance(2)+1,individual_num)=room_num;
    end
    //South West
    if Direction_flag(room_num,3)==1 & Direction_flag(room_num,4)==1
      Pheno(Point(1)+seed_distance(3)+1,Point(2)-seed_distance(4)-1,individual_num)=room_num;
    end
    //North West
    if Direction_flag(room_num,1)==1 & Direction_flag(room_num,4)==1
      Pheno(Point(1)-seed_distance(1)-1,Point(2)-seed_distance(4)-1,individual_num)=room_num;
    end  
    //終了判定
    end_flag=1;
    for room_num=1:rooms
      if room_flag(room_num)~=0
        end_flag=0;
      end
    end
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
