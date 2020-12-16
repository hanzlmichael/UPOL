%% UKOL
% Upravte pøedchozí pøíklad tak, aby místo náhodných vzorkù z oblasti vybral vzorky v pravidelné møížce velikosti k x k.
% Nebo vybírejte vzorky z oblasti dle algoritmu n-vìží
% úprava se týká øádkù 226 až 229, staèí jeden z vybraných algoritmù. 
% Není potøeba implementovat oba. 
% vyzkoušejte výsledek i na jiných obrázcích (pro jednoduchost ètvercových)

C = imread('sachovnice.png');
[m,n] = size(C);

m1 = 100;
n1 = 100;
k = 5;

% velikosti oblasti:
mm = floor(m/m1);
nn = floor(n/n1);

M = eye(nn);
permutace = perms(1:nn);
pocet_permutaci = size(permutace,1);

% vytvorim oblast a z ni nahodne vyberu k vzorku a z nich vezmu prumer
for i = 1:m1
    for j = 1:n1
        oblast = C((i-1)*mm + 1 : i*mm, (j-1)*nn + 1 : j*nn); 
        x = randi(pocet_permutaci, 1);
        perm = M(:,permutace(x,:));
        vysl(i,j) = mean(oblast(1:k));
    end
end

imshow(imresize(vysl,10,'nearest'));