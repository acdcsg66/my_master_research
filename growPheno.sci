function growPheno
  
// 2016/02/17 （目標面積－現在面積）により部屋の選択確率を決定（方向は成長できる4方向すべて＋斜め方向、成長速度を可変に　例：左が成長できないなら右を2倍成長させる）

global individuals rooms x_span y_span rooms Geno Pheno Desirable_area
//room_prob room_available seed_distance growth_area seed_distance ..
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
end_flag=0; //成長を止めるためのフラグ
room_prob=zeros(rooms,individuals); // 選択確率、目標面積を超過していない部屋はこちらの群＝A群
room_excd_prob=zeros(rooms,individuals); // 選択確率、目標面積を超過した部屋はこちらの群＝B群
room_available=zeros(rooms,individuals); // 選択確率計算に必要（A群）
room_excd=zeros(rooms,individuals); // 選択確率計算に必要（B群）
growth_area=zeros(rooms,4,individuals); // 各方向ごとに成長できるエリアの面積
growth_count=ones(rooms,4); // 各方向ごとに成長できる回数、計算の都合上1で初期化。計算結果も1大きくなってしまうのであとでマイナス1して帳尻を合わせている
growth_num=zeros(1,4); // 各方向（1上2右3下4左）ごとに成長させる回数を決定（ここで指定された分だけ成長する）

dir_prob=zeros(4,individuals); // 方向選択に必要、部屋が変わるごとに更新

