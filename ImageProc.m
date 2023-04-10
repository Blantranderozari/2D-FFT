% Image Processing with 2D Fourier Transform
% by Iain Collings, 9 Dec 2020

img = imread('../ImageSmall.JPG')
ImSize = 600;
ImStart = 23;

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
        ftRed = exp(j.*angle(fft2(chRed)));
        ftGreen = exp(j.*angle(fft2(chGreen)));
        ftBlue = exp(j.*angle(fft2(chBlue)));
    end
    
    if FiltDomain == 1 % Low Pass Filter (LPF) via a square functin in the image domain
        filt=zeros(size(ftRed));
        filt(1:filtL,1:filtL)=one(filtL,filtL)/(filtL)^2;
        Filt = fft2(filt);
    elseif FiltDomain == 2 % Square LPF in the frequency domain
        FiltShift = zeros(size(ftRed));
        FiltBoxMin = ImSize/2 - filtL;
        FiltBoxMax = ImSize/2 + filtL;
        FiltShift(FiltBoxMin:FiltBoxMax,FiltBoxMin:FiltBoxMax) = ones(2*filtL+1,2*filtL+1);
        Filt = fftshift(FiltShift);
        filt=real(fftshift(ifft2(Filt)));
    elseif FiltDomain == 3 % Square HPF in the Freq domain
        FiltShift=ones(size(ftRed));
        FiltBoxMin = ImSize/2 - filtL;
        FiltBoxMax = ImSize/2 + filtL;
        FiltShift(FiltBoxMin:FiltBoxMax,FiltBoxMin:FiltBoxMax)= zeros(2*filtL+1,2*filtL+1);
        Filt = fftshift(FiltShift);
        filt=real(fftshift(ifft2(Filt)));
    elseif FiltDomain == 4 % Circular LPF in the Freq domain
        FiltShift=zeros(size(ftRed));
        for m=1:ImSize
            for n=1:ImSize
                if ((m-ImSize/2)^2+(n-ImSize/2)^2)<filtL^2
                    FiltShift(m,n)=1;
                end
            end
        end
        Filt = fftshift(FiltShift);
        filt = real(fftshift(ifft2(Filt)));
    elseif FiltDomain == 5 % Circular HPF in the Freq domain
        FiltShift=ones(ftRed);
        for m=1:ImSize
            for n=1:ImSize
                if((m-ImSize/2)^2+(n-ImSize/2)^2)<filtL^2
                    FiltShift(m,n)=0;
                end
            end
        end
        Filt = fftshift(FiltShift);
        filt = real(fftshift(ifft2(Filt)));
    elseif FiltDomain == 6 % Threshold
        FiltShift = (abs(fftshift(ftBlue))>(filtL*10^2));
        Filt = fftshift(FiltShift);
        filt = real(fftshift(ifft2(Filt)));
    end
    
    XRedFilt = ftRed .* Filt;
    XGreenFilt = ftGreen .* Filt;
    XBlueFilt = ftBlue .* Filt;
    
    XRedFilt = ifft2(XRedFilt);
    XGreenFilt = ifft2(XGreenFilt);
    XBlueFilt = ifft2(XBlueFilt);
    
    xFilt = img(ImStart:ImSize+ImStart-1,:,:);
    xFilt(:,:,1) = abs(XRedFilt);
    xFilt(:,:,2) = abs(XGreenFilt);
    xFilt(:,:,3) = abs(XBlueFilt);
    
    figure(1)
    image(xFilt) % filtered image
    title('Filtered Image','fontsize',20)
    
    figure(2)
    mesh(abs(fftshift(XBlueFilt))) % filtered image in FT domain
    axis([0 600 0 600 0 10^6])
    title('abs(Filtered FT of Image)','fontsize',20)
    
    figure(3)
    mesh(abs(fftshift(ftBlue - XBlueFilt))) % amount removed by LPF freq domain
    title('abs(Values Removed from FT of Image)','fontsize',20)
    
    figure(4)
    mesh(filt) % filter in image domain
    axis([270 330 270 330 0 max(max(filt))])
    title('abs(The filter in the Image domain)','fontsize',20)
    
    figure(5) 
    mesh(fftshift(real(Filt))) % filter in FT domain
    title('abs(The filter in the FT domain)','fontsize',20)
    
    pause
    
    if scene == 10
        figure(1)
        mesh(abs(xRedFilt))
        view(90,90)
    end
end

        