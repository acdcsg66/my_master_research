function pseudoEvaluate
global individuals Pareto Pair children x_span y_span Pheno Objective ..
generation_num sample_num

//�[���l�ԗp�ڕW�t�F�m�^�C�v�i�\���^�j
//rooms' name & character & desirable-area(m^2)
//0=Void 8=commonCorridor 9=veranda 10=wall+Obstruction
targets=2;//�K�v�ɉ����ĖڕW�̊Ԏ�萔��ݒ肵�C���ŊԎ����`���邱��
TargetPheno=zeros(x_span+2,y_span+2,targets);
TargetPheno(:,:,1)=[
 8  8  8  8  8  8  8  8  8;
10  3  3  3  7  4  4  4 10;
10  3  3  3  7  4  4  4 10;
10  3  3  3  7  4  4  4 10;
10  3  3  3  7  4  4  4 10;
10  6  6  2  2  2  2  2 10;
10  6  6  2  2  2  2  2 10;
10  6  6  2  2  2  2  2 10;
10  6  6  6  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  5  5  5  1  1  1  1 10;
10  9  9  9  9  9  9  9 10];
//���E���]
TargetPheno(:,:,2)=[
 8  8  8  8  8  8  8  8  8;
10  4  4  4  7  3  3  3 10;
10  4  4  4  7  3  3  3 10;
10  4  4  4  7  3  3  3 10;
10  4  4  4  7  3  3  3 10;
10  2  2  2  2  2  6  6 10;
10  2  2  2  2  2  6  6 10;
10  2  2  2  2  2  6  6 10;
10  1  1  1  1  6  6  6 10;
10  1  1  1  1  5  5  5 10;
10  1  1  1  1  5  5  5 10;
10  1  1  1  1  5  5  5 10;
10  1  1  1  1  5  5  5 10;
10  9  9  9  9  9  9  9 10]; 

//�ڕW�̊Ԏ��Əo�����Ԏ��̍������߂�
Difference=zeros(individuals,targets);
for individual_num=1:individuals //��r��̂̌̔ԍ� 
  for target_num=1:targets //��r����̌̔ԍ�
    for x=2:x_span+1
      for y=2:y_span+1
        phenoRoom=Pheno(x,y,individual_num);
        targetRoom=TargetPheno(x,y,target_num);
        //(Pheno��Target���قȂ�)���iPheno��BR1�`3����Target��BR1�`3�j�łȂ�
        if phenoRoom~=targetRoom & ..
          ~((phenoRoom==3 | phenoRoom==4 | phenoRoom==5) & ..
            (targetRoom==3 | targetRoom==4 | targetRoom==5))
          Difference(individual_num,target_num)=..
          Difference(individual_num,target_num)+1;
        end //if
      end //for y
    end //for x
  end //for target_num
end //for individual_num

//�ǂ����i���������j��I������
DifferenceBetter=zeros(individuals,1);
for individual_num=1:individuals
  DifferenceBetter(individual_num,1)=min(Difference(individual_num,:));
end
best=min(DifferenceBetter);
worst=max(DifferenceBetter);
width=(worst-best)/5;//�P�_�̕�

//�����ł�1�_����0.2���݂�0.2�܂ł�IEC�]���_�Ƃ��Ă���D�x�X�g��1�_
if best==worst
  Objective(:,7,generation_num,sample_num)=1;
else
  for individual_num=1:individuals
    if     DifferenceBetter(individual_num,1)>=worst-width
      Objective(individual_num,7,generation_num,sample_num)=0.2;
    elseif DifferenceBetter(individual_num,1)>=worst-2*width
      Objective(individual_num,7,generation_num,sample_num)=0.4;
    elseif DifferenceBetter(individual_num,1)>=worst-3*width
      Objective(individual_num,7,generation_num,sample_num)=0.6;
    elseif DifferenceBetter(individual_num,1)>=worst-4*width
      Objective(individual_num,7,generation_num,sample_num)=0.8;
    else
      Objective(individual_num,7,generation_num,sample_num)=1;
    end // if
  end //for individual_num    
end //if


endfunction 
