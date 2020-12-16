%% Vytvoøení jednoduchého obrázku
f = zeros(500);
f(200:300,230:270)=1;
imshow(f);

%% Fourierovo spektrum 
% Pøevod do frekvenèní domény - funkce fft2

F = fft2(f);
figure('name','Frekvencni domena'), imshow(F,[]);

%% Spektrum pak získáme pokud vezmeme absolutní hodnotu z výsledku
S = abs(F);
figure('name','Foufierovo spektrum'), imshow(S,[]);

%% centrovane fourierovo spektrum
Sc = fftshift(S);
figure('name','Centrovane foufierovo spektrum'), imshow(Sc,[]);

%% fftshift 
% Provede se posun o pùl periody doprava a dolù (tedy jako by se pøehodil 1. a 4.
% kvadrant a 2. a 3.
a = [1 2; 3 4];
fftshift(a)

%%
maximalni = max(max(Sc));
display(maximalni);

%% fourierovo spektum logaritmicka transformace
Scl = log(1+Sc);
figure('name','Centrovane foufierovo spektrum - logaritmicka transformace'), imshow(Scl,[]);

%% necentrovane fourierovo spektrum
S1 = ifftshift(Sc);
figure('name','Foufierovo spektrum'), imshow(S1,[]);

%% ifftshift

M = [1 2 3; 4 5 6; 7 8 9];
M2 = fftshift(M);

fftshift(M2)
ifftshift(M2)

%% Fáze

R = real(F);
I = imag(F);
phi = atan2(I,R);

%aphi = angle(F);

imshow(phi,[]);

%% Úkol 1
% Vytvoøte dva stejnì velké èernobílé obrázky. Obrázky mají èerné pozadí a
% obsahují stejnì velký bílý obdélník jen na jiném místì. Porovnejte
% spektra a fáze tìchto obrázkù

% vytvoreni 2 obrazku
f1 = zeros(500);
f1(200:300,140:180)=1;

f2 = zeros(500);
f2(200:300,320:360)=1;

figure 
subplot(1,2,1)
imshow(f1);
subplot(1,2,2)
imshow(f2);
%% reseni 1 ukol
F1 = fft2(f1);
S1 = abs(F1);
aphi1 = angle(F1);

F2 = fft2(f2);
S2 = abs(F2);
aphi2 = angle(F1);

figure 
subplot(2,2,1)
imshow(S1, [])
title('spektrum')

subplot(2,2,2)
imshow(S2, [])
title('spektrum')

subplot(2,2,3)
imshow(aphi1, [])
title('faze')

subplot(2,2,4)
imshow(aphi2, [])
title('faze')
%% prevod do prostorove domeny
f = ifft2(F);
f = real(f);

figure('name','Prostorova domena'), imshow(f,[]);


%% konvoluce ve frekvencni domene

f=imread('lenagraysum.bmp');
f = double(f);
imshow(f,[]);

%% vytvoreni idealniho LP filtru
[m,n] = size(f);

r=100;
H_ideal = lpfilter('ideal' , m, n, r) ;

imshow(H_ideal,[]);

%%
[xx,yy] = meshgrid(1:m,1:n);
plot3(xx,yy,fftshift(H_ideal));

%% vytvoreni butterworth LP filtru
[m,n] = size(f);

r=100;
rad=10;
H_btw = lpfilter('btw' , m, n, r,rad) ;

imshow(H_btw,[]);

%%
[xx,yy] = meshgrid(1:m,1:n);
plot3(xx,yy,fftshift(H_btw));

%% vytvoreni gauss LP filtru
[m,n] = size(f);

r=100;
H_gauss = lpfilter('gaussian' , m, n, r) ;

imshow(H_gauss,[]);

%%
[xx,yy] = meshgrid(1:m,1:n);
plot3(xx,yy,fftshift(H_gauss));

%% Úkol 2
% Vytvoøte ideální, butterworth a gaussùv high pass filtr a vyzkoušejte
% jeho aplikaci na obrázek (viz níže).
% High pass filtr (HPF) získáte z low pass filteru (LPF):
% HPF = 1 - LPF
HPF_ideal = 1-lpfilter('ideal',m,n,r);
HPF_btw = 1-lpfilter('btw',m,n,r,rad);
HPF_gauss = 1-lpfilter('gaussian',m,n,r);

F=fft2(f);

G=HPF_ideal.*F;
%G=HPF_btw.*F;
%G=HPF_gauss.*F;

f2=ifft2(G);
f2=real(f2);
figure,imshow(f2,[]);

%%
F=fft2(f);
G=HPF_ideal.*F;
f2=ifft2(G);
f2=real(f2);
figure
subplot(1,2,1);
imshow(f2,[]);
subplot(1,2,2);
imshow(f,[]);

%% Aplikace filtru

F = fft2(f);
%fitrovani
G = H_ideal.*F;
%G = H_btw.*F;
%G = H_gauss.*F;

%prevod zpet
f2=ifft2(G);

f2 = real(f2);

figure,imshow(f2,[]);


%%

%konvolucni maska
h = [1.0 1.0 1.0; 1.0 1.0 1.0; 1.0 1.0 1.0];
h = h * (1/9);

F = fft2(f);

%vytvoreni masky ve frekvencni domene o velikosti stejne jako je obrazek
H = freqz2(h, m, n);

H1 = ifftshift(H);

%fitrovani
G = H1.*F;

%prevod zpet
f2=ifft2(G);

f2 = real(f2);

figure,imshow(f2,[]);

%% Úkol 3
% vytvoøte pomocí funkce freqz2 nìjaký ostøící filtr a aplikujte ho na
% obrázek
h = [-1 -1; 1 1];
H = freqz2(h, m, n);
H1 = ifftshift(H);
G = H1.*F;
f2=ifft2(G);
f2 = real(f2);
figure,imshow(f2,[]);

%% Porovnání filtrování v doménách

f=imread('lenagraysum.bmp');
[m,n] = size(f);
f = double(f);

h = 1/100*ones(10);
H = freqz2(h, m, n);
H1 = ifftshift(H);

%% prostorova
tic();
gp = imfilter(f,h,'conv','same');
toc()

imshow(gp,[]);

%% frekvencni
tic();
F = fft2(f);
G = H1.*F;
gf=real(ifft2(G));
toc()

figure, imshow(gf,[]);

%% rozdil
d = abs(gp(10:end-10,10:end-10) - gf(10:end-10,10:end-10));

max(d(:)) % maximální rozdíl
min (d(:))