
IP1  = 'Iphone5s_1.JPG';
CN2 = 'Canon.JPG';

[PredictedModelName1,Probablity1,PredictedModelName2,Probablity2] = TestUsingNeuralNetwork(IP1);


figure;

subplot(221);
imshow(imread(IP1));
title('70-15-15');
ylabel('Target = Iphone 5s');
xlabel(strcat('Predicted =  ', PredictedModelName1, ' , ' ,string(Probablity1)));

subplot(222);
imshow(imread(IP1));
title('50-25-25');
ylabel('Target = Iphone 5s');
xlabel(strcat('Predicted =  ', PredictedModelName2, ' , ' ,string(Probablity2)));




[PredictedModelName1,Probablity1,PredictedModelName2,Probablity2] = TestUsingNeuralNetwork(BL2);
subplot(223);
imshow(imread(BL2));
title('70-15-15');
ylabel('Target = Canon EOS Rebel T6i');
xlabel(strcat('Predicted =  ', PredictedModelName1, ' , ' , string(Probablity1)) );



subplot(224);
imshow(imread(BL2));
title('50-25-25');
ylabel('Target = Canon EOS Rebel T6i');
xlabel(strcat('Predicted =  ', PredictedModelName2, ' , ' , string(Probablity2)));