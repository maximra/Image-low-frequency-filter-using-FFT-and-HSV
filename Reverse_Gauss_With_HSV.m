clc
clear
close all
%% 
try  % checking whether or not the file is even there.
    file_name='wald-alt.jpg';
    img=imread(file_name);   
catch
    disp("Failed to open the image, exiting.")
    return;
end

[rows, columns, numcolors]=size(img);  % extracting proportions

inverted_gauss=zeros(rows,columns);   % generating inverted gauss function
var=(1/0.6931471806)*(1/10000)*(rows^2+columns^2);
for row=1:rows 
    for column=1:columns
        inverted_gauss(row,column)=1-exp(-1*(1/var)*((row-(rows/2)).^2+(column-(columns/2)).^2));
    end
end
figure;                          % Figure of inverted gauss
imshow(uint8(255*inverted_gauss))
title("Inverted gauss image")
%%
if numcolors>1          % In case the image is a RGB image
    converted_image=rgb2hsv(img); %% Converting image to HSV format (this is more correct).
     % generally speaking, this way we can retain the original colors to a
     % greater extent when compared to the previous approach of performing
     % three seperate frequency conversions for each seperate color.
    fft_v=fftshift(fft2((converted_image(:,:,3)))).*inverted_gauss;        % converting to frequency domain and multiplying by the inverted gauss  

    fft_v_restored=(abs(ifft2(ifftshift(fft_v))));    % Restoring the image back to time domain 
    converted_image(:,:,3)=fft_v_restored;
    converted_image=hsv2rgb(converted_image); %% Restoring the image to RGB format

else            % In case the image is a grayscale image
    fft_gray=fftshift(fft2(double(img))).*inverted_gauss;        % converting to frequency domain and multiplying by the inverted gauss
    fft_gray_restored=uint8(abs(ifft2(ifftshift(fft_gray))));    % Restoring the image back to time domain and 8 bit unsigned

    converted_image=fft_gray_restored;

end
figure;
imshow(converted_image)
new_file_name=file_name(1:end-4)+"_new_hsv.jpg";
disp(new_file_name)
imwrite(converted_image,new_file_name)