seed_distance=zeros(rooms,4,3,individuals); // 種から部屋の端までの距離、たぶん毎回ゼロで更新する必要はなし（増えていくだけ）

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
    growth_count(:,:)=1;
    growth_num(1,:)=0;
    Direction_flag(:,:,individual_num)=0;
    room_flag(:,individual_num)=0;
    room_prob(:,individual_num)=0;
    room_excd_prob(:,individual_num)=0;
    room_available(:,individual_num)=0;
    room_excd(:,individual_num)=0;
    for room_num=1:rooms
      dir_prob(:,:)=0;
      //種から各方向のエリア端までの距離(seed_distance)を計算
      // □③①②□□□
      // □■①■□他□
      // □■①■□□□
      // ②■■■■■■③　1→2→3と時計回りで
      // ①①種①①①①①
      // ③■①■■■■②
      // ③■①■■■■②
      // ③■①■■■■②
      // □■①■■■■②
      // □■①■■□□□
      // □■①■■□□□
      // 　■①■■□他□
      // 　②①③③
      common_flag=0;
      //North①
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-1,Point(room_num,2,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,1,1,individual_num)=seed_distance(room_num,1,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //North①
      common_flag=0;
      //North②
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,1,2,individual_num)+1<=y_span+2 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num), ..
          Point(room_num,2,individual_num)+seed_distance(room_num,1,2,individual_num)+1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,1,2,individual_num)=seed_distance(room_num,1,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //North②
      common_flag=0;
      //North③
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,1,3,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num), ..
          Point(room_num,2,individual_num)-seed_distance(room_num,1,3,individual_num)-1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,1,3,individual_num)=seed_distance(room_num,1,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //North③
      common_flag=0;
      //East①
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+1<=y_span+2 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,2,1,individual_num)=seed_distance(room_num,2,1,individual_num)+1;
          else
            common_flag=1;
          end // if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //East①
      common_flag=0;
      //East②
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,2,2,individual_num)+1<=x_span+2 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,2,2,individual_num)+1, ..
          Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,2,2,individual_num)=seed_distance(room_num,2,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //East②
      common_flag=0;
      //East③
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,2,3,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,2,3,individual_num)-1, ..
          Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,2,3,individual_num)=seed_distance(room_num,2,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //East③
      common_flag=0;
      //South①
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1<=x_span+2// 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1,Point(room_num,2,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,3,1,individual_num)=seed_distance(room_num,3,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //South①
      common_flag=0;
      //South②
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,3,2,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num), ..
          Point(room_num,2,individual_num)-seed_distance(room_num,3,2,individual_num)-1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,3,2,individual_num)=seed_distance(room_num,3,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //South②
      common_flag=0;
      //South③
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,3,3,individual_num)+1<=y_span+2 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num), ..
          Point(room_num,2,individual_num)+seed_distance(room_num,3,3,individual_num)+1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,3,3,individual_num)=seed_distance(room_num,3,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //South③
      common_flag=0;
      //West①
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-1,individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,4,1,individual_num)=seed_distance(room_num,4,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //West①
      common_flag=0;
      //West②
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,4,2,individual_num)-1>=1 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,4,2,individual_num)-1, ..
          Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,4,2,individual_num)=seed_distance(room_num,4,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //West②
      common_flag=0;
      //West③
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,4,3,individual_num)+1<=x_span+2 // 全体のエリアをはみ出さないかチェック
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,4,3,individual_num)+1, ..
          Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num),individual_num)==room_num // 部屋のエリア内であればseed_distanceを加算していく
            seed_distance(room_num,4,3,individual_num)=seed_distance(room_num,4,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if エリアをはみ出す
          common_flag=1;
        end//if
      end //West③

      //成長可能エリアを計算
      common_flag=0;
      //North
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,1,3,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,1,2,individual_num) // 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-growth_count(room_num,1)>=1 // 成長方向、エリアはみ出さない（成長方向）なら
            if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-growth_count(room_num,1),unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-growth_count(room_num,1),unit,individual_num)~=11 // スペースが空白じゃないならフラグを立ててループを抜ける
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,1,individual_num)=growth_area(room_num,1,individual_num)+(seed_distance(room_num,1,3,individual_num)+seed_distance(room_num,1,2,individual_num)+1); // 一片の長さ、+1=種のセル
          growth_count(room_num,1)=growth_count(room_num,1)+1;
        end
      end //North
      common_flag=0;
      //East
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,2,3,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,2,2,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+growth_count(room_num,2)<=y_span+2 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+growth_count(room_num,2),individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+growth_count(room_num,2),individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,2,individual_num)=growth_area(room_num,2,individual_num)+(seed_distance(room_num,2,3,individual_num)+seed_distance(room_num,2,2,individual_num)+1); // 一片の長さ、+1=種のセル
          growth_count(room_num,2)=growth_count(room_num,2)+1;
        end
      end //East
      common_flag=0;
      //South
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,3,2,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,3,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+growth_count(room_num,3)<=x_span+2 // エリアはみ出さない（成長方向）なら
            if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+growth_count(room_num,3),unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+growth_count(room_num,3),unit,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,3,individual_num)=growth_area(room_num,3,individual_num)+(seed_distance(room_num,3,2,individual_num)+seed_distance(room_num,3,3,individual_num)+1); // 一片の長さ、+1=種のセル
          growth_count(room_num,3)=growth_count(room_num,3)+1;
        end
      end //South
      common_flag=0;
      //West
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,4,2,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,4,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-growth_count(room_num,4)>=1 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-growth_count(room_num,4),individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-growth_count(room_num,4),individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,4,individual_num)=growth_area(room_num,4,individual_num)+(seed_distance(room_num,4,2,individual_num)+seed_distance(room_num,4,3,individual_num)+1); // 一片の長さ、+1=種のセル
          growth_count(room_num,4)=growth_count(room_num,4)+1;
        end
      end //West
      common_flag=0;
      growth_count(room_num,:)=growth_count(room_num,:)-1;
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
          if Desirable_area(room_num)- ..
          ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
          - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
          - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
          - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
          - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num))) ..
          > 0 // 現在の部屋の面積が目標面積を超過していなければA群に入れる、目標面積に足りないほど選ばれて成長しやすい
            room_available(room_num,individual_num) = Desirable_area(room_num)- ..
            ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
            - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
            - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num)));
          else // 目標面積を超過していたらB群に入れる、超過している分だけ選ばれにくくする
            if ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
            - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
            - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num))) ..
            - Desirable_area(room_num) == 0 // 計算式分母が0になるときの例外処理
              room_excd(room_num,individual_num) = 1;
            else
              room_excd(room_num,individual_num) =  1 / ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
            - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
            - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num)) ..
            - Desirable_area(room_num)); // 超過面積の逆数をルーレットの大きさとして代入
            end
          end
        else
          room_available(room_num,individual_num) = 0;
          room_excd(room_num,individual_num) = 0;
        end//room_flagのif
      end
      room_sum=0;
      room_sum2=0;
      for room_num=1:rooms // 選択確率を計算、ルーレット選択
        if room_available(room_num,individual_num)~=0
          room_sum = room_available(room_num,individual_num)/sum(room_available(1:rooms,individual_num))+ room_sum;
          room_prob(room_num,individual_num) = room_sum;
        else
          room_prob(room_num,individual_num) = 0;
        end
        if room_excd(room_num,individual_num)~=0
          room_sum2 = room_excd(room_num,individual_num)/sum(room_excd(1:rooms,individual_num))+ room_sum2;
          room_excd_prob(room_num,individual_num) = room_sum2;
        else
          room_excd_prob(room_num,individual_num) = 0;
        end
      end

      //部屋選択
      A_flag=0;
      for room_num=1:rooms
        if room_available(room_num,individual_num) ~=0 // 目標面積に達していない部屋が一つでもあればそれら(A群=room_available)から選ぶ
          A_flag = 1;
        end
      end
      select_room=0;
      rand_num=rand();//0~1の一様分布乱数
      room_num=1;
      //A群またはB群からルーレット選択 A群…まだ目標面積を超過していない部屋群　B群…すでに目標面積を超過した部屋群
      if A_flag == 1
        while select_room==0 //A群
          if rand_num<=room_prob(room_num,individual_num)
            select_room=room_num;
          else
            room_num=room_num+1;
          end
        end
      else
        while select_room==0 //B群
          if rand_num<=room_excd_prob(room_num,individual_num)
            select_room=room_num;
          else
            room_num=room_num+1;
          end
        end
      end

      //方向ごとに成長数決定
      grow=4;
      // まずはじめに成長できる方向に1回ずつ成長を配分
      //上
      if growth_count(select_room,1)>=1
        growth_num(1,1)=1;
        grow=grow-1;
      end
      if growth_count(select_room,2)>=1
        growth_num(1,2)=1;
        grow=grow-1;
      end
      if growth_count(select_room,3)>=1
        growth_num(1,3)=1;
        grow=grow-1;
      end
      if growth_count(select_room,4)>=1
        growth_num(1,4)=1;
        grow=grow-1;
      end
      //残ったgrowが自由に成長可能数を割り振れるパラメータ、正方形を優先（左が成長できないなら右、上が成長できないなら下、もしくはそれぞれの逆）→無理なら候補からrandom、max、min
      //正方形
      //下が成長できないなら上
      if growth_count(select_room,1)>=2 & growth_count(select_room,3)==0
        growth_num(1,1)=growth_num(1,1)+1;
        grow=grow-1;
      end
      //左が成長できないなら右
      if growth_count(select_room,2)>=2 & growth_count(select_room,4)==0
        growth_num(1,2)=growth_num(1,2)+1;
        grow=grow-1;
      end
      //上が成長できないなら下
      if growth_count(select_room,3)>=2 & growth_count(select_room,1)==0
        growth_num(1,3)=growth_num(1,3)+1;
        grow=grow-1;
      end
      //右が成長できないなら左
      if growth_count(select_room,4)>=2 & growth_count(select_room,2)==0
        growth_num(1,4)=growth_num(1,4)+1;
        grow=grow-1;
      end
