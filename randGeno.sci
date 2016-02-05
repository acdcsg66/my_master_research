//set random points into Geno without overlapped rooms
function randGeno
global individuals rooms x_span y_span Geno sample_num

//shuffle rand with milli-second step in 24 hours�i���Ԃŗ������s�����͂�����Łj
//dt=getdate(); 
//N=60*60*1000*dt(7)+60*1000*dt(8)+1000*dt(9)+dt(10); 
//rand('seed',N)

//���������Ŏ������邽�߃T���v�����ŗ������`����
rand('seed',sample_num)
//rand('seed',1)

individual_num=1;
while individual_num<=individuals
  overlapFlag=0; //initialize
  for room_num=1:rooms
    Geno(room_num,1,individual_num)=int(rand()*x_span+2);
    Geno(room_num,2,individual_num)=int(rand()*y_span+2);
  end //for room_num
  for room1=1:rooms-1
    for room2=room1+1:rooms
      if Geno(room1,:,individual_num)==Geno(room2,:,individual_num)
        overlapFlag=1; //some rooms overlap
      end //if
    end //for room2
  end //for room1
  if overlapFlag==0 //no overlap
    individual_num=individual_num+1;
  end //if
end //while

endfunction
