function growPheno
  
// 2016/02/17 �i�ڕW�ʐρ|���ݖʐρj�ɂ�蕔���̑I���m��������i�����͐����ł���4�������ׂā{�΂ߕ����A�������x���ςɁ@��F���������ł��Ȃ��Ȃ�E��2�{����������j

global individuals rooms x_span y_span rooms Geno Pheno Desirable_area
//room_prob room_available seed_distance growth_area seed_distance ..
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
end_flag=0; //�������~�߂邽�߂̃t���O
room_prob=zeros(rooms,individuals); // �I���m���A�ڕW�ʐς𒴉߂��Ă��Ȃ������͂�����̌Q��A�Q
room_excd_prob=zeros(rooms,individuals); // �I���m���A�ڕW�ʐς𒴉߂��������͂�����̌Q��B�Q
room_available=zeros(rooms,individuals); // �I���m���v�Z�ɕK�v�iA�Q�j
room_excd=zeros(rooms,individuals); // �I���m���v�Z�ɕK�v�iB�Q�j
growth_area=zeros(rooms,4,individuals); // �e�������Ƃɐ����ł���G���A�̖ʐ�
growth_count=ones(rooms,4); // �e�������Ƃɐ����ł���񐔁A�v�Z�̓s����1�ŏ������B�v�Z���ʂ�1�傫���Ȃ��Ă��܂��̂ł��ƂŃ}�C�i�X1���Ē��K�����킹�Ă���
growth_num=zeros(1,4); // �e�����i1��2�E3��4���j���Ƃɐ���������񐔂�����i�����Ŏw�肳�ꂽ��������������j

dir_prob=zeros(4,individuals); // �����I���ɕK�v�A�������ς�邲�ƂɍX�V