//pause
      
      dir_factor(1,1:4)=0;//方向をランダム選択するときに使用。4方向についてまだ成長できるなら1、できないなら0。成長方向が決まるたびに更新
      for dir_num=1:4
        if growth_count(select_room,dir_num)-growth_num(1,dir_num)>0
          dir_factor(1,dir_num)=1;
        end
      end
      // 成長を完全に配分し終わっていない　かつ　まだ成長できる部屋がある　間、ループ
      while grow>=1 & (growth_count(select_room,1)-growth_num(1,1)>0 | growth_count(select_room,2)-growth_num(1,2)>0 ..
      | growth_count(select_room,3)-growth_num(1,3)>0 | growth_count(select_room,4)-growth_num(1,4)>0)
        //成長可能エリア最大の方向を選ぶ
        //select_dir=0;
        //max_growth=0;
        //for dir_count=1:4
        //  if growth_count(select_room,dir_count)-growth_num(1,dir_count)>0 .. // 成長可能かチェック＆現時点の成長可能面積が最大の方向を選択
        //  & (growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1) > max_growth
        //    max_growth=(growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1);
        //    select_dir=dir_count;
        //  end
        //end
        //growth_num(1,select_dir)=growth_num(1,select_dir)+1;
        //grow=grow-1;

        //最小、成長可能エリアがゼロの方向を除外
        select_dir=0;
        min_growth=100000; //適当に大きな数
        for dir_count=1:4
          if growth_count(select_room,dir_count)-growth_num(1,dir_count)>0 .. // 成長可能かチェック＆現時点の成長可能面積が最小の方向を選択
          & (growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1) < min_growth
            min_growth=(growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1);
            select_dir=dir_count;
          end
        end
        growth_num(1,select_dir)=growth_num(1,select_dir)+1;
        grow=grow-1;
        
        //ランダムに方向を選択
        //dir_sum=0;
        //for dir_num=1:4
        //  if growth_count(select_room,dir_num)-growth_num(1,dir_num)>0 //成長可能かチェック＆ルーレット作成
        //    dir_sum=dir_factor(1,dir_num)/sum(dir_factor(1,1:4))+dir_sum;
        //    dir_prob(dir_num,individual_num) = dir_sum;
        //  else
        //    dir_prob(dir_num,individual_num) = 0;
        //  end
        //end
        //select_dir=0;
        //rand_num=rand();//0~1の一様分布乱数
        //dir_num=1;
        //while select_dir==0
        //  if rand_num<=dir_prob(dir_num,individual_num)// & dir_prob(dir_num,individual_num)~=0
        //    select_dir=dir_num;
        //  else
        //    dir_num=dir_num+1;
        //  end
        //end
        //growth_num(1,select_dir)=growth_num(1,select_dir)+1;
        //grow=grow-1;
        //if growth_count(select_room,select_dir)-growth_num(1,select_dir)<=0//成長できなくなったらその方向のdir_factorをゼロにして選択候補から外す
        //  dir_factor(1,select_dir)=0;
        //end

      end
