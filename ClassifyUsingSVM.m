

load ProcessedData/TrainedSVM;
load ProcessedData/Classes.mat
load ProcessedData/Testdata

[label,score] = predict(ModelSVM,Testdata.LBPFeatures);
Compare = table( string(Testdata.Class),string(label) );
Compare.Properties.VariableNames = {  'True' , 'Predicted' } ;

TruePositives = (int8(Compare.True == Compare.Predicted));
ClassificationAccuracy = sum(TruePositives) .* 100./size(TruePositives,1);



