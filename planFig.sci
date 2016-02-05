function planFig
//Room Color Mapping
roomcolormap=[255/255   255/255   0/255;      //#1 LR
              255/255   127.5/255 127.5/255;  //#2 DK
              127.5/255 255/255   0/255;      //#3 BR1
              0/255     255/255   127.5/255;  //#4 BR2
              127.5/255 255/255   127.5/255;  //#5 BR3
              0/255     255/255   255/255;    //#6 WA
              0.9       0.9       0.9;        //#7 Path
              0.5       0.5       1;          //#8 CommonCorridor
              0.5       0         1;          //#9 Veranda
              0         0         0.5;        //#10 Wall
              1         1         1];         //#11 Void
scf(); //Open New Figure
xset("colormap",roomcolormap);
//xset("colormap",graycolormap(rooms+4));//gray
endfunction
