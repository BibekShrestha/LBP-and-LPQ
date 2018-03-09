
%%%%Train Data
load ProcessedData/TrainImages.mat;
NumberOfImages  = size(TrainImages);
NumberOfImages = NumberOfImages(1);

Features = zeros( NumberOfImages, 236 );

for i = 1:NumberOfImages
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
    
    Features(i,:) = horzcat(HFeature, VFeature,HFeatureNoise, VFeatureNoise);
    
    
end

Traindata = table(TrainImages.model, Features);
Traindata.Properties.VariableNames = {  'Class' , 'LBPFeatures' } ;

save('ProcessedData/Traindata.mat','Traindata');



%%%Test data


load ProcessedData/TestImages.mat;
NumberOfImages  = size(TestImages);
NumberOfImages = NumberOfImages(1);

Features = zeros( NumberOfImages, 236 );

for i = 1:NumberOfImages
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
    
    Features(i,:) = horzcat(HFeature, VFeature,HFeatureNoise, VFeatureNoise);
    
    %Features =  vertcat( Features, horzcat(HFeature, VFeature)) ;
    
end

Testdata = table(TestImages.model,Features);
Testdata.Properties.VariableNames = {  'Class' , 'LBPFeatures' } ;

save('ProcessedData/Testdata.mat','Testdata');