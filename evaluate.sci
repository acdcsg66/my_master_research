function evaluate
global rooms individuals y_span x_span Pheno objectives Objective generation_num sample_num

ProportionWeight=[0.75,0.5,1,1,1,0.25,0];//LR,DK,BR1,BR2,BR3,WA,Path
//No Zero except for Path!

//Area Size
Desirable_area=[20,16,12,12,12,9,1];//LR,DK,BR1,BR2,BR3,WA,Path
//max_area=x_span*y_span;
Area=zeros(rooms,2,individuals);//2=>area,score
//area size count
for individual_num=1:individuals
  for y=2:y_span+1
    for x=2:x_span+1
      if Pheno(x,y,individual_num)~=11 //11=void
        Area(Pheno(x,y,individual_num),1,individual_num)=..
        Area(Pheno(x,y,individual_num),1,individual_num)+1;
      end
    end
  end
end
//score
for individual_num=1:individuals
  for room_num=1:rooms
    //0~-10%
    if Area(room_num,1,individual_num)<Desirable_area(room_num)*0.90
      Area(room_num,2,individual_num)=..
      Area(room_num,1,individual_num)/(Desirable_area(room_num)*0.90);
    
    //-10%~+10%
    elseif Area(room_num,1,individual_num)<Desirable_area(room_num)*1.10
      Area(room_num,2,individual_num)=1;
    
    //+10%~
    else
      Area(room_num,2,individual_num)=..
      ((x_span*y_span)-Area(room_num,1,individual_num))/..
      ((x_span*y_span)-Desirable_area(room_num)*1.10);
      //(x_span*y_span)=max of area size
    end //if
  end
end
//end of Area



//rooms' ranges for proportion
Range=ones(rooms,4,individuals);//4=x_min,x_max,y_min,y_max
for room_num=1:rooms
  Range(room_num,1,:)=x_span+2;
  Range(room_num,3,:)=y_span+2;
end
for individual_num=1:individuals
  for y=2:y_span+1
    for x=2:x_span+1
      if Pheno(x,y,individual_num)~=11 & ..
      Range(Pheno(x,y,individual_num),1,individual_num)>x
        Range(Pheno(x,y,individual_num),1,individual_num)=x;
      end
      if Pheno(x,y,individual_num)~=11 & ..
      Range(Pheno(x,y,individual_num),2,individual_num)<x
        Range(Pheno(x,y,individual_num),2,individual_num)=x;
      end
      if Pheno(x,y,individual_num)~=11 & ..
      Range(Pheno(x,y,individual_num),3,individual_num)>y
        Range(Pheno(x,y,individual_num),3,individual_num)=y;
      end
      if Pheno(x,y,individual_num)~=11 & ..
      Range(Pheno(x,y,individual_num),4,individual_num)<y
        Range(Pheno(x,y,individual_num),4,individual_num)=y;
      end  
    end
  end
end
//end of rooms' ranges for proportion

//Proportion
Proportion=ones(rooms,3,individuals);
for individual_num=1:individuals
  for room_num=1:rooms
    dx=Range(room_num,2,individual_num)-Range(room_num,1,individual_num)+1;
    dy=Range(room_num,4,individual_num)-Range(room_num,3,individual_num)+1;
    area=Area(room_num,1,individual_num);
    if dx>=1 & dy>=1
      if dy<dx
        dz=dy;dy=dx;dx=dz; //to be 0=<(dx/dy)=<1
      end
      //proportion
      if dx/dy<0.5
        Proportion(room_num,1,individual_num)=2*dx/dy;
      else
        Proportion(room_num,1,individual_num)=1;
      end
      //density
      Proportion(room_num,2,individual_num)=area/(dx*dy);
      //proportion*density
      Proportion(room_num,3,individual_num)=..
      Proportion(room_num,1,individual_num)*..
      Proportion(room_num,2,individual_num);
    else
      Proportion(room_num,:,individual_num)=0;
    end //if
  end
end
//end of Proportion


