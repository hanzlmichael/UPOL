%% Priklad 1

% vytvorte transformacni strukturu pro funkce
% (x,y) = T{(w,z)} = (w+0.4z,z)
% (w,z) = T^(-1){(x,y)} = (x-0.4y, y)
% vyzkousejte na WZ  = [1 1; 3 2] 

dopredna_fce = @(wz,tdata)[(wz(:,1)) + (0.4*wz(:,2)),1*wz(:,2)]

zpetna_fce = @(xy,tdata)[ xy(:,1) - (0.4*xy(:,2)), 1*xy(:,2)]

tform2 = maketform('custom', 2,2,dopredna_fce, zpetna_fce, [])

%% aplikace transformace

WZ = [1 1; 3 2];
XY = tformfwd(WZ,tform2)
WZ2 = tforminv(XY,tform2)



%% Priklad 2
% Jak vypada afinni matice odpovidajici tform2

%afinni transformace odpovidajici tform2
T2 = [1 0 0; 
    0.4 1 0; 
      0 0 1];

tform3 = maketform('affine',T2);
WZ = [1 1; 3 2];
XY = tformfwd(WZ,tform2)
WZ2 = tforminv(XY,tform2)


%% Priklad 3 - java file
