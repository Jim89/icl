function parameters = TrainClassifier2(input, output)

fit = fitcknn(input, output);
parameters = fit;