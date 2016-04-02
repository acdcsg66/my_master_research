function selectPair

global individuals Pareto Pair children x_span y_span Pheno NicheCount sigma_share ..
exponent_share

//Niching///////////////////////////////////
NicheCount=zeros(1,individuals);
Distance=zeros(individuals,individuals);
for i=1:individuals //”äŠrå‘Ì‚ÌŒÂ‘Ì”Ô†  
  for j=1:individuals //”äŠr‘Šè‚ÌŒÂ‘Ì”Ô†    
    for x=2:x_span+1
      for y=2:y_span+1
        if Pheno(x,y,i)~=Pheno(x,y,j) & i~=j & Pareto(1,i)==Pareto(1,j)
          Distance(i,j)=Distance(i,j)+1;
        end //if
      end //for y
    end //for x
    if Distance(i,j)<=sigma_share & Pareto(1,i)==Pareto(1,j) //“¯ƒ‰ƒ“ƒN‚Ì‘Šè‚Ì‚İ
      NicheCount(1,i)=NicheCount(1,i)+(1-(Distance(i,j)/sigma_share)^exponent_share);
    end //if
  end //for j
end //for i
/////////////////////////////////////////////

Fitness=zeros(1,individuals);
Mu=zeros(1,individuals); //ƒ‰ƒ“ƒN‚ÌŒÂ”iÅ‘å‚Å‚àŒÂ‘Ì”‚Í‚È‚¢‚¾‚ë‚¤‚ªj
for individual_num=1:individuals
  Mu(1,Pareto(1,individual_num))=Mu(1,Pareto(1,individual_num))+1;
end
for individual_num=1:individuals
  Fitness(1,individual_num)=individuals-..
  sum(Mu(1,1:(Pareto(individual_num)-1)))-0.5*(Mu(Pareto(individual_num))-1);
end
Fitness1=zeros(1,individuals);

Fitness1=Fitness./NicheCount; //Niching
//Fitness1=Fitness; //No Niching

Fitness2=zeros(1,individuals);
for individual_num=1:individuals

//Miki-Lab web
//  Fitness2(1,individual_num)=(sum(Fitness(1,1:Mu(Pareto(individual_num))))/..
//  sum(Fitness1(1,1:Mu(Pareto(individual_num)))))*Fitness1(1,individual_num);

//Deb book (Watanabe Dr. thesis)
  Fitness2(1,individual_num)=((Fitness(1,individual_num)*Mu(Pareto(individual_num)))/..
  sum(Fitness1(1,1:Mu(Pareto(individual_num)))))*Fitness1(1,individual_num);

end

FitnessNormal=Fitness2/sum(Fitness2); //‚»‚ê‚ğ³‹K‰»

Pair=zeros(children,2);
for children_num=1:children

  //parent1
  parent1=0;
  rand('seed',getdate('s'))
  roulette=rand();
    for individual_num=1:individuals
    if roulette>FitnessNormal(individual_num)
      roulette=roulette-FitnessNormal(individual_num);
    else
      parent1=individual_num;
     break
   end //if
  end // for individual_num

  //parent2
  parent2=0;
  while parent2==0
    rand('seed',getdate('s'))
    roulette=rand();
    for individual_num=1:individuals
      if roulette>FitnessNormal(individual_num)
        roulette=roulette-FitnessNormal(individual_num);
      elseif parent1~=individual_num //parent1~=parent2
        parent2=individual_num;
        break
      end //if
    end // for individual_num
  end //while

  Pair(children_num,1)=parent1;
  Pair(children_num,2)=parent2;

end //for children_num

endfunction