//Relation between rooms
Relation=zeros(11,11,individuals); //1~7:room 8~10:exterior 11:void
for individual_num=1:individuals
  for y=1:y_span+2 //1:y_span+2
    for x=1:x_span+2 //1:x_span+2
      //north
      if (x-1)>=1 & Pheno(x,y,individual_num)>=1 & Pheno(x-1,y,individual_num)>=1
        Relation(Pheno(x,y,individual_num),Pheno(x-1,y,individual_num),individual_num)=..
        Relation(Pheno(x,y,individual_num),Pheno(x-1,y,individual_num),individual_num)+1;
      end
      //east
      if (y+1)<=y_span+2 & Pheno(x,y,individual_num)>=1 & Pheno(x,y+1,individual_num)>=1
        Relation(Pheno(x,y,individual_num),Pheno(x,y+1,individual_num),individual_num)=..
        Relation(Pheno(x,y,individual_num),Pheno(x,y+1,individual_num),individual_num)+1;
      end
      //south
      if (x+1)<=x_span+2 & Pheno(x,y,individual_num)>=1 & Pheno(x+1,y,individual_num)>=1
        Relation(Pheno(x,y,individual_num),Pheno(x+1,y,individual_num),individual_num)=..
        Relation(Pheno(x,y,individual_num),Pheno(x+1,y,individual_num),individual_num)+1;
      end
      //west
      if (y-1)>=1 & Pheno(x,y,individual_num)>=1 & Pheno(x,y-1,individual_num)>=1
        Relation(Pheno(x,y,individual_num),Pheno(x,y-1,individual_num),individual_num)=..
        Relation(Pheno(x,y,individual_num),Pheno(x,y-1,individual_num),individual_num)+1;
      end
    end
  end
end
//end of Relation between rooms



//Circulation (Routing)
Circulation=zeros(1,7,individuals);
for individual_num=1:individuals

  //CommonCorridor <-> (Path or LR or DK)
  if Relation(8,7,individual_num)>=1 | Relation(8,1,individual_num)>=1 | Relation(8,2,individual_num)>=1
    Circulation(1,1,individual_num)=1;
  end
  //CommonCorridor <-> Void <-> (Path or LR or DK)
  if Relation(8,11,individual_num)>=1 & ..
  (Relation(11,7,individual_num)>=1 | Relation(11,1,individual_num)>=1 | Relation(11,2,individual_num)>=1)
    Circulation(1,1,individual_num)=1;
  end

  //BR1 <-> (LR or DK or Path)
  if Relation(3,1,individual_num)>=1 | Relation(3,2,individual_num)>=1 | Relation(3,7,individual_num)>=1
    Circulation(1,2,individual_num)=1;
  end
  //BR1 <-> Void <-> (LR or DK or Path)
  if Relation(3,11,individual_num)>=1 & ..
  (Relation(11,1,individual_num)>=1 | Relation(11,2,individual_num)>=1 | Relation(11,7,individual_num)>=1)
    Circulation(1,2,individual_num)=1;
  end

  //BR2 <-> (LR or DK or Path)
  if Relation(4,1,individual_num)>=1 | Relation(4,2,individual_num)>=1 | Relation(4,7,individual_num)>=1
    Circulation(1,3,individual_num)=1;
  end
  //BR2 <-> Void <-> (LR or DK or Path)
  if Relation(4,11,individual_num)>=1 & ..
  (Relation(11,1,individual_num)>=1 | Relation(11,2,individual_num)>=1 | Relation(11,7,individual_num)>=1)
    Circulation(1,3,individual_num)=1;
  end

  //BR3 <-> (LR or DK or Path)
  if Relation(5,1,individual_num)>=1 | Relation(5,2,individual_num)>=1 | Relation(5,7,individual_num)>=1
    Circulation(1,4,individual_num)=1;
  end
  //BR3 <-> Void <-> (LR or DK or Path)
  if Relation(5,11,individual_num)>=1 & ..
  (Relation(11,1,individual_num)>=1 | Relation(11,2,individual_num)>=1 | Relation(11,7,individual_num)>=1)
    Circulation(1,4,individual_num)=1;
  end

  //WA <-> (LR or DK or Path)
  if Relation(6,1,individual_num)>=1 | Relation(6,2,individual_num)>=1 | Relation(6,7,individual_num)>=1
    Circulation(1,5,individual_num)=1;
  end
  //WA <-> Void <-> (LR or DK or Path)
  if Relation(6,11,individual_num)>=1 & ..
  (Relation(11,1,individual_num)>=1 | Relation(11,2,individual_num)>=1 | Relation(11,7,individual_num)>=1)
    Circulation(1,5,individual_num)=1;
  end

  //Veranda <-> (LR or DK or Path)
  if Relation(9,1,individual_num)>=1 | Relation(9,2,individual_num)>=1 | Relation(9,7,individual_num)>=1
    Circulation(1,6,individual_num)=1;
  end
  //Veranda <-> Void <-> (LR or DK or Path)
  if Relation(9,11,individual_num)>=1 & ..
  (Relation(11,1,individual_num)>=1 | Relation(11,2,individual_num)>=1 | Relation(11,7,individual_num)>=1)
    Circulation(1,6,individual_num)=1;
  end

  //(LR <-> DK) & (LR <-> Path)
  if Relation(1,2,individual_num)>=1 & Relation(1,7,individual_num)>=1
    Circulation(1,7,individual_num)=1;
  end
  //(LR <-> DK) & (DK <-> Path)
  if Relation(1,2,individual_num)>=1 & Relation(2,7,individual_num)>=1
    Circulation(1,7,individual_num)=1;
  end
  //(LR <-> Path) & (DK <-> Path)
  if Relation(1,7,individual_num)>=1 & Relation(2,7,individual_num)>=1
    Circulation(1,7,individual_num)=1;
  end
  //ここもVoid経由の場合を含める必要があるのでは？
  
