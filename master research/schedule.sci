function schedule

global Schedule generations objectives

//1�̎���pareto�ŕ]������
//���s�̑O��Schedule���m�F���邱��
Schedule=zeros(generations,objectives);

//Schedule(:,7)=1;
Schedule(:,1:4)=1;
//Schedule(:,7)=1;
//Schedule(:,1:6)=1;

for n=5:5:50 //begin:step:end
  //Schedule(n,1:4)=0;
  Schedule(n,7)=1; //�ꍇ�ɂ����0�����邱�Ƃ��o����
end

endfunction
