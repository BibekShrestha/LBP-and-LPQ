clc ;
clear all;

Separator = '/ '; % if windows Separator = '\'
Models = strings(10);

cd ('Train');
camera_Makers = dir( );
camera_Makers = camera_Makers(3 :numel(camera_Makers) );
sizeA = size(camera_Makers);
Makers = strings(sizeA);



TotalNumberOfModels = 0;
Index = 0;

for i = 1:sizeA 
    Makers(i) = camera_Makers(i).name;
    cd( char(Makers(i)) );
    camera_Models = dir(  );
    camera_Models = camera_Models(3:numel(camera_Models) );
    Num_Models = size(camera_Models);
    
    Models = strings( Num_Models );
    
    
    
    
    for j = 1:Num_Models
        
        
        TotalNumberOfModels = TotalNumberOfModels +  1;
        
        Models(j) = camera_Models(j).name;
        ModelNames(TotalNumberOfModels).Name = char(Models(j));
        
        cd( char(Models(j) ));
        Samples =  [dir( '*.jpg'), dir( '*.JPG') ] ;
        
        
        Num_Samples = size(Samples);
        
        for k = 1:Num_Samples
            Index = Index  + 1;
            TrainImages(Index).name = char(Samples(k).name);
            TrainImages(Index).path = strcat( Separator , Makers(i ), Separator, Models(j), Separator  );
            TrainImages(Index).make = char( Makers( i ) );
            TrainImages(Index).model =  char( Models(j) );
        end
        cd('..');
        
        
    end
    cd('..');
            
end
cd('..')



TrainImages = struct2table(TrainImages);
save('ProcessedData/TrainImageData.mat','TrainImages');



cd ('Test');
camera_Makers = dir( );
camera_Makers = camera_Makers(3 :numel(camera_Makers) );
sizeA = size(camera_Makers);
Makers = strings(sizeA);
Index = 0;

for i = 1:sizeA 
    Makers(i) = camera_Makers(i).name;
    cd( char(Makers(i)) );
    camera_Models = dir(  );
    camera_Models = camera_Models(3:numel(camera_Models) );
    Num_Models = size(camera_Models);
    Models = strings( Num_Models );
    
    for j = 1:Num_Models
        Models(j) = camera_Models(j).name;
        cd( char(Models(j) ));
        Samples =  [dir( '*.jpg'), dir( '*.JPG') ] ;
        
        
        Num_Samples = size(Samples);
        
        for k = 1:Num_Samples
            Index = Index  + 1;
            TestImages(Index).name = char(Samples(k).name);
            TestImages(Index).path = strcat( Separator , Makers(i ), Separator, Models(j), Separator  );
            TestImages(Index).make = char( Makers( i ) );
            TestImages(Index).model =  char( Models(j) );
        end
        cd('..');
        
        
    end
    cd('..');
            
end
cd('..')


TestImages = struct2table(TestImages);
save('ProcessedData/TestImageData.mat','TestImages');
save('ProcessedData/ModelNames.mat','ModelNames');