seed_distance=zeros(rooms,4,3,individuals); // �킩�畔���̒[�܂ł̋����A���Ԃ񖈉�[���ōX�V����K�v�͂Ȃ��i�����Ă��������j

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
      //�킩��e�����̃G���A�[�܂ł̋���(seed_distance)���v�Z
      // ���B�@�A������
      // �����@��������
      // �����@��������
      // �A�������������B�@1��2��3�Ǝ��v����
      // �@�@��@�@�@�@�@
      // �B���@���������A
      // �B���@���������A
      // �B���@���������A
      // �����@���������A
      // �����@����������
      // �����@����������
      // �@���@����������
      // �@�A�@�B�B
      common_flag=0;
      //North�@
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-1,Point(room_num,2,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,1,1,individual_num)=seed_distance(room_num,1,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //North�@
      common_flag=0;
      //North�A
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,1,2,individual_num)+1<=y_span+2 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num), ..
          Point(room_num,2,individual_num)+seed_distance(room_num,1,2,individual_num)+1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,1,2,individual_num)=seed_distance(room_num,1,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //North�A
      common_flag=0;
      //North�B
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,1,3,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num), ..
          Point(room_num,2,individual_num)-seed_distance(room_num,1,3,individual_num)-1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,1,3,individual_num)=seed_distance(room_num,1,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //North�B
      common_flag=0;
      //East�@
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+1<=y_span+2 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,2,1,individual_num)=seed_distance(room_num,2,1,individual_num)+1;
          else
            common_flag=1;
          end // if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //East�@
      common_flag=0;
      //East�A
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,2,2,individual_num)+1<=x_span+2 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,2,2,individual_num)+1, ..
          Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,2,2,individual_num)=seed_distance(room_num,2,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //East�A
      common_flag=0;
      //East�B
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,2,3,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,2,3,individual_num)-1, ..
          Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,2,3,individual_num)=seed_distance(room_num,2,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //East�B
      common_flag=0;
      //South�@
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1<=x_span+2// �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1,Point(room_num,2,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,3,1,individual_num)=seed_distance(room_num,3,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //South�@
      common_flag=0;
      //South�A
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,3,2,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num), ..
          Point(room_num,2,individual_num)-seed_distance(room_num,3,2,individual_num)-1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,3,2,individual_num)=seed_distance(room_num,3,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //South�A
      common_flag=0;
      //South�B
      while common_flag==0
        if Point(room_num,2,individual_num)+seed_distance(room_num,3,3,individual_num)+1<=y_span+2 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num), ..
          Point(room_num,2,individual_num)+seed_distance(room_num,3,3,individual_num)+1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,3,3,individual_num)=seed_distance(room_num,3,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //South�B
      common_flag=0;
      //West�@
      while common_flag==0
        if Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num),Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-1,individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,4,1,individual_num)=seed_distance(room_num,4,1,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //West�@
      common_flag=0;
      //West�A
      while common_flag==0
        if Point(room_num,1,individual_num)-seed_distance(room_num,4,2,individual_num)-1>=1 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,4,2,individual_num)-1, ..
          Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,4,2,individual_num)=seed_distance(room_num,4,2,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //West�A
      common_flag=0;
      //West�B
      while common_flag==0
        if Point(room_num,1,individual_num)+seed_distance(room_num,4,3,individual_num)+1<=x_span+2 // �S�̂̃G���A���͂ݏo���Ȃ����`�F�b�N
          if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,4,3,individual_num)+1, ..
          Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num),individual_num)==room_num // �����̃G���A���ł����seed_distance�����Z���Ă���
            seed_distance(room_num,4,3,individual_num)=seed_distance(room_num,4,3,individual_num)+1;
          else
            common_flag=1;
          end //if
        else //if �G���A���͂ݏo��
          common_flag=1;
        end//if
      end //West�B

      //�����\�G���A���v�Z
      common_flag=0;
      //North
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,1,3,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,1,2,individual_num) // �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-growth_count(room_num,1)>=1 // ���������A�G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-growth_count(room_num,1),unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)-seed_distance(room_num,1,1,individual_num)-growth_count(room_num,1),unit,individual_num)~=11 // �X�y�[�X���󔒂���Ȃ��Ȃ�t���O�𗧂Ăă��[�v�𔲂���
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,1,individual_num)=growth_area(room_num,1,individual_num)+(seed_distance(room_num,1,3,individual_num)+seed_distance(room_num,1,2,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          growth_count(room_num,1)=growth_count(room_num,1)+1;
        end
      end //North
      common_flag=0;
      //East
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,2,3,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,2,2,individual_num)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+growth_count(room_num,2)<=y_span+2 // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+growth_count(room_num,2),individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)+seed_distance(room_num,2,1,individual_num)+growth_count(room_num,2),individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,2,individual_num)=growth_area(room_num,2,individual_num)+(seed_distance(room_num,2,3,individual_num)+seed_distance(room_num,2,2,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          growth_count(room_num,2)=growth_count(room_num,2)+1;
        end
      end //East
      common_flag=0;
      //South
      while common_flag==0
        for unit=Point(room_num,2,individual_num)-seed_distance(room_num,3,2,individual_num):Point(room_num,2,individual_num)+seed_distance(room_num,3,3,individual_num)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+growth_count(room_num,3)<=x_span+2 // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+growth_count(room_num,3),unit,individual_num)~=0 ..
            & Pheno(Point(room_num,1,individual_num)+seed_distance(room_num,3,1,individual_num)+growth_count(room_num,3),unit,individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,3,individual_num)=growth_area(room_num,3,individual_num)+(seed_distance(room_num,3,2,individual_num)+seed_distance(room_num,3,3,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          growth_count(room_num,3)=growth_count(room_num,3)+1;
        end
      end //South
      common_flag=0;
      //West
      while common_flag==0
        for unit=Point(room_num,1,individual_num)-seed_distance(room_num,4,2,individual_num):Point(room_num,1,individual_num)+seed_distance(room_num,4,3,individual_num)// �����Ɛ��������A�͈͂��͂ݏo�����Ƃ͂Ȃ��͂�
          if Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-growth_count(room_num,4)>=1 // �G���A�͂ݏo���Ȃ��i���������j�Ȃ�
            if Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-growth_count(room_num,4),individual_num)~=0 ..
            & Pheno(unit,Point(room_num,2,individual_num)-seed_distance(room_num,4,1,individual_num)-growth_count(room_num,4),individual_num)~=11
              common_flag=1;
            end
          else
            common_flag=1;
          end
        end //for
        if common_flag==0
          growth_area(room_num,4,individual_num)=growth_area(room_num,4,individual_num)+(seed_distance(room_num,4,2,individual_num)+seed_distance(room_num,4,3,individual_num)+1); // ��Ђ̒����A+1=��̃Z��
          growth_count(room_num,4)=growth_count(room_num,4)+1;
        end
      end //West
      common_flag=0;
      growth_count(room_num,:)=growth_count(room_num,:)-1;
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
          if Desirable_area(room_num)- ..
          ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
          - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
          - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
          - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
          - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num))) ..
          > 0 // ���݂̕����̖ʐς��ڕW�ʐς𒴉߂��Ă��Ȃ����A�Q�ɓ����A�ڕW�ʐςɑ���Ȃ��قǑI�΂�Đ������₷��
            room_available(room_num,individual_num) = Desirable_area(room_num)- ..
            ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
            - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
            - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num)));
          else // �ڕW�ʐς𒴉߂��Ă�����B�Q�ɓ����A���߂��Ă��镪�����I�΂�ɂ�������
            if ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
            - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
            - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num))) ..
            - Desirable_area(room_num) == 0 // �v�Z�����ꂪ0�ɂȂ�Ƃ��̗�O����
              room_excd(room_num,individual_num) = 1;
            else
              room_excd(room_num,individual_num) =  1 / ((seed_distance(room_num,1,1,individual_num)+seed_distance(room_num,3,1,individual_num)+1) * (seed_distance(room_num,2,1,individual_num)+seed_distance(room_num,4,1,individual_num)+1) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,2,3,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,1,2,individual_num)) ..
            - (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,2,2,individual_num)) * (seed_distance(room_num,2,1,individual_num) - seed_distance(room_num,3,3,individual_num)) ..
            - (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,3,2,individual_num)) * (seed_distance(room_num,3,1,individual_num) - seed_distance(room_num,4,3,individual_num)) ..
            - (seed_distance(room_num,1,1,individual_num) - seed_distance(room_num,4,2,individual_num)) * (seed_distance(room_num,4,1,individual_num) - seed_distance(room_num,1,3,individual_num)) ..
            - Desirable_area(room_num)); // ���ߖʐς̋t�������[���b�g�̑傫���Ƃ��đ��
            end
          end
        else
          room_available(room_num,individual_num) = 0;
          room_excd(room_num,individual_num) = 0;
        end//room_flag��if
      end
      room_sum=0;
      room_sum2=0;
      for room_num=1:rooms // �I���m�����v�Z�A���[���b�g�I��
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

      //�����I��
      A_flag=0;
      for room_num=1:rooms
        if room_available(room_num,individual_num) ~=0 // �ڕW�ʐςɒB���Ă��Ȃ���������ł�����΂����(A�Q=room_available)����I��
          A_flag = 1;
        end
      end
      select_room=0;
      rand_num=rand();//0~1�̈�l���z����
      room_num=1;
      //A�Q�܂���B�Q���烋�[���b�g�I�� A�Q�c�܂��ڕW�ʐς𒴉߂��Ă��Ȃ������Q�@B�Q�c���łɖڕW�ʐς𒴉߂��������Q
      if A_flag == 1
        while select_room==0 //A�Q
          if rand_num<=room_prob(room_num,individual_num)
            select_room=room_num;
          else
            room_num=room_num+1;
          end
        end
      else
        while select_room==0 //B�Q
          if rand_num<=room_excd_prob(room_num,individual_num)
            select_room=room_num;
          else
            room_num=room_num+1;
          end
        end
      end

      //�������Ƃɐ���������
      grow=4;
      // �܂��͂��߂ɐ����ł��������1�񂸂�����z��
      //��
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
      //�c����grow�����R�ɐ����\��������U���p�����[�^�A�����`��D��i���������ł��Ȃ��Ȃ�E�A�オ�����ł��Ȃ��Ȃ牺�A�������͂��ꂼ��̋t�j�������Ȃ��₩��random�Amax�Amin
      //�����`
      //���������ł��Ȃ��Ȃ��
      if growth_count(select_room,1)>=2 & growth_count(select_room,3)==0
        growth_num(1,1)=growth_num(1,1)+1;
        grow=grow-1;
      end
      //���������ł��Ȃ��Ȃ�E
      if growth_count(select_room,2)>=2 & growth_count(select_room,4)==0
        growth_num(1,2)=growth_num(1,2)+1;
        grow=grow-1;
      end
      //�オ�����ł��Ȃ��Ȃ牺
      if growth_count(select_room,3)>=2 & growth_count(select_room,1)==0
        growth_num(1,3)=growth_num(1,3)+1;
        grow=grow-1;
      end
      //�E�������ł��Ȃ��Ȃ獶
      if growth_count(select_room,4)>=2 & growth_count(select_room,2)==0
        growth_num(1,4)=growth_num(1,4)+1;
        grow=grow-1;
      end
