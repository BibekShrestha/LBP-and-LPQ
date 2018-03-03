clc;
clear all;

load ProcessedData/Traindata.mat;
Classes = { char(Traindata.Class(1)),char(Traindata.Class(end))};

ModelSVM = fitcsvm( Traindata.LBPFeatures,Traindata.Class, 'ClassNames',Classes );

save('ProcessedData/TrainedSVM','ModelSVM');

save('ProcessedData/Classes','Classes')