function userEvaluate
global individuals Pareto Pair children x_span y_span Pheno Objective ..
generation_num sample_num

Hoge=ones(3,7);
//editvar Hoge
input Hoge

Hoge(1,:)=Objective(1:7,7,generation_num,sample_num);





try
m=evstr(x_dialog('enter a  3x3 matrix ',['[0 0 0';'0 0 0';'0 0 0]'])) 
catch
a=1+1
end

endfunction
