
 img = imread('cameraman.tif');
 
 [rows, cols] = size(img);
 binary_img = zeros(rows, cols); 
 for col = 1: cols
     
     for row = 1: rows
         
         if img(row, col) < 128
             binary_img(row, col) = 0;
         else
             binary_img(row, col) = 1;
         end
         
     end
 end
 
 subplot(121); imshow(img), title("Gray Scale Image");
 subplot(122); imshow(binary_img), title("Binary Image");