end
//end of Circulation



//Sunlight
Sunlight=zeros(rooms,6,individuals);
for individual_num=1:individuals
  //1st:sunlight area
  for room_num=1:rooms
    Sunlight(room_num,1,individual_num)=..
    Relation(room_num,8,individual_num)*1+.. //Corridor 1m^2/m
    Relation(room_num,9,individual_num)*2; //Veranda 2m^2/m
  end
  //2nd:floor area
  for room_num=1:rooms
    Sunlight(room_num,2,individual_num)=Area(room_num,1,individual_num);
  end
  //3rd:sunlight/floor
  for room_num=1:rooms
    if Sunlight(room_num,2,individual_num)~=0
      Sunlight(room_num,3,individual_num)=..
      Sunlight(room_num,1,individual_num)/Sunlight(room_num,2,individual_num);
    end
  end
  //4th:score
  for room_num=1:rooms
    if Sunlight(room_num,3,individual_num)<(1/7)//from architectural law
      Sunlight(room_num,4,individual_num)=Sunlight(room_num,3,individual_num)*7;
    else
      Sunlight(room_num,4,individual_num)=1;
    end
  end
  //5th:sunlight/floor case DK<->L them DK+L
  if Relation(1,2,individual_num)>=1
    Sunlight(1:2,5,individual_num)=..
    (Sunlight(1,1,individual_num)+Sunlight(2,1,individual_num))/..
    (Sunlight(1,2,individual_num)+Sunlight(2,2,individual_num));
  else
    Sunlight(1,5,individual_num)=Sunlight(1,3,individual_num);
    Sunlight(2,5,individual_num)=Sunlight(2,3,individual_num);
  end //if
  Sunlight(3,5,individual_num)=Sunlight(3,3,individual_num);
  Sunlight(4,5,individual_num)=Sunlight(4,3,individual_num);
  Sunlight(5,5,individual_num)=Sunlight(5,3,individual_num);

  //6th:score case DK<->L them DK+L
  for room_num=1:rooms
    if Sunlight(room_num,5,individual_num)<(1/7)//from architectural law
      Sunlight(room_num,6,individual_num)=Sunlight(room_num,5,individual_num)*7;
    else
      Sunlight(room_num,6,individual_num)=1;
    end
  end
end
//end of Sunlight



