close all;
clear all;

[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
s=[path,file];
im=imread(s);

subplot(2,2,1),imshow(im);
title('Input Image');
imgray = rgb2gray(im);
subplot(2,2,2),imshow(imgray);
title('Gray Image');
imbin = im2bw(imgray);
subplot(2,2,3),imshow(imbin);
title('Binary Image');
im = edge(imgray, 'prewitt');
subplot(2,2,4),imshow(im);
title('After Edge detection');
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox=Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

im = imcrop(imbin, boundingBox);%crop the number plate area
im = bwareaopen(~im, 50); %remove some object if it width is too long or too small than 50

 [h, w] = size(im);%get width

save('im','im')

Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
count = numel(Iprops);
%display(count);
noPlate=[]; % Initializing the variable of number plate string.


for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
  
   if ow<(h/2) && oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
     
       noPlate=[noPlate letter]; % Appending every subsequent character in noPlate variable.
   end
end
display(noPlate);
file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s\n',noPlate);
    fclose(file);                     
    open('number_Plate.txt')
