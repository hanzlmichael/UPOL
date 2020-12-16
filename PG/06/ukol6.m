%% ukol 1

A = imread('lenagraysum.bmp');

% vytvoøte prùmìrovací filtry s velikostmi 3x3, 4x4, 5x5, 6x6 a 10x10 a porovnejte mezi sebou výsledky. 

%% filter 4x4
w = 1/16 * [1 1 1 1;
	        1 1 1 1;
	        1 1 1 1];

B = imfilter(A,w,'corr','same');
imshow(B)

%% filter 5x5
w = 1/25 * [1 1 1 1 1;
	        1 1 1 1 1;
	        1 1 1 1 1;
            1 1 1 1 1;
	        1 1 1 1 1];

B = imfilter(A,w,'corr','same');
imshow(B)

%% filter 6x6
w = 1/36 * [1 1 1 1 1 1;
	        1 1 1 1 1 1;
	        1 1 1 1 1 1;
            1 1 1 1 1 1;
            1 1 1 1 1 1;
	        1 1 1 1 1 1];

B = imfilter(A,w,'corr','same');
imshow(B)

%% filter 10x10
w = 1/100 * [1 1 1 1 1 1 1 1 1 1;
	         1 1 1 1 1 1 1 1 1 1;
	         1 1 1 1 1 1 1 1 1 1;
             1 1 1 1 1 1 1 1 1 1;
             1 1 1 1 1 1 1 1 1 1;
	         1 1 1 1 1 1 1 1 1 1;
	         1 1 1 1 1 1 1 1 1 1;
             1 1 1 1 1 1 1 1 1 1;
             1 1 1 1 1 1 1 1 1 1;
	         1 1 1 1 1 1 1 1 1 1];

B = imfilter(A,w,'corr','same');
imshow(B)

%% ukol 2
% Vyberte vhodný filtr a odtraòte (minimalizujte) nežádoucí informaci v
% obrázcích:

%% obrazek 1

I1 = imread('pr6-img1.png');
w = 1/9 * [1 1 1; 
                 1 1 1; 
                 1 1 1];
PIC1 = imfilter(I1,w,'corr','same');

figure
subplot(1,2,1)
imshow(I1);
title('before')
subplot(1,2,2)
imshow(PIC1,[])
title('after')

%% obrazek 2

I2 = imread('pr6-img2.png');
PIC2 = medfilt2( I2,[3 3] );

figure
subplot(1,2,1)
imshow(I2);
title('before')
subplot(1,2,2)
imshow(PIC2,[])
title('after')

%% ukol 3
I3 = rgb2gray(imread('pr6-img3.png'));
w5 = [0 50 100;
      -50 0 50; 
      -100 -50 0];
Ires = imfilter(I3,w5,'corr','same');

figure
subplot(1,2,1)
imshow(I3);
title('before')
subplot(1,2,2)
imshow(Ires,[])
title('after')	

