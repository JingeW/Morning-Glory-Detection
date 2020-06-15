%% Segmentation and Detection based on the Ncut demo
%  Edit by: Jinge Wang

%% clear workspace and command window
clc
clear all
close all

%% input
% I = imread('IMG_5505.JPG');
I = imresize(imread('test.JPG'),0.25);
% I = imcrop(I,[2618,1571,127,127]);
% figure,imshow(I);

%% parameters
% kmeans parameter
K    = 4;                  % Cluster Numbers. K=2 has significant difference with others. The increasing of K won't affect result much.
% meanshift parameter
% bw   = 0.2;                % Mean Shift Bandwidth. Meanshift has the similar result with Kmeans

%% compare
Ikm          = Km(I,K);                     % Kmeans (color)
% [Ims, Nms]   = Ms(I,bw);                    % Mean Shift (color)

%% show
figure()
subplot(121); imshow(I);    title('Original'); 
subplot(122); imshow(Ikm); title(['Kmeans',' : ',num2str(K)]);
% subplot(122); imshow(Ims);  title(['MeanShift',' : ',num2str(Nms)]);


%% mask
% imtool(Ikm);
% imtool(Ims);
input = Ikm;
% input = Ims;
[m,n] = size(input(:,:,1));
Rmin = 256;
Gmin = 256;
Bmin = 256;
R = input(:,:,1);
G = input(:,:,2);
B = input(:,:,3);
for i = 1:m % find the minimum pixel value in each channel
    for j = 1: n
        if R(i,j) < Rmin
            Rmin = R(i,j);
        end
        if G(i,j) < Gmin
            Gmin = G(i,j);
        end
        if B(i,j) < Bmin
            Bmin = B(i,j);
        end
    end
end

output = zeros(m,n);
for i = 1:m  % use the minimum pixel value to set the threshold
    for j = 1:n
        if input(i,j,1) < Rmin + 0.0001 || input(i,j,2) < Gmin + 0.0001 || input(i,j,3) < Bmin + 0.0001 
            output(i,j) = 0;
        else
            output(i,j) = 1;
        end
    end
end

figure,imshow(output);
for i = 1:3
    result(:,:,i) = double(I(:,:,i)).*output;
end
figure,imshow(result/255);
% imtool(result/255);

%% detection in HSV color space
x=result/255;
% imtool(x);
% r=x(:,:,1);
% g=x(:,:,2);
% b=x(:,:,3);
xx=rgb2hsv(x);  % Transfer ino HSV color space
% x1=imadjust(x,[.2 .3 0; .6 .7 1],[]);imshow([x x1]);
H=xx(:,:,1);    % Purple is significantly represented in Hue channel
% S=xx(:,:,2);
% V=xx(:,:,3);
figure,imshow(H);

% h=imadjust(H,[0.3 0.7],[]);imshow(h);
% subplot(1,2,1);imshow(x);
% subplot(1,2,2);imshow(h);

%% Count
b = imbinarize(H,0.6); % Transfer to binary image
% figure;imshow(b);
cc = bwconncomp(b); % counting pixel clusters

fprintf('The detected morning glory number is %d', getfield(cc,'NumObjects'));

% pixel_list = getfield(cc,'PixelIdxList');
% for i = 1: size(pixel_list,2)
%     if length(cell2mat(pixel_list(i))) < 4
%        b(cell2mat(pixel_list(i))) = 0;
%     end
% end
% 
% figure;imshow(b);