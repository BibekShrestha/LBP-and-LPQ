A = dir;
sizeA = size(A);
K = strings(sizeA);



A = dir('*.jpg');
sizeA = size( A );
K = strings( sizeA );
Features = [ ];

for i = 1:sizeA 
    
    K(i) = A(i).name;
    image = imread( char(K(i) ) );
    HSVimage = rgb2hsv(image);
    HSpace = HSVimage(: , :, 1);
    VSpace = HSVimage(: , :, 2);
    HFeature = extractLBPFeatures(HSpace);
    VFeature = extractLBPFeatures(VSpace);
    Features =  vertcat( Features, horzcat(HFeature, VFeature)) ;
end

Tab = table( K, Features);
save('table.mat','Tab')


