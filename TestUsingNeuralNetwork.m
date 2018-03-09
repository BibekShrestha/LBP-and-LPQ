function[y1,p1,y2,p2] = TestUsingNeuralNetwork(ImageName)

%Test the imagesource using neural network trained previously.
%
% Author: 071BEX408' 071BEX410, 071BEX430, 071BEX432
% 
% [y1,y2] = TestUsingNeuralNetwork(ImageName) takes these arguments:
%   ImageName = Name of image to be tested
% and returns:
%   y1 = [ CameraModelName, Probablity of particular cameraModel] using 70-30 trained NN  , output #1
%   y2 = [ CameraModelName, Probablity of particular cameraModel] using 50-50 trained NN  , output #1


load ProcessedData/ModelNames.mat
Image = imread(ImageName);

HSVNoise = rgb2hsv(deNoisingFilter(Image));
HSVimage = rgb2hsv(Image);
    
HSpace = HSVimage(: , :, 1);
VSpace = HSVimage(: , :, 3);
    
HSpaceNoise = HSVNoise( : , : , 1);
VSpaceNoise = HSVNoise( : , : , 3);

HFeature = extractLBPFeatures(HSpace);
VFeature = extractLBPFeatures(VSpace);
HFeatureNoise = extractLBPFeatures(HSpaceNoise);
VFeatureNoise = extractLBPFeatures(VSpaceNoise);
FeaturesInputs = horzcat(HFeature, VFeature,HFeatureNoise, VFeatureNoise)';

[p1, Index1] = max(NeuralNetworkFunction70( FeaturesInputs ));
[p2, Index2] = max(NeuralNetworkFunction50( FeaturesInputs ));

y1 = ModelNames(Index1).Name;
y2 = ModelNames(Index2).Name;

