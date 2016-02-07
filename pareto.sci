function pareto

global individuals objectives Objective Pareto generation_num sample_num Schedule

//Parate Ranking (Fonseca�C��p���[�g�̓����N��������)
Pareto=ones(1,individuals);
win_flag=0;
ovarlap_flag=1; //Objective�̒l���S�ē����ꍇ��1
pause;
for i=1:individuals //��r��̂̌̔ԍ�
  for j=1:individuals //��r����̌̔ԍ� 
    if i~=j //�������g�Ƃ̔�r�������
      for objective_num=1:objectives //����>=�ɂ������͕K�v�ȖړI��������objectives�ɐݒ肹��
        if Schedule(generation_num,objective_num)==1
          xi=Objective(i,objective_num,generation_num,sample_num);
          xj=Objective(j,objective_num,generation_num,sample_num);
          if xi>xj // > or >=
            win_flag=1; //���Ȃ��Ƃ����͏��ĂΗǂ�
          elseif xi<xj //>=�̎��͂����Ɖ��͕s�v�H
            ovarlap_flag=0; //Objective�̒l�ɈႢ������
          end //if Objective
        end // if Schedule
      end // for objective_num
      //debug: if win_flag==0 & ovarlap_flag==0 //>=�̎���ovarlap_flag�͕s�v�H
      if win_flag==1 & ovarlap_flag==0 //>=�̎���ovarlap_flag�͕s�v�H
      //if ���ׂĂ̖ړI�֐��ɂ��ď����Ă͂��Ȃ� & Objective�̒l�ɈႢ������
        //Pareto(1,i)=Pareto(1,i)+1; //Pareto Rank��������� //debug: �グ�Ă���H
        Pareto(1,i)=Pareto(1,i)-1; //Pareto Rank��������� //debug: �グ�Ă���H
      end // if
      win_flag=0; //reset flag
      ovarlap_flag=1; //reset flag
    end //if i~=j
  end //for j
end //for i
//end Parate Ranking

endfunction