function growPheno

// 2016/02/11 ������ڕW�ʐςɔ�Ⴕ�đI��������������A�����̕����͐����\�ȃG���A���ŏ�or�ő�ȕ���

global individuals rooms x_span y_span rooms Geno Pheno Desirable_area
//select_prob room_available seed_distance growth_area seed_distance ..
//end_flag common_flag  Direction_flag room_flag count

//�t�F�m�^�C�v�i�\���^�j���`�̍쐬
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
Pheno=zeros(x_span+2,y_span+2,individuals);
Pheno(1,1:y_span+2,:)=8,Pheno(x_span+2,2:y_span+1,:)=9;
Pheno(2:x_span+2,1,:)=10;
Pheno(2:x_span+2,y_span+2,:)=10;

//end_flag=0; // ��������߂邱�Ƃ𔻒f����t���O
//common_flag=0; // �ėp�t���O

//debug: ���ۂ�individual�ŕ����Ȃ��Ƃ����Ȃ��̂�Point�APheno�����H
Direction_flag=zeros(rooms,4,individuals); // �����A�������Ƃɐ������邩�𔻒f����t���O
room_flag=zeros(rooms,individuals); // �����P�ʂŐ����ł��邩�𔻒f����t���O(Direction_flag����ł����Ă΂��������)
end_flag=0;
select_prob=zeros(rooms,individuals); // �I���m���v�Z�ɕK�v
room_available=zeros(rooms,individuals); // �I���m���v�Z�ɕK�v
growth_area=zeros(rooms,4,individuals); // �e�������Ƃɐ����ł���G���A�̖ʐ�

dir_prob=zeros(4,individuals); // �����I���ɕK�v�A�������ς�邲�ƂɍX�V

seed_distance=zeros(rooms,4,individuals); // �킩�畔���̒[�܂ł̋����A���Ԃ񖈉�[���ōX�V����K�v�͂Ȃ�

Point=zeros(rooms,2,individuals); // ���x���Ay�����W�A�����ł͍X�V�K�v�Ȃ�

//put Geno points into Pheno
for individual_num=1:individuals
  for room_num=1:rooms
    //Point means coordinate of seed
    Point(room_num,:,individual_num)=Geno(room_num,1:2,individual_num);
    //there is overlap problem on next line
    Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num),individual_num)=room_num;
  end
end

//�����\�G���A�̃J�E���g
for individual_num=1:individuals
  end_flag=0;
  while end_flag==0
    //���Z�b�g
    growth_area(:,:,individual_num)=0;
    Direction_flag(:,:,individual_num)=0;
    room_flag(:,individual_num)=0;
    select_prob(:,individual_num)=0;
    room_available(:,individual_num)=0;
    for room_num=1:rooms
      dir_prob(:,:)=0;
      //�킩��e�����̃G���A�[�܂ł̋���(seed_distance)���v�Z
      common_flag=0;
      //North
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-1,Point(room_num,2,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,1,individual_num)=seed_distance(room_num,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //North
      common_flag=0;
      //East
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+1<=y_span+2 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,2,individual_num)=seed_distance(room_num,2,individual_num)+1;
          else
            common_flag=1;
          end // if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //East
      common_flag=0;
      //South
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1<=x_span+2// �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1,Point(room_num,2,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,3,individual_num)=seed_distance(room_num,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //South
      common_flag=0;
      //West
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,4,individual_num)=seed_distance(room_num,4,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //West
      common_flag=0;
      
      //�����\�G���A���v�Z
      count=1;
      //North
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num) // �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-count>=1 // ���������A�G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-count,unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num)-count,unit,individual_num)~=11 // �X�y�[�X���󔒂���Ȃ��Ȃ�t���O�𗧂Ăă��[�v�𔲂���
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,1,individual_num)=growth_area(room_num,1,individual_num)+(seed_distance(room_num,4,individual_num)+seed_distance(room_num,2,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          count=count+1;
        end
      end //North
      common_flag=0;
      //East
      count=1;
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+count<=y_span+2 // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+count,individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)+count,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,2,individual_num)=growth_area(room_num,2,individual_num)+(seed_distance(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          count=count+1;
        end
      end //East
      common_flag=0;
      //South
      count=1;
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,2,individual_num)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+count<=x_span+2 // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+count,unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+count,unit,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,3,individual_num)=growth_area(room_num,3,individual_num)+(seed_distance(room_num,4,individual_num)+seed_distance(room_num,2,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          count=count+1;
        end
      end //South
      common_flag=0;
      //West
      count=1;
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,1,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-count>=1 // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-count,individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,individual_num)-count,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,4,individual_num)=growth_area(room_num,4,individual_num)+(seed_distance(room_num,1,individual_num)+seed_distance(room_num,3,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          count=count+1;
        end
      end //West
      common_flag=0;
    end //room_num
    
    // �����ł��镔���A�����Ƀt���O�𗧂Ă�
    for room_num=1:rooms
      for direction_num=1:4
        if growth_area(room_num,direction_num,individual_num)>0 
          Direction_flag(room_num,direction_num,individual_num)=1;
          room_flag(room_num,individual_num)=1; //debug: overload�̖��
        end //if
      end //direction_num
    end //room_num
  
//    pause

    //�I������
    end_flag=1;
    for room_num=1:rooms
      if room_flag(room_num,individual_num)==1
        end_flag=0;
      end
    end
  
    if end_flag==0 // ���������i��ł������ł��镔��������΁j
      //�I���m���v�Z
      for room_num=1:rooms // �����ł��Ȃ����������O
        if room_flag(room_num,individual_num)==1
          room_available(room_num,individual_num) = Desirable_area(room_num);
        else
          room_available(room_num,individual_num) = 0;
        end//if
      end
      room_sum=0;
      for room_num=1:rooms // �I���m�����v�Z�A���[���b�g�I��
        if room_available(room_num,individual_num)~=0
          room_sum = room_available(room_num,individual_num)/sum(room_available(1:rooms,individual_num))+ room_sum;
          select_prob(room_num,individual_num) = room_sum;
        else
          select_prob(room_num,individual_num) = 0;
        end
      end

      //�����I��
      select_room=0;
      rand_num=rand();//0~1�̈�l���z����
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

      //�����I�� �����G���A���ő�or�ŏ���I���B
      //�ő�A�d�l�ŕ����ԍ����Y���������łȂ������̑傫����������Ȃ��Ƃ����Ȃ��݂���
      //[dir_size,select_dir]=maxi(growth_area(select_room,1:4,individual_num));

      //�ŏ��A�[�������O���Ȃ��ƃ_���Ȃ̂Ōʂ�
      select_dir=0;
      min_growth=100000; //�K���ɑ傫�Ȑ�
      for dir_count=1:4
        if growth_area(select_room,dir_count,individual_num)~=0 ..
        & growth_area(select_room,dir_count,individual_num) < min_growth
          select_dir=dir_count;
        end
      end

      //����      
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
    end // ��������
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

//���ꂼ��̕����̖ʐς𐔂���(debug�p)
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
