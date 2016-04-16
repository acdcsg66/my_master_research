//(c)2006-2008 Makoto Inoue
//Takagi-Lab, Graduate School of Design, Kyushu University

//���ړI�œK����@��NSGA-II����MOEA/D�ɕύX

lines(0);

//�֐���g�ݍ���
exec randGeno.sci
exec growPheno.sci
exec evaluate.sci
exec pareto.sci
exec selectPair.sci
exec geneManipulate.sci
exec planFig.sci
exec pseudoEvaluate.sci
exec schedule.sci
exec moea_d_initialize.sci
exec moea_d_evaluate.sci
exec moea_d_selectPair.sci
exec moea_d_update.sci

//�O���[�o���ϐ�
global x_span y_span rooms individuals Geno Pheno objectives Objective Pareto ..
generations generation_num Pair GenoBinary children ChildBinary Child mutationRate tche_records tche_records present_num ..
Desirable_area Desirable_proportion sigma_share exponent_share sample_num subproblem_fitness ..
subproblem_weight subproblem_neighbor subproblem_neighbors BIG_NUM best_so_far

//�萔�ݒ�
BIG_NUM=10000; //�K���ɑ傫�Ȑ�
x_span=7+5;//span to x-direction
y_span=7;//span to y-direction
rooms=7;//number of room-type
objectives=6;//Area,Proportion,Circulation,Sunlight,InnerWall,Pipe,IEC
generations=50;//���㐔
samples=10;//�T���v������2�ȏ�ɂ��Ȃ��ƍs��̓s���ŃG���[���o��H
individuals=21; //�̐�
//sigma_share=49/4; //0<�V�F�A�����O(���a)<=(x_span*y_span) //debug: NSGA-II�p�H
//exponent_share=1;
children=individuals; //1����ō��q���̐�(�e�Ǝq���𑍓��ւ�����̂œ������ɂ���)
Desirable_area=[20,16,12,12,12,9,1]; //Area Size - LR,DK,BR1,BR2,BR3,WA,Path
Desirable_proportion(1:rooms,1:2)=0.5; // 2�͏c:���̔�D���݂͂��ׂĐ����`���ŗ�
best_so_far=zeros(1,individuals); //�e�ړI���Ƃɉߋ���best fitness�i�P�ړI�]���j
subproblem_neighbors=5; //�ߗ׌̂̐��i���Ő����j
subproblem_neighbor=zeros(individuals,subproblem_neighbors+1,3); //�e�̂͋ߗׂ̌̂����������q�̂𐶐��Dneighbor+1�̓A���S���Y���̓s���D3��1(�̔ԍ��W�j��2�i�����j�C3�i�]���l�j
subproblem_weight=zeros(individuals,objectives); //���ꂼ��̌̂�����fitness�ւ̏d�݃x�N�g���D���s���̏��߂Ɉ�x������������Œ�
subproblem_fitness=zeros(1,individuals); //�̂��ƂɒP�ړI���C�������ꂽ�ړI�֐��D�K���ɑ傫�Ȑ��ŏ�����
records=zeros(individuals,rooms,2); //�L�^1�@�X�V���邩�ǂ��������߂�i�e�̂̕����̎���W��fitness��ۑ��j
tche_records(1:individuals,1:objectives)=BIG_NUM; // �L�^2 Tchebycheff method�ōœK������ړI�֐�
present_num=0; //�œK������ړI�ԍ�
//sorted_distance=zeros();
Geno=zeros(rooms,2,individuals); //�Q�m�^�C�v�i��`�q�^�j
Objective=zeros(individuals,objectives,generations,samples);
//�́E�ړI�E����E�T���v�������Ƃ̕]���l
mutationRate=0.01; //�ˑR�ψٗ�0�`1

getdate()

//main loop////////////////////////////////////////////////////////////////////
schedule();
for sample_num=1:samples
  planFig();
  randGeno();
  moea_d_initialize(); // MOEA/D
  for generation_num=1:generations
    //// NSGA-II
    //growPheno();
    ////IEC(Display&Evaluate)
    ////xset("wpdim",700,300)
    //evaluate();
    //pseudoEvaluate();
    //pareto();
    ////Objective(:,:,generation_num,sample_num)
    //selectPair();
    //geneManipulate(); 
    
    // MOEA/D ���moead_initialize()��MOEA/D�Ŏg�p
    growPheno();
    //IEC(Display&Evaluate)
    //xset("wpdim",700,300)
    evaluate();
    pseudoEvaluate();
    moea_d_evaluate(); //evaluate()�ŒP�ړI��fitness���o���Cmoea_d()�ő��ړI�ɕ]��
    //pareto(); //debug: ���Ԃ�MOEA/D�ł͂���Ȃ��D���ʏo�͂ŕK�v�H
    //Objective(:,:,generation_num,sample_num)
    moea_d_selectPair(); //MOEA/D�̕��@�Őe�̑I��
    geneManipulate(); 
    moea_d_update(); //debug: ���ꂩ��MOEA/D�p�ɏC��

  end //for generation_num
  for individual_num=1:individuals
    subplot(3,7,individual_num);
    Matplot(Pheno(:,:,individual_num),'040'); //xgrid();
  end

end //for sample_num
///////////////////////////////////////////////////////////////////////////////
getdate()


//4�ړI�̃O���t
//ObjectiveMean=zeros(generations,4);
//for generation_num=1:generations
//    for objective_num=1:4
//      ObjectiveMean(generation_num,objective_num)=..
//      mean(Objective(:,objective_num,generation_num,:));
//    end
//end
//scf(); //Open New Figure
//xgrid();
//plot2d(1:generations,ObjectiveMean,rect=[0,0.5,generations,1],style=[1,1,1,1,1,1,1]);
//A=gca();
//P=A.children.children;
//P(4).line_style=1; P(4).thickness=2;
//P(3).line_style=2; P(3).thickness=2;
//P(2).line_style=3; P(2).thickness=2;
//P(1).line_style=4; P(1).thickness=2;
//xtitle('4 Objectives','Generation','Fitness');
//legend('Obj1 Area Size','Obj2 Proportion','Obj3 Circulation','Obj4 Sunlighting',4); 


//6�ړI�̃O���t
ObjectiveMean=zeros(generations,6);
for generation_num=1:generations
    for objective_num=1:6
      ObjectiveMean(generation_num,objective_num)=..
      mean(Objective(:,objective_num,generation_num,:));
    end
end
scf(); //Open New Figure
xgrid();
plot2d(1:generations,ObjectiveMean,rect=[0,0,generations,1],style=[1,1,1,1,1,1,1]);
A=gca();
P=A.children.children;
P(6).line_style=1; P(6).thickness=2;
P(5).line_style=2; P(5).thickness=2;
P(4).line_style=3; P(4).thickness=2;
P(3).line_style=4; P(3).thickness=2;
P(2).line_style=5; P(2).thickness=2;
P(1).line_style=6; P(1).thickness=2;
//P(7).line_style=6; P(7).thickness=2;
xtitle('6 Objectives','Generation','Fitness');
legend('Obj1 Area Size','Obj2 Proportion','Obj3 Circulation','Obj4 Sunlighting','Obj5 Wall','Obj6 Duct',4);


beep

save('Objective.dat',Objective)
