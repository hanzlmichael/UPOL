%% redundance kodovani

I1 = rgb2gray(imread('red1.png'));
imshow(I1);
[M,N] = size(I1);

%%
unique(I1)
n = imhist(I1);
p = n/(M*N);

%%
unique(I1)
p(unique(I1)+1)

%% kod - pocet bitu pouzitych k zakodovani
l1 = 8*ones(256,1);

l1_avg = sum(l1.*p);
display(l1_avg);

%%
% 87 : 000
% 127 : 1
% 195 : 01
% 239 : 001
l2 = zeros(256,1);
l2(88)=3;
l2(128) = 1;
l2(196) = 2;
l2(240) = 3;

l2_avg = sum(l2.*p);
display(l2_avg);


%% Komprese a relativni redundance
b1 = M*N*l1_avg;
b2 = M*N*l2_avg;

C = b1/b2;
display(C);

R = 1-(1/C);
display(R);

%% Úkol 1
% Spoèítejte kompresi a relativní redundanci pokud v pøíkladu ze slidu 4
% vezmete, že každá barva je kódována 2 bity.

% komprese = (256 * 256 * 8)/(256 * 256 * ) = 4
% relativni redundance = 1 - (1/4) => 75 % dat je redundantních

%% Prostorova redundance

% I2 = (uint8(repmat((0:255)',1,256))).*uint8(ones(256));
% per = randperm(256);
% I2 = I2(per,:);
% imwrite(I2,'red2.png');
% imshow(I2);

I2 = imread('red2.png');
imshow(I2);
[M,N] = size(I2);

%%
%unique(I2)
imhist(I2);
%%
n = imhist(I2);
p = n/(M*N);

%% Úkol 2
% Spoèítejte kompresi a relativní redundanci pokud obraz I2 kódujeme 8
% bitama na intenzitu a pokud použijeme pro každý øádek 1 byte pro
% intenzitu a 1 byte pro poèet opakujících se prvkù.

% komprese:  (256 * 256 * 8)/(256 * 16) = 128
% relativni redundance dat:  1 - (1/128) => 99.21875% dat je redundantnich 

%% Nerelevantni informace

I3 = 125*(ones(256));
[M,N] = size(I3);
sum = (randi([-2, 2], M, N));
I3 = uint8(I3+sum);
I3(20:60,:) = 125;
I3(:,20:60) = 125;
imshow(I3);

%imwrite(I3,'red3.png');

%imshow(I3,[]);
%%
P = 125*(ones(256));
[M,N] = size(P);

imshow(P);

%%
imhist(I3,256);

%% Entropie
I1 = imread('red1.png');
imshow(I1);
I2 = imread('red2.png');
figure, imshow(I2);
I3 = imread('red3.png');
figure, imshow(I3);

J1 = entropy(I1);
J2 = entropy(I2);
J3 = entropy(I3);

display(J1);
display(J2);
display(J3);

%% mean-squared error
I = imread('pastelkygray.jpg');
I_noise = imnoise(I,'salt & pepper', 0.02);

subplot(1,2,1), imshow(I);
subplot(1,2,2), imshow(I_noise);

% immse = Mean-Squared Error.
mse = immse(I, I_noise);
display(mse);

% root mean-squared error

rmse = sqrt(immse(I, I_noise));
display(rmse);

%% Úkol 3
% spoèítejte chybu pro obrázek I3 a jeho úpravu, kdy je nahrazen jen jednou
% hodnotou (125).

%vytvorim obrazek kde mam hodnoty pixelu 125
P = 125*(ones(256));
P = uint8(P+0);

% immse = Mean-Squared Error.
mse = immse(P, I3);
display(mse);

% root mean-squared error
rmse = sqrt(immse(P, I3));
display(rmse);

%% JPEG

I = imread('pastelkygray.jpg');

imwrite(I,'p100.jpg','Quality', 100);
imwrite(I,'p80.jpg','Quality', 80);
imwrite(I,'p50.jpg','Quality', 50);
imwrite(I,'p10.jpg','Quality', 10);
imwrite(I,'p5.jpg','Quality', 5);

I1 = imread('p100.jpg');
I2 = imread('p80.jpg');
I3 = imread('p50.jpg');
I4 = imread('p10.jpg');
I5 = imread('p5.jpg');

subplot(2,2,1), imshow(I2);
subplot(2,2,2), imshow(I3);
subplot(2,2,3), imshow(I4);
subplot(2,2,4), imshow(I5);

%%

imfinfo('p100.jpg')
imfinfo('p5.jpg')



