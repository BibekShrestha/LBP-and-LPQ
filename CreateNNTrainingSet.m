%%%%Train Data

load ProcessedData/TrainImages.mat;
load ProcessedData/TestImages.mat;
load ProcessedData/ModelNames;

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

NoiseInputs = zeros( NumberOfTrainImages + NumberOfTestImages, 236 );
FeaturesInputs = zeros( NumberOfTrainImages + NumberOfTestImages, 236 );


CameraTargets = zeros(NumberOfTrainImages + NumberOfTestImages, NumberOfModels);
Index = 0;


for i = 1:NumberOfTrainImages
    
    fprintf("Running %d of %d\n", Index + i,NumberOfTrainImages + NumberOfTestImages);
    
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
    a = ModelMap(char(ImageClass));
    CameraTargets(i,a) = 1;
       
end

Index = i;

%%%Test data

for i = 1:NumberOfTestImages
    
    fprintf("Running %d of %d\n", Index + i,NumberOfTrainImages + NumberOfTestImages);
    
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
    
    FeaturesInputs(i+ Index,:) = horzcat(HFeature, VFeature,HFeatureNoise, VFeatureNoise);
    
    CameraTargets(i + Index ,ModelMap(char(ImageClass))) = 1;
    
end



save('ProcessedData/NN/FeaturesInupts','FeaturesInputs');
save('ProcessedData/NN/CameraTargets','CameraTargets');