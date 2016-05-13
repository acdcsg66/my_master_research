function growPheno

global individuals rooms x_span y_span rooms Geno Pheno

//フェノタイプ（表現型）雛形の作成
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
Pheno=zeros(x_span+2,y_span+2,individuals);
Pheno(1,1:y_span+2,:)=8;
Pheno(x_span+2,2:y_span+1,:)=9;
Pheno(2:x_span+2,1,:)=10;
Pheno(2:x_span+2,y_span+2,:)=10;



//put Geno points into Pheno
for individual_num=1:individuals
  for room_num=1:rooms
    //Point means coordinate of seed
    Point=Geno(room_num,1:2,individual_num);
    //there is overlap problem on next line
    Pheno(Point(1),Point(2),individual_num)=room_num;
  end
end



//grow Pheno points
for individual_num=1:individuals
  Direction_flag=zeros(rooms,4);
  for growth=1:max(x_span-1,y_span-1)
    for room_num=1:rooms
      //Point means coordinate of seed
      Point=Geno(room_num,1:2,individual_num);
      
      //North start
      if Direction_flag(room_num,1)==0
        for check_room=Point(2)-growth+1:Point(2)+growth-1
          //check Pheno coordinates range
          if (Point(1)-growth>=1)&(check_room>=1)&(check_room<=y_span+2)
            //セルにその部屋の番号があってかつ進行方向のセルが空いていることを確かめる
            if (Pheno(Point(1)-growth+1,check_room,individual_num)==room_num)..
            &(Pheno(Point(1)-growth,check_room,individual_num)~=0)
              Direction_flag(room_num,1)=1;
            end //if 
          end //if
        end //for check_room
        //fill cells with room_mun start
        if Direction_flag(room_num,1)==0
          for check_room=Point(2)-growth+1:Point(2)+growth-1
            if (Point(1)-growth>=1)&(check_room>=1)&(check_room<=y_span+2)
              if Pheno(Point(1)-growth+1,check_room,individual_num)==room_num
                Pheno(Point(1)-growth,check_room,individual_num)=room_num;
              end //if
            end //if
          end //for check_room
        end // if Direction_flag
        //fill cells with room_num end        
      end //if Direction_flag
      //North end
      
      //East start
      if Direction_flag(room_num,2)==0
        for check_room=Point(1)-growth+1:Point(1)+growth-1
          if (check_room>=1)&(check_room<=x_span+2)&(Point(2)+growth<=y_span+2)
            if (Pheno(check_room,Point(2)+growth-1,individual_num)==room_num)..
            &(Pheno(check_room,Point(2)+growth,individual_num)~=0)
              Direction_flag(room_num,2)=1;
            end //if
          end //if
        end //for check_room
        //fill cells with room_mun start
        if Direction_flag(room_num,2)==0
          for check_room=Point(1)-growth+1:Point(1)+growth-1
            if (check_room>=1)&(check_room<=x_span+2)&(Point(2)+growth<=y_span+2)
              if Pheno(check_room,Point(2)+growth-1,individual_num)==room_num
                Pheno(check_room,Point(2)+growth,individual_num)=room_num;
              end //if
            end //if
          end //for check_room
        end // if Direction_flag
        //fill cells with room_num end
      end //if
      //East end
      
      //South start
      if Direction_flag(room_num,3)==0
        for check_room=Point(2)-growth+1:Point(2)+growth-1
          if (check_room>=1)&(check_room<=y_span+2)&(Point(1)+growth<=x_span+2)
            if (Pheno(Point(1)+growth-1,check_room,individual_num)==room_num)..
            &(Pheno(Point(1)+growth,check_room,individual_num)~=0)
              Direction_flag(room_num,3)=1;
            end //if
          end // if
        end //for check_room
        //fill cells with room_mun start
        if Direction_flag(room_num,3)==0
          for check_room=Point(2)-growth+1:Point(2)+growth-1
            if (check_room>=1)&(check_room<=y_span+2)&(Point(1)+growth<=x_span+2)
              if Pheno(Point(1)+growth-1,check_room,individual_num)==room_num
                Pheno(Point(1)+growth,check_room,individual_num)=room_num;
              end //if
            end //if
          end //for check_room
        end //if Direction_flag
        //fill cells with room_num end
      end //if
      //South end
      
      //West start
      if Direction_flag(room_num,4)==0
        for check_room=Point(1)-growth+1:Point(1)+growth-1
          if (check_room>=1)&(check_room<=x_span+2)&(Point(2)-growth>=1)
            if (Pheno(check_room,Point(2)-growth+1,individual_num)==room_num)..
            &(Pheno(check_room,Point(2)-growth,individual_num)~=0)
              Direction_flag(room_num,4)=1;
            end //if
          end //if
        end //for check_room
        //fill cells with room_mun start
        if Direction_flag(room_num,4)==0
          for check_room=Point(1)-growth+1:Point(1)+growth-1
            if (check_room>=1)&(check_room<=x_span+2)&(Point(2)-growth>=1)
              if Pheno(check_room,Point(2)-growth+1,individual_num)==room_num
                Pheno(check_room,Point(2)-growth,individual_num)=room_num;
              end //if
            end //if
          end //for check_room
        end //if Direction_flag
        //fill cells with room_num end
      end //if
      //west end
      
      //NE corner start
      if(Point(1)-growth>=1)&(Point(2)+growth<=y_span+2)
        if (Pheno(Point(1)-growth,Point(2)+growth-1,individual_num)==room_num)..
        &(Pheno(Point(1)-growth+1,Point(2)+growth,individual_num)==room_num)..
        &(Pheno(Point(1)-growth,Point(2)+growth,individual_num)==0)
          Pheno(Point(1)-growth,Point(2)+growth,individual_num)=room_num;
        end
      end
      //NE corner end
      
      //SE corner start
      if(Point(1)+growth<=x_span+2)&(Point(2)+growth<=y_span+2)
        if (Pheno(Point(1)+growth-1,Point(2)+growth,individual_num)==room_num)..
        &(Pheno(Point(1)+growth,Point(2)+growth-1,individual_num)==room_num)..
        &(Pheno(Point(1)+growth,Point(2)+growth,individual_num)==0)
          Pheno(Point(1)+growth,Point(2)+growth,individual_num)=room_num;
        end
      end      
      //SE corner end
      
      //SW corner start
      if(Point(1)+growth<=x_span+2)&(Point(2)-growth>=1)
        if (Pheno(Point(1)+growth,Point(2)-growth+1,individual_num)==room_num)..
        &(Pheno(Point(1)+growth-1,Point(2)-growth,individual_num)==room_num)..
        &(Pheno(Point(1)+growth,Point(2)-growth,individual_num)==0)
          Pheno(Point(1)+growth,Point(2)-growth,individual_num)=room_num;
        end
      end
      //SW corner end
      
      //NW corner start
      if(Point(1)-growth>=1)&(Point(2)-growth>=1)
        if (Pheno(Point(1)-growth+1,Point(2)-growth,individual_num)==room_num)..
        &(Pheno(Point(1)-growth,Point(2)-growth+1,individual_num)==room_num)..
        &(Pheno(Point(1)-growth,Point(2)-growth,individual_num)==0)
          Pheno(Point(1)-growth,Point(2)-growth,individual_num)=room_num;
        end
      end
      //NW corner end
      
    end // for room_num
  end //for growth
end //for individual_num


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
