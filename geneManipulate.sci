function geneManipulate
global x_span y_span Geno individuals Pair GenoBinary children ChildBinary ..
mutationRate rooms Child

//Genoを2進に変換
x=ceil(log2(x_span)); //ceilは小数点以下切り上げ
y=ceil(log2(y_span));
GenoBinary=zeros(individuals,(x+y)*rooms); //Genoの2進行列
GenoNoFrame=Geno-2; //枠（廊下,ベランダ,隣の壁）の分の座標を引く

for individual_num=1:individuals
  for room_num=1:rooms
    
    deca=GenoNoFrame(room_num,1,individual_num); //10進の座標を1つ格納する
    for keta=x:-1:1 //x座標
      GenoBinary(individual_num,x-(keta-1)+(x+y)*(room_num-1))=..
      int(deca/(2^(keta-1))); //大きい桁から2進に変換
      if int(deca/(2^(keta-1)))==1
        deca=deca-2^(keta-1);
      end //if
    end //for keta
    
    deca=GenoNoFrame(room_num,2,individual_num);
    for keta=y:-1:1 //y座標
      GenoBinary(individual_num,(x+y)-(keta-1)+(x+y)*(room_num-1))=..
      int(deca/(2^(keta-1)));
      if int(deca/(2^(keta-1)))==1
        deca=deca-2^(keta-1);
      end //if
    end //for keta

  end//for room_num
end//for individual_num
//End of Genoを2進に変換



//遺伝的操作（交叉，突然変異）
ketaSize=size(GenoBinary,2); //size(,2)は横方向の長さ
ChildBinary=zeros(children,ketaSize);
Child=zeros(rooms,2,children); //children=individualsならばGenoと同じ形式

child_num=1;
while child_num<=children
  fatalFlag=0; //致死フラグ

  //crossover(一様交叉)
  for keta=1:ketaSize
    //rand('seed',getdate('s'))
    if rand()<0.5
      ChildBinary(child_num,keta)=GenoBinary(Pair(child_num,1),keta);
    else
      ChildBinary(child_num,keta)=GenoBinary(Pair(child_num,2),keta);
    end // if
  end //for keta

  //mutation(突然変異)
  for keta=1:ketaSize
    //rand('seed',getdate('s'))
    if rand()<mutationRate //突然変異率以下ならビットを反転
      if ChildBinary(child_num,keta)==0
        ChildBinary(child_num,keta)=1;
      else
        ChildBinary(child_num,keta)=0;
      end //if
    end //if
  end //for keta

  //2->10 2進から10進に変換
  Child(:,:,child_num)=0;
  for room_num=1:rooms
    for keta=1:x //x座標
      bi=ChildBinary(child_num,keta+(room_num-1)*(x+y)); //2進の座標を1つ格納する
      Child(room_num,1,child_num)=Child(room_num,1,child_num)+(bi*2^(x-keta));
    end //for keta    
    for keta=1:y //y座標
      bi=ChildBinary(child_num,x+keta+(room_num-1)*(x+y)); //2進の座標を1つ格納する
      Child(room_num,2,child_num)=Child(room_num,2,child_num)+(bi*2^(y-keta));
    end //for keta
  end//for room_num
    
  //check span range? 
  for room_num=1:rooms
    if Child(room_num,1,child_num)>=x_span | Child(room_num,2,child_num)>=y_span
      fatalFlag=1;
    end
  end//for room_num
  
  //check overlap?
  for room1=1:rooms-1
    for room2=room1+1:rooms
      if Child(room1,:,child_num)==Child(room2,:,child_num)
        fatalFlag=1; //some rooms overlap
      end //if
    end //for room2
  end //for room1

  if fatalFlag==0 //no fatal
    child_num=child_num+1;
  end //if

end //while

//親と入れ替え
Geno=Child+2; //+2するのはChildの要素がは0～x_span-1，0～y_span-1だから



endfunction
