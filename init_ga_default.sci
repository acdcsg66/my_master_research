// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - Yann COLLETTE <yann.collette@renault.com>
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Pop_init = init_ga_default(popsize,param)

global initial_num

    if initial_num~=sample_num //各試行のはじめだけ初期化，それ以外は前の世代を引き継ぐ
        initial_num=sample_num;
        if ~isdef("param","local") then
            param = [];
        end
        // We deal with some parameters to take into account the boundary of the domain and the neighborhood size
        [Dim,err]       = get_param(param,"dimension",2);
        [MinBounds,err] = get_param(param,"minbound",-2*ones(1,Dim));
        [MaxBounds,err] = get_param(param,"maxbound",2*ones(1,Dim));

        // Pop_init must be a list()
        Pop_init = list();
        for i=1:popsize
            end_flag=0;
            while end_flag==0
                end_flag=1;
                Pop_init(i) = (MaxBounds - MinBounds).*grand(size(MaxBounds,1),size(MaxBounds,2),"def") + MinBounds;
                //debug: 被ったら再生成
                for r1=1:rooms //x軸に同じ座標がないかチェック
                    for r2=r1:rooms
                        if (int8(Pop_init(i)(r1)) == int8(Pop_init(i)(r2)) & r1~=r2) & ..
                        (int8(Pop_init(i)(r1+rooms)) == int8(Pop_init(i)(r2+rooms)) & r1~=r2) //x軸y軸が同じ座標の個体ペアがあればやり直し
                            end_flag=0;
                        end //if
                   end //for r2
                end //for r1
            end //while
        end //for i
    else
        Pop_init = list();
        for i=1:popsize
            Pop_init(i)=pop_opt(i)
        end
    end //if
endfunction