//InnerWall
InnerWall=zeros(1,individuals);
for individual_num=1:individuals

  //case room_num2=room_num+1:rooms
  for room_num=1:rooms-1
    for room_num2=room_num+1:rooms
      InnerWall(individual_num)=InnerWall(individual_num)+..
      Relation(room_num,room_num2,individual_num);
    end
  end

  //case room_num2=10
  for room_num=1:rooms//not rooms-1
    InnerWall(individual_num)=InnerWall(individual_num)+..
    Relation(room_num,10,individual_num);
  end

end //for individual_num
//end InnerWall



//Pipe Length between WA<->DK
Pipe=zeros(1,individuals);
for individual_num=1:individuals
  pipe_sum=0;
  pipes=0;
  for y_wa=2:y_span+1
    for x_wa=2:x_span+1
      if Pheno(x_wa,y_wa,individual_num)==6 //6:WaterArea
          for y_dk=2:y_span+1
            for x_dk=2:x_span+1
              if Pheno(x_dk,y_dk,individual_num)==2 //2:DiningKitchen
                pipe_sum=pipe_sum+sqrt((x_wa-x_dk)^2+(y_wa-y_dk)^2); //Euclidean distance
                pipes=pipes+1; //counter
              end // if
            end // for x_dk
          end // for y_dk
      end // if
    end // for x_wa
  end // for y_wa
  if pipes~=0
    Pipe(1,individual_num)=pipe_sum/pipes; //average of pipe length
  end 
end // for individual_num
//End of Pipe Length between WA<->DK



//IEC



//Objective
for individual_num=1:individuals
  //Area Size (Pathは考慮しないのでroom-1)
  for room_num=1:(rooms-1)
    Objective(individual_num,1,generation_num,sample_num)=..
    Objective(individual_num,1,generation_num,sample_num)+..
    Area(room_num,2,individual_num); // * or +?
  end //for room_num
  //Normalize（最大値を1にする）
  Objective(individual_num,1,generation_num,sample_num)=..
  Objective(individual_num,1,generation_num,sample_num)/(rooms-1);
  
  //Proportion (Pathは考慮しないのでroom-1)
  for room_num=1:(rooms-1)
    Objective(individual_num,2,generation_num,sample_num)=..
    Objective(individual_num,2,generation_num,sample_num)+..
    ProportionWeight(1,room_num)*Proportion(room_num,3,individual_num); // * or +?
  end //for room_num
  //Normalize（最大値を1にする）
  Objective(individual_num,2,generation_num,sample_num)=..
  Objective(individual_num,2,generation_num,sample_num)/sum(ProportionWeight);
  //prodはProportionWeightの数値を全てをかける
  
  //Circulation
  Objective(individual_num,3,generation_num,sample_num)=..
  sum(Circulation(1,:,individual_num));
  //Normalize（最大値を1にする）
  Objective(individual_num,3,generation_num,sample_num)=..
  Objective(individual_num,3,generation_num,sample_num)/7;
  
  //Sunlight
  Objective(individual_num,4,generation_num,sample_num)=..
  sum(Sunlight(1:(rooms-2),6,individual_num));//WA,Pathは居室ではないから
  //Normalize（最大値を1にする）
  Objective(individual_num,4,generation_num,sample_num)=..
  Objective(individual_num,4,generation_num,sample_num)/(rooms-2);//WA,Pathは居室ではないから
  
  //InnerWall
  if InnerWall(individual_num)==0 //住戸内に壁がない場合
    InnerWall(individual_num)=1; //とりあえず1ｍとする
  end
  //Normalize（最小値を12(=(rooms-1)*2)と仮定する）
  Objective(individual_num,5,generation_num,sample_num)=12/InnerWall(individual_num);
  //この目的を使用しない場合は↓
  //Objective(individual_num,5,generation_num,sample_num)=1;
  
  //Pipe
  if Pipe(individual_num)==0 //管がない場合
    Pipe(individual_num)=sqrt((x_span-1)^2+(y_span-1)^2); //最長とする
  end
  Objective(individual_num,6,generation_num,sample_num)=1/Pipe(individual_num);
  //この目的を使用しない場合は↓
  //Objective(individual_num,6,generation_num,sample_num)=1;
    
  //IEC
  //Default=1

end // for individual_num
//end of Objective

endfunction
