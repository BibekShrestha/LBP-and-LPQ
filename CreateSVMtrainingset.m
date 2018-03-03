
%%%%Train Data 
load ProcessedData/TrainImageData.mat;
NumberOfImages  = size(TrainImages);
NumberOfImages = NumberOfImages(1);

Features = zeros( NumberOfImages, 118 );

for i = 1:NumberOfImages
    ImageName = TrainImages.name(i);
    ImageClass = TrainImages.model(i);
    ImagePath = TrainImages.path(i);
    Image = imread(char(strcat('./Train',ImagePath,ImageName)) );
    
    HSVimage = rgb2hsv(Image);
    HSpace = HSVimage(: , :, 1);
    VSpace = HSVimage(: , :, 2);
    HFeature = extractLBPFeatures(HSpace);
    VFeature = extractLBPFeatures(VSpace);
    Features(i,:) = horzcat(HFeature, VFeature);
    
    
end

Traindata = table(TrainImages.model, Features);
Traindata.Properties.VariableNames = {  'Class' , 'LBPFeatures' } ;

save('ProcessedData/Traindata.mat','Traindata');



%%%Test data


load ProcessedData/TestImageData.mat;
NumberOfImages  = size(TestImages);
NumberOfImages = NumberOfImages(1);


for i = 1:NumberOfImages
    ImageName = TestImages.name(i);
    ImageClass = TestImages.model(i);
    ImagePath = TestImages.path(i);
    Image = imread(char(strcat('./Test',ImagePath,ImageName)) );
    
    HSVimage = rgb2hsv(Image);
    HSpace = HSVimage(: , :, 1);
    VSpace = HSVimage(: , :, 2);
    HFeature = extractLBPFeatures(HSpace);
    VFeature = extractLBPFeatures(VSpace);
    Features(i,:) = horzcat(HFeature, VFeature);
    
    %Features =  vertcat( Features, horzcat(HFeature, VFeature)) ;
    
end

Testdata = table(TestImages.model,Features);
Testdata.Properties.VariableNames = {  'Class' , 'LBPFeatures' } ;

save('ProcessedData/Testdata.mat','Testdata');