//pause
      //成長      
      //North
      count=1;
      while growth_num(1,1)>0
        //unitは1度の成長の単位
        for unit=(Point(room_num,2,individual_num)-seed_distance(select_room,1,3,individual_num)):(Point(room_num,2,individual_num)+seed_distance(select_room,1,2,individual_num))
          //成長させて良いかチェックし、良ければ成長させる
          if Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-count+1,unit,individual_num)==select_room ..
          & Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-count,unit,individual_num)==0
            Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-count,unit,individual_num)=select_room;
          end
        end
      count=count+1;
      growth_num(1,1)=growth_num(1,1)-1;
      end
      //East
      count=1;
      while growth_num(1,2)>0
        for unit=Point(room_num,1,individual_num)-seed_distance(select_room,2,3,individual_num):Point(room_num,1,individual_num)+seed_distance(select_room,2,2,individual_num)
          if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+count-1,individual_num)==select_room ..
          & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+count,individual_num)==0
            Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+count,individual_num)=select_room;
          end
        end
      count=count+1;
      growth_num(1,2)=growth_num(1,2)-1;
      end
      //South
      count=1;
      while growth_num(1,3)>0
        for unit=Point(room_num,2,individual_num)-seed_distance(select_room,3,2,individual_num):Point(room_num,2,individual_num)+seed_distance(select_room,3,3,individual_num)
          if Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+count-1,unit,individual_num)==select_room ..
            Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+count,unit,individual_num)==0
            Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+count,unit,individual_num)=select_room;
          end
        end
      count=count+1;
      growth_num(1,3)=growth_num(1,3)-1;
      end
      //West
      count=1;
      while growth_num(1,4)>0
        for unit=Point(room_num,1,individual_num)-seed_distance(select_room,4,2,individual_num):Point(room_num,1,individual_num)+seed_distance(select_room,4,3,individual_num)
          if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-count+1,individual_num)==select_room ..
          & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-count,individual_num)==0
            Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-count,individual_num)=select_room;
          end
        end
      count=count+1;
      growth_num(1,4)=growth_num(1,4)-1;
      end
      //斜め方向の成長、以下で使われているseed_distanceは成長前のもの（まだ更新されてない）であることに注意
      for dir1=1:4
        for dir2=1:4
          //North East
          if Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1>=1 & Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2 <=y_span+2 // メモリチェック
            //成長させて良いかチェックし、良ければ成長させる
            if Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2,individual_num)==0 ..
            &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1+1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2,individual_num)==select_room ..
            &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2-1,individual_num)==select_room
              Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2,individual_num)=select_room;
            end
          end
          //South East
          if Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1<x_span+2 & Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2<=y_span+2
            if Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2,individual_num)==0 ..
            &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1-1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2,individual_num)==select_room ..
            &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2-1,individual_num)==select_room
              Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2,individual_num)=select_room;
            end
          end
          //South West
          if Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1<x_span+2 & Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2 >=1
            if Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2,individual_num)==0 ..
            &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1-1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2,individual_num)==select_room ..
            &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2+1,individual_num)==select_room
              Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+dir1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2,individual_num)=select_room;
            end
          end
          //North West
          if Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1>=1 & Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2 >=1
            if Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2,individual_num)==0 ..
            &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1+1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2,individual_num)==select_room ..
            &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2+1,individual_num)==select_room
              Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-dir2,individual_num)=select_room;
            end
          end
        end
      end
    end // 成長条件
//  pause
  end //while
//  pause
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

//それぞれの部屋の面積を数える(debug用)
//room_size_count=zeros(11,individuals);
//for individual_num=1:individuals
//  for y=2:y_span+1
//    for x=2:x_span+1
//     room_size_count(Pheno(x,y,individual_num),individual_num)=room_size_count(Pheno(x,y,individual_num),individual_num)+1;
//    end
//  end
//end
//pause

endfunction
