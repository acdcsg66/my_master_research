function geneManipulate
global x_span y_span Geno individuals Pair GenoBinary children ChildBinary ..
mutationRate rooms Child

//Geno��2�i�ɕϊ�
x=ceil(log2(x_span)); //ceil�͏����_�ȉ��؂�グ
y=ceil(log2(y_span));
GenoBinary=zeros(individuals,(x+y)*rooms); //Geno��2�i�s��
GenoNoFrame=Geno-2; //�g�i�L��,�x�����_,�ׂ̕ǁj�̕��̍��W������

for individual_num=1:individuals
  for room_num=1:rooms
    
    deca=GenoNoFrame(room_num,1,individual_num); //10�i�̍��W��1�i�[����
    for keta=x:-1:1 //x���W
      GenoBinary(individual_num,x-(keta-1)+(x+y)*(room_num-1))=..
      int(deca/(2^(keta-1))); //�傫��������2�i�ɕϊ�
      if int(deca/(2^(keta-1)))==1
        deca=deca-2^(keta-1);
      end //if
    end //for keta
    
    deca=GenoNoFrame(room_num,2,individual_num);
    for keta=y:-1:1 //y���W
      GenoBinary(individual_num,(x+y)-(keta-1)+(x+y)*(room_num-1))=..
      int(deca/(2^(keta-1)));
      if int(deca/(2^(keta-1)))==1
        deca=deca-2^(keta-1);
      end //if
    end //for keta

  end//for room_num
end//for individual_num
//End of Geno��2�i�ɕϊ�



//��`�I����i�����C�ˑR�ψفj
ketaSize=size(GenoBinary,2); //size(,2)�͉������̒���
ChildBinary=zeros(children,ketaSize);
Child=zeros(rooms,2,children); //children=individuals�Ȃ��Geno�Ɠ����`��

child_num=1;
while child_num<=children
  fatalFlag=0; //�v���t���O

  //crossover(��l����)
  for keta=1:ketaSize
    //rand('seed',getdate('s'))
    if rand()<0.5
      ChildBinary(child_num,keta)=GenoBinary(Pair(child_num,1),keta);
    else
      ChildBinary(child_num,keta)=GenoBinary(Pair(child_num,2),keta);
    end // if
  end //for keta

  //mutation(�ˑR�ψ�)
  for keta=1:ketaSize
    //rand('seed',getdate('s'))
    if rand()<mutationRate //�ˑR�ψٗ��ȉ��Ȃ�r�b�g�𔽓]
      if ChildBinary(child_num,keta)==0
        ChildBinary(child_num,keta)=1;
      else
        ChildBinary(child_num,keta)=0;
      end //if
    end //if
  end //for keta

  //2->10 2�i����10�i�ɕϊ�
  Child(:,:,child_num)=0;
  for room_num=1:rooms
    for keta=1:x //x���W
      bi=ChildBinary(child_num,keta+(room_num-1)*(x+y)); //2�i�̍��W��1�i�[����
      Child(room_num,1,child_num)=Child(room_num,1,child_num)+(bi*2^(x-keta));
    end //for keta    
    for keta=1:y //y���W
      bi=ChildBinary(child_num,x+keta+(room_num-1)*(x+y)); //2�i�̍��W��1�i�[����
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

//�e�Ɠ���ւ�
Geno=Child+2; //+2����̂�Child�̗v�f����0�`x_span-1�C0�`y_span-1������



endfunction
