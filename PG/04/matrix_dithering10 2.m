%   ukol 1

function [ vysl ] = matrix_dithering10( obrazek )
[w, h] = size(obrazek);
vysl = zeros(w * 3, h * 3);
patern = [9*255/10 8*255/10 7*255/10; 6*255/10 5*255/10 4*255/10; 3*255/10 2*255/10 1*255/10];
display(patern);
for x = 1 : w
    for y = 1 : h
        px = obrazek(x, y);
        vysl(x * 3 - 2 : x * 3 + 0 , y * 3 - 2 : y * 3 + 0) = patern < [px px px; px px px; px px px];
    end
end
end

%   ukol 2
%   1. floyd_steinberg
%   2. obdoba matrix_dithering3
%   3. náhodný  rozptyl
%   4. matrix_dithering3


% dobry den, reseni jsem opravil. Funkci jsem spoustel, nicmene mi matlab vzdy vypise hlasku ze nemuze porovnavat string a double, ale
% pokud funkci nevolam z commandlinu ale vytvorim misto toho script ktery mi dela to stejne tak mi to funguje a vysledek se vykresli