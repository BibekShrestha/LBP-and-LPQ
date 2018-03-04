
%%%%Train Data
load ProcessedData/TrainImageData.mat;
load ProcessedData/TestImageData.mat;
load ProcessedData/ModelNames

NumberOfModels = size(ModelNames);
NumberOfModels = NumberOfModels(2);

ValueSet = 1:NumberOfModels;
KeySet = {};

for i = 1:NumberOfModels
    KeySet =  [ KeySet, ModelNames(i).Name];
end

ModelMap = containers.Map(KeySet,ValueSet);


NumberOfTrainImages  = size(TrainImages);
NumberOfTrainImages = NumberOfTrainImages(1);

NumberOfTestImages  = size(TestImages);
NumberOfTestImages = NumberOfTestImages(1);

FeaturesInputs = zeros( NumberOfTrainImages + NumberOfTestImages, 236 );


CameraTargets = zeros(NumberOfTrainImages + NumberOfTestImages, NumberOfModels);


for i = 1:NumberOfTrainImages
    ImageName = TrainImages.name(i);
    ImageClass = TrainImages.model(i);
    ImagePath = TrainImages.path(i);
    Image = imread(char(strcat('./Train',ImagePath,ImageName)) );
    
    
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
    
    FeaturesInputs(i,:) = horzcat(HFeature, VFeature,HFeatureNoise, VFeatureNoise);
    
    CameraTargets(i,ModelMap(char(ImageClass))) = 1;
    
       
end

index = i;






%%%Test data

for i = 1:NumberOfTestImages
    ImageName = TestImages.name(i);
    ImageClass = TestImages.model(i);
    ImagePath = TestImages.path(i);
    Image = imread(char(strcat('./Test',ImagePath,ImageName)) );
    
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
    
    FeaturesInputs(i,:) = horzcat(HFeature, VFeature,HFeatureNoise, VFeatureNoise);
    
end



save('ProcessedData/NN/FeaturesInupt','FeaturesInputs');
save('ProcessedData/NN/CameraTargets','CameraTargets');