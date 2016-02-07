function growPheno

//2016_02_06 �T�C�Y�ڕW�ɉ����Ċm���I�ɕ����I���A�����\�ȑS�����ɐ���
global individuals rooms x_span y_span rooms Geno Pheno Desirable_area ..
seed_distance growth_area Direction_flag select_num

//�t�F�m�^�C�v�i�\���^�j���`�̍쐬
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
Pheno=zeros(x_span+2,y_span+2,individuals);
Pheno(1,1:y_span+2,:)=8,Pheno(x_span+2,2:y_span+1,:)=9;
Pheno(2:x_span+2,1,:)=10;
Pheno(2:x_span+2,y_span+2,:)=10;

//end_flag=0; // ��������߂邱�Ƃ𔻒f����t���O
//common_flag=0; //�ėp�t���O
//count=1; //�����\�G���A�v�Z�p
seed_distance=zeros(rooms,4); // �킩�畔���̒[�܂ł̋���
growth_area=zeros(rooms,4); // �e�������Ƃɐ����ł���G���A�̖ʐ�
select_prob=zeros(rooms,1); // �I���m���v�Z�ɕK�v
room_available=zeros(rooms,1); // �I���m���v�Z�ɕK�v
Direction_flag=zeros(rooms,4); // �����A�������Ƃɐ������邩�𔻒f����t���O
room_flag=zeros(rooms,1); //�����������ł��邩�𔻒f����t���O


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
    seed_distance=zeros(rooms,4); // �킩�畔���̒[�܂ł̋����A4����
    growth_area=zeros(rooms,4); // �e�������Ƃɐ����ł���G���A�̖ʐ�
    select_prob=zeros(rooms,1); // �I���m���v�Z�ɕK�v
    room_available=zeros(rooms,1); // �I���m���v�Z�ɕK�v
    Direction_flag=zeros(rooms,4); // �����A�������Ƃɐ������邩�𔻒f����t���O
    room_flag=zeros(rooms,1); // �����P�ʂŐ����ł��邩�𔻒f����t���O(Direction_flag����ł����Ă΂��������)
    //�����\�G���A�̃J�E���g
    for room_num=1:rooms
      //�킩��e�����̃G���A�[�܂ł̋���(seed_distance)���v�Z
      //����W�X�V�Aseed_distance���Z�b�g
      Point=Geno(room_num,1:2,individual_num);
      //North
      common_flag=0;
      while common_flag==0
        if Point(1)-seed_distance(room_num,1)>=1 // �G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(1)-seed_distance(room_num,1),Point(2),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,1)=seed_distance(room_num,1)+1;
          else //debug: else�����܂��Ή����Ă��Ȃ������i�����C���f���g���������������D�P��editor�̖��H�j
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //North
      common_flag=0;
      //East
      while common_flag==0
        if Point(2)+seed_distance(room_num,2)<=y_span // �G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(1),Point(2)+seed_distance(room_num,2),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,2)=seed_distance(room_num,2)+1;
          else //debug: else�����܂��Ή����Ă��Ȃ������i�����C���f���g���������������D�P��editor�̖��H�j
            common_flag=1;
          end // if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //East
      common_flag=0;
      //South
      while common_flag==0
        if Point(1)+seed_distance(room_num,3)<=x_span// �G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(1)+seed_distance(room_num,3),Point(2),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,3)=seed_distance(room_num,3)+1;
          else //debug: (�i�����C���f���g���������������D�P��editor�̖��H�j
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //South
      common_flag=0;
      //West
      while common_flag==0
        if Point(2)-seed_distance(room_num,4)>=1// �G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(1),Point(2)-seed_distance(room_num,4),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,4)=seed_distance(room_num,4)+1;
          else //debug: else�����܂��Ή����Ă��Ȃ������i�����C���f���g���������������D�P��editor�̖��H�j
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //West    
      //�����\�G���A���v�Z
      //North
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(2)-seed_distance(room_num,4):-1:Point(2)+seed_distance(room_num,2) // �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(1)-seed_distance(room_num,1)-count>=1 // ���������A�G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(Point(1)-seed_distance(room_num,1)-count,unit,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,1)=growth_area(room_num,1)+(seed_distance(room_num,4)+seed_distance(room_num,2)+1); // ��Ђ̒����A+1=��̃Z��
        count=count+1;
      end //North
      //East
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(1)-seed_distance(room_num,1):Point(1)+seed_distance(room_num,3)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(2)+seed_distance(room_num,2)+count<=y_span // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(unit,Point(2)+seed_distance(room_num,2)+count,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,2)=growth_area(room_num,2)+(seed_distance(room_num,1)+seed_distance(room_num,3)+1); // ��Ђ̒����A+1=��̃Z��
        count=count+1;
      end //East
      //South
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(2)-seed_distance(room_num,4):Point(2)+seed_distance(room_num,2)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(1)+seed_distance(room_num,3)+count<=x_span // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(Point(1)+seed_distance(room_num,3)+count,unit,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,3)=growth_area(room_num,3)+(seed_distance(room_num,4)+seed_distance(room_num,2)+1); // ��Ђ̒����A+1=��̃Z��
        count=count+1;
      end //South
      //West
      count=1;
      common_flag=0;
      while common_flag==0
        for unit=Point(1)-seed_distance(room_num,1):-1:Point(1)+seed_distance(room_num,3)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(2)-seed_distance(room_num,4)-count>=1 // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(unit,Point(2)-seed_distance(room_num,4)-count,individual_num)~=0
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        growth_area(room_num,4)=growth_area(room_num,4)+(seed_distance(room_num,1)+seed_distance(room_num,3)+1); // ��Ђ̒����A+1=��̃Z��
        count=count+1;
      end //West
      count=1;
      common_flag=0;

    end //room_num
    
    // �����ł��镔���A�����Ƀt���O�𗧂Ă�
    for room_num=1:rooms
      for direction_num=1:4
        if (growth_area(room_num,direction_num)>0)
          Direction_flag(room_num,direction_num)=1;
          room_flag(room_num,1)=1; //debug: overload�̖��
        end //if
      end //direction_num
    end //room_num

    //�I������
    end_flag=1;
    for room_num=1:rooms
      if room_flag(room_num,1)==1
        end_flag=0;
      end
    end
  
    if end_flag==0 //��������
      //�I���m���v�Z
      for room_num=1:rooms // �����ł��镔�������ɂ���
        if room_flag(room_num,1)==1
          room_available(room_num,1) = Desirable_area(room_num);
        end//if
      end
      for room_num=1:rooms // �I���m�����v�Z
        select_prob(room_num,1) ..
        = (room_available(room_num,1)/sum(room_available(:,1))) ..
          +select_prob(room_num,1);
      end
    
      //�I��
      select_num=0;
      rand_num=rand();//0~1�̈�l���z����
      for room_num=1:rooms
        if rand_num<=select_prob(room_num,1)
          select_num=room_num;
        end
      end

      //����
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
    end //if ��������
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
