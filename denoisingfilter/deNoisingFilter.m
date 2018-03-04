function [Noise] = deNoisingFilter(Im)
% function: deNoisingFilter(Images)
% %
%
% Author: Bipin Lekhak
%
% Major Project Start
%
% Date: Feb 25. 2018
% Time : 7:17 PM
%
% function to denoise a image: extracts PRNU from 4th level Dabuches
% transformation
%
% INPUT:
%     Im      Single image must be color image with size larger than
%     specified size by Mdes, Ndes
% OUTPUT:
%    Noise      Noise from image; 0 if any error
% EXAMPLE:
%   Image = imread('woman_color');
%   Noise = deNoisingFilter(Image);
% DEPENDENCIES:
% WaveNoise.m and Threshold.m
%
%

sigma = 3;      % LEt
var = sigma.^2;
Mdes = 1000;
Ndes = 750;

current = dwtmode('status','nodisp');
dwtmode('zpd','nodisp');

[M,N,three] = size(Im);

if(three ~= 3)
    Noise = 0;
else
    ImR = Im(:,:,1);    ImG = Im(:,:,2);    ImB = Im(:,:,3);
    if(M<N)
        temp = M;
        M = N;
        N = temp;
        clear temp;
        ImR = ImR'; ImG = ImG'; ImB = ImB';
    end
    if(M<Mdes)
        dM = floor((Mdes - M)/2);
        ImR = padarray(ImR, [dM, 0]);
        ImG = padarray(ImG, [dM, 0]);
        ImB = padarray(ImB, [dM, 0]);
    elseif(M>Mdes)
        ImR = imcrop(ImR, [(M-Mdes)/2 0 Mdes N]);
        ImG = imcrop(ImG, [(M-Mdes)/2 0 Mdes N]);
        ImB = imcrop(ImB, [(M-Mdes)/2 0 Mdes N]);
    end
    M = Mdes;
    if(N<Ndes)
        dN = floor((Ndes - N)/2);
        ImR = padarray(ImR, [0, dN]);
        ImG = padarray(ImG, [0, dN]);
        ImB = padarray(ImB, [0, dN]);
    elseif (N>Ndes)
        ImR = imcrop(ImR, [(M-Mdes)/2 0 Mdes N]);
        ImG = imcrop(ImG, [(M-Mdes)/2 0 Mdes N]);
        ImB = imcrop(ImB, [(M-Mdes)/2 0 Mdes N]);
    end
    N = Ndes;
    
    % for Red
    [cR,sR] = wavedec2(ImR, 4, 'db8');
    [HR4, VR4, DR4] = detcoef2('all',cR,sR,4);
    AR              = appcoef2(cR, sR, 'db8',4);
    
    % approximate noise
    HR4 = WaveNoise(HR4,var);
    VR4 = WaveNoise(VR4,var);
    DR4 = WaveNoise(DR4,var);
    AR = AR .* 0;
    
    % reconstrict image from wavelet
    cR = [reshape(AR,1,numel(AR)),...
        reshape(HR4,1,numel(HR4)),...
        reshape(VR4,1,numel(VR4)),...
        reshape(DR4,1,numel(DR4)),...
        cR( sR(1,1)*sR(1,2)+3*sR(2,1)*sR(2,2)+1:end)];
    ImR = waverec2(cR, sR, 'db8');
    
    
    %for Green
    [cG,sG] = wavedec2(ImG, 4, 'db8');
    [HG4, VG4, DG4] = detcoef2('all',cG,sG,4);
    AG              = appcoef2(cG, sG, 'db8',4);
    
    % approximate Noise
    HG4 = WaveNoise(HG4,var);
    VG4 = WaveNoise(VG4,var);
    DG4 = WaveNoise(DG4,var);
    AG = AG .* 0;
    
    % reconstrict image from wavelet
    cG = [reshape(AG,1,numel(AG)),...
        reshape(HG4,1,numel(HG4)),...
        reshape(VG4,1,numel(VG4)),...
        reshape(DG4,1,numel(DG4)),...
        cG(sG(1,1)*sG(1,2)+3*sG(2,1)*sG(2,2)+1:end)];
    ImG = waverec2(cG, sG, 'db8');
    
    %for Blue
    [cB,sB] = wavedec2(ImB, 4, 'db8');
    [HB4, VB4, DB4] = detcoef2('all',cB,sB,4);
    AB              = appcoef2(cB, sB, 'db8',4);
    
    % approximate noise
    HB4 = WaveNoise(HB4,var);
    VB4 = WaveNoise(VB4,var);
    DB4 = WaveNoise(DB4,var);
    AB = AB .* 0;
    
    % reconstrict image from wavelet
    cB = [reshape(AB,1,numel(AB)),...
        reshape(HB4,1,numel(HB4)),...
        reshape(VB4,1,numel(VB4)),...
        reshape(DB4,1,numel(DB4)),...
        cB(sB(1,1)*sB(1,2)+3*sB(2,1)*sB(2,2)+1:end)];
    ImB = waverec2(cB, sB, 'db8');
    
    % final concat
    Noise = cat(3, ImR, ImG, ImB);
end
dwtmode(current,'nodisp');
end