//pause
      
      dir_factor(1,1:4)=0;//�����������_���I������Ƃ��Ɏg�p�B4�����ɂ��Ă܂������ł���Ȃ�1�A�ł��Ȃ��Ȃ�0�B�������������܂邽�тɍX�V
      for dir_num=1:4
        if growth_count(select_room,dir_num)-growth_num(1,dir_num)>0
          dir_factor(1,dir_num)=1;
        end
      end
      // ���������S�ɔz�����I����Ă��Ȃ��@���@�܂������ł��镔��������@�ԁA���[�v
      while grow>=1 & (growth_count(select_room,1)-growth_num(1,1)>0 | growth_count(select_room,2)-growth_num(1,2)>0 ..
      | growth_count(select_room,3)-growth_num(1,3)>0 | growth_count(select_room,4)-growth_num(1,4)>0)
        //�����\�G���A�ő�̕�����I��
        //select_dir=0;
        //max_growth=0;
        //for dir_count=1:4
        //  if growth_count(select_room,dir_count)-growth_num(1,dir_count)>0 .. // �����\���`�F�b�N�������_�̐����\�ʐς��ő�̕�����I��
        //  & (growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1) > max_growth
        //    max_growth=(growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1);
        //    select_dir=dir_count;
        //  end
        //end
        //growth_num(1,select_dir)=growth_num(1,select_dir)+1;
        //grow=grow-1;

        //�ŏ��A�����\�G���A���[���̕��������O
        select_dir=0;
        min_growth=100000; //�K���ɑ傫�Ȑ�
        for dir_count=1:4
          if growth_count(select_room,dir_count)-growth_num(1,dir_count)>0 .. // �����\���`�F�b�N�������_�̐����\�ʐς��ŏ��̕�����I��
          & (growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1) < min_growth
            min_growth=(growth_count(select_room,dir_count)-growth_num(1,dir_count))*(seed_distance(select_room,dir_count,2,individual_num)+seed_distance(select_room,dir_count,3,individual_num)+1);
            select_dir=dir_count;
          end
        end
        growth_num(1,select_dir)=growth_num(1,select_dir)+1;
        grow=grow-1;
        
        //�����_���ɕ�����I��
        //dir_sum=0;
        //for dir_num=1:4
        //  if growth_count(select_room,dir_num)-growth_num(1,dir_num)>0 //�����\���`�F�b�N�����[���b�g�쐬
        //    dir_sum=dir_factor(1,dir_num)/sum(dir_factor(1,1:4))+dir_sum;
        //    dir_prob(dir_num,individual_num) = dir_sum;
        //  else
        //    dir_prob(dir_num,individual_num) = 0;
        //  end
        //end
        //select_dir=0;
        //rand_num=rand();//0~1�̈�l���z����
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
        //if growth_count(select_room,select_dir)-growth_num(1,select_dir)<=0//�����ł��Ȃ��Ȃ����炻�̕�����dir_factor���[���ɂ��đI����₩��O��
        //  dir_factor(1,select_dir)=0;
        //end

      end
//pause
      //����      
      //North
      count=1;
      while growth_num(1,1)>0
        //unit��1�x�̐����̒P��
        for unit=(Point(room_num,2,individual_num)-seed_distance(select_room,1,3,individual_num)):(Point(room_num,2,individual_num)+seed_distance(select_room,1,2,individual_num))
          //���������ėǂ����`�F�b�N���A�ǂ���ΐ���������
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
      //�΂ߕ����̐����A�ȉ��Ŏg���Ă���seed_distance�͐����O�̂��́i�܂��X�V����ĂȂ��j�ł��邱�Ƃɒ���
      for dir1=1:4
        for dir2=1:4
          //North East
          if Point(room_num,1,individual_num)-seed_distance(select_room,1,1,individual_num)-dir1>=1 & Point(room_num,2,individual_num)+seed_distance(select_room,2,1,individual_num)+dir2 <=y_span+2 // �������`�F�b�N
            //���������ėǂ����`�F�b�N���A�ǂ���ΐ���������
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
    end // ��������
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

//���ꂼ��̕����̖ʐς𐔂���(debug�p)
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
