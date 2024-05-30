clc
clear
close all


og_image = imread("sevilla.jpg"); %import image
%og_image = im2gray(og_image); %make the image greyscale if necessary
noisy_image = imnoise(og_image, 'speckle'); %create noisy image
[r_noise,g_noise,b_noise] = imsplit(noisy_image);
K = [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 200 300 400 500 600 700]; %initialize values of K
denoisedSSIM = zeros(size(K));
o = 1;
dx = 1;
dt = 0.25;
iter = 100;
for i = K

    r = denoise_time(r_noise, i, dx, dt, iter);
    g = denoise_time(g_noise, i, dx, dt, iter);
    b = denoise_time(b_noise, i, dx, dt, iter);
    denoised_image = cat(3, r,g,b);
    denoisedSSIM(o) = ssim(uint8(denoised_image), og_image);
    o = o + 1;
end
fig = figure;
plot(K, denoisedSSIM, 'LineWidth', 1.5)
grid on
xlabel('K')
ylabel('Structural Similarity Index')
title('Structural Similarity vs K')

%% test code
% K = 25;
% r4 = denoise_time(r_noise, K, 1, dx, dt, iter);
% g4 = denoise_time(g_noise, K, 1, dx, dt, iter);
% b4 = denoise_time(b_noise, K, 1, dx, dt, iter);
% denoised_image4 = cat(3, r4, g4, b4);
% figure;
% subplot(2,1,1)
% imshow(noisy_image)
% title('Noisy Image')
% subplot(2,1,2)
% imshow(uint8(denoised_image))
% title('Denoised Image')

