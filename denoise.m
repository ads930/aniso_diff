function new_im = denoise(noisy_image, K, dx)
dy = dx; % Even though dx = dy, for the sake of keeping the notation consistent, they are different variables
noisy_laplacian = zeros(size(noisy_image));
grad = zeros(size(noisy_image));
c = zeros(size(noisy_image));
sigma = 0.5;
halfwid = 3*sigma;
[xx,yy] = meshgrid(-halfwid:halfwid, -halfwid:halfwid);
gau = exp(-1/(2*sigma^2) * (xx.^2 + yy.^2));
gau = gau/sum(gau(:));
for i = 2: size(noisy_laplacian, 1) - 1
    for j = 2:size(noisy_laplacian, 2) - 1
            %Calculate Laplacian of noisy image using finite difference approx.
            %of second derivative
            Ixx = (noisy_image(i + 1, j) - 2*noisy_image(i, j) + noisy_image(i - 1, j))/dx^2;
            Iyy = (noisy_image(i, j + 1) - 2*noisy_image(i, j) + noisy_image(i, j - 1))/dy^2;
            noisy_laplacian(i,j) = Ixx + Iyy; 
    
    
            %Calculate gradient of noisy image using the same method as above
            Ix = (noisy_image(i + 1, j) - noisy_image(i - 1, j))/dx;
            Iy = (noisy_image(i, j + 1) - noisy_image(i, j - 1))/dy;
            grad(i,j) = Ix + Iy;
    
    
            % calculate diffusion coefficient
            gradient_norm = sqrt(double(Ix^2) + double(Iy^2));
            %c(i,j) = exp(-(gradient_norm / K).^2);
            %c(i,j) = 1/(1 + (gradient_norm/K).^2);
    end
end
c(:,:) = exp(-(image_grad(imfilter(noisy_image, gau), 1)/K).^2); %another choice of diffusion coefficient

%find gradient of c
gradc = image_grad(c, 1);

new_im = gradc .* grad + noisy_laplacian .* c; %output

end





function out = image_grad(image, dx) %gradient helper function
    
    init = zeros(size(image));
    for k = 2: size(image, 1) - 1
        for l = 2:size(image, 2) - 1
            cx = (image(k + 1, l) - image(k - 1, l))/dx;
            cy = (image(k, l + 1) - image(k, l - 1))/dx;
            init(k,l) = cx + cy ;
        end
    end
    out = init;
end
