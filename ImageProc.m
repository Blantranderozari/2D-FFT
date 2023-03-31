% Image Processing with 2D Fourier Transform
% by Iain Collings, 9 Dec 2020

img = imread('../ImageSmall.JPG')
imgSize = 600;
imgStart = 23;

chRed=img(imgStart:imgSize+imgStart-1,:,1);
chGreen=img(imgStart:imgSize+imgStart-1,:,2);
chBlue=img(imgStart:imgSize+imgStart-1,:,3);

filtL = 298;
FiltDomain = 2;
imgFT = 2;

for scene = 1:10
    if scene == 2
    filtL=100;
    elseif scene == 3
    filtL=50;
    elseif scene == 4
    filtL=10;
    elseif scene == 5
    filtL=50;
    FiltDomain = 3;
    elseif scene == 6
    filtL=100;
    FiltDomain = 6;
    elseif scene == 7
    filtL=500;
    elseif scene == 8
    filtL=1000;
    elseif scene == 9
    filtL=0.001;
    ImgFT=2;
    elseif scene == 10
    ImgFT=3;
    end
    
    if imgFT == 1 % full image FT, return complex matrix
        ftRed = fft2(chRed);
        ftGreen = fft2(chGreen);
        ftBlue = fft2(chBlue);
    elseif imgFT == 2 % return only the abs (magnitude) 
        ftRed = abs(fft2(chRed));
        ftGreen = abs(fft2(chGreen));
        ftBlue = abs(fft2(chBlue));
    elseif imgFT == 3 % return only phase (angle) of image fourier transform
        ftRed = angle(j.*angle(fft2(chRed)));
        ftGreen = angle(j.*angle(fft2(chGreen)));
        ftBlue = angle(j.*angle(fft2(chBlue)));
    end
end
        
        