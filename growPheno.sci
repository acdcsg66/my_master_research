function growPheno
  
// 2016/02/15 （目標面積－現在面積）により部屋の選択確率を決定（方向は成長できる4方向すべて＋斜め方向）

global individuals rooms x_span y_span rooms Geno Pheno Desirable_area
//room_prob room_available seed_distance growth_area seed_distance ..
//end_flag common_flag  Direction_flag room_flag count

//実験条件を変えるため乱数の種変更
rand('seed',1)

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
room_prob=zeros(rooms,individuals); // 選択確率計算に必要
room_excd_prob=zeros(rooms,individuals); // 選択確率計算に必要、目標面積を超過した部屋はこちらの群
room_available=zeros(rooms,individuals); // 選択確率計算に必要
room_excd=zeros(rooms,individuals); // 選択確率計算に必要、目標面積を超過した超過した部屋はこちらの群
growth_area=zeros(rooms,4,individuals); // 各方向ごとに成長できるエリアの面積

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
      // ②■■■■■■③　時計回りで
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

      common_flag=0;
      //成長可能エリアを計算
      count=1;
      //North
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,1,3,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,1,2,individual_num) // 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-count>=1 // 成長方向、エリアはみ出さない（成長方向）なら
            if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-count,unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-count,unit,individual_num)~=11 // スペースが空白じゃないならフラグを立ててループを抜ける
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,1,individual_num)=growth_area(room_num,1,individual_num)+(seed_distance(room_num,1,3,individual_num)+seed_distance(room_num,1,2,individual_num)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end
      end //North
      common_flag=0;
      //East
      count=1;
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,2,3,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,2,2,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+count<=y_span+2 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+count,individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+count,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,2,individual_num)=growth_area(room_num,2,individual_num)+(seed_distance(room_num,2,3,individual_num)+seed_distance(room_num,2,2,individual_num)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end
      end //East
      common_flag=0;
      //South
      count=1;
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,3,2,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,3,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+count<=x_span+2 // エリアはみ出さない（成長方向）なら
            if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+count,unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+count,unit,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,3,individual_num)=growth_area(room_num,3,individual_num)+(seed_distance(room_num,3,2,individual_num)+seed_distance(room_num,3,3,individual_num)+1); // 一片の長さ、+1=種のセル
          count=count+1;
        end
      end //South
      common_flag=0;
      //West
      count=1;
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,4,2,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,4,3,individual_num)// 成長と垂直方向、範囲をはみ出すことはないはず
          if Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-count>=1 // エリアはみ出さない（成長方向）なら
            if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-count,individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-count,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,4,individual_num)=growth_area(room_num,4,individual_num)+(seed_distance(room_num,4,2,individual_num)+seed_distance(room_num,4,3,individual_num)+1); // 一片の長さ、+1=種のセル
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
          if Desirable_area(room_num)- ..
          ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
          - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
          - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
          - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
          - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num))) ..
          > 0 // 現在の部屋の面積が目標に達していなければ
            room_available(room_num,individual_num) = Desirable_area(room_num)- ..
            ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
            - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
            - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num)));
          else // 目標面積を超過していたら超過している分だけ選ばれにくくする
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
            - Desirable_area(room_num)); // 超過面積の逆数
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
      //A群またはB群からルーレット選択
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

      //方向選択はなし（成長できる4方向全て+斜めに成長）
      
      //成長      
      //North
      if Direction_flag(select_room,1,individual_num)==1
        for unit=(Point(room_num,2,individual_num)-seed_distance(select_room,1,3,individual_num)):(Point(room_num,2,individual_num)+seed_distance(select_room,1,2,individual_num))
          if Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num),unit,individual_num)==select_room .. //debug: たぶんこの条件いらない
          & Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,unit,individual_num)==0
            Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,unit,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //East
      if Direction_flag(select_room,2,individual_num)==1
        for unit=Point(room_num,1,individual_num)-seed_distance(select_room,2,3,individual_num):Point(room_num,1,individual_num)+seed_distance(select_room,2,2,individual_num)
          if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num),individual_num)==select_room ..
          & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)==0
            Pheno(unit,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //South
      if Direction_flag(select_room,3,individual_num)==1
        for unit=Point(room_num,2,individual_num)-seed_distance(select_room,3,2,individual_num):Point(room_num,2,individual_num)+seed_distance(select_room,3,3,individual_num)
          if Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num),unit,individual_num)==select_room ..
            Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,unit,individual_num)==0
            Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,unit,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //West
      if Direction_flag(select_room,4,individual_num)==1
        for unit=Point(room_num,1,individual_num)-seed_distance(select_room,4,2,individual_num):Point(room_num,1,individual_num)+seed_distance(select_room,4,3,individual_num)
          if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num),individual_num)==select_room ..
          & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)==0
            Pheno(unit,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)=select_room;
          end
        end
      end // if Direction_flag
      //North East
      if Direction_flag(select_room,1,individual_num)==1 & Direction_flag(select_room,2,individual_num)==1 ..
      &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)==0 ..
      &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num),Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)==select_room ..
      &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num),individual_num)==select_room
        Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)=select_room;
      end
      //South East
      if Direction_flag(select_room,3,individual_num)==1 & Direction_flag(select_room,2,individual_num)==1 ..
      &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)==0 ..
      &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num),Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)==select_room ..
      &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num),individual_num)==select_room
        Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+1,individual_num)=select_room;
      end
      //South West
      if Direction_flag(select_room,3,individual_num)==1 & Direction_flag(select_room,4,individual_num)==1 ..
      &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)==0 ..
      &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num),Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)==select_room ..
      &Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num),individual_num)==select_room
        Pheno(Point(room_num,1,individual_num)+seed_distance(select_room,3,1,individual_num)+1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)=select_room;
      end
      //North West
      if Direction_flag(select_room,1,individual_num)==1 & Direction_flag(select_room,4,individual_num)==1 ..
      &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)==0 ..
      &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num),Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)==select_room ..
      &Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num),individual_num)==select_room
        Pheno(Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-1,Point(room_num,2,individual_num)-seed_distance(select_room,4,1,individual_num)-1,individual_num)=select_room;
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
