function parameters = TrainClassifier1(input, output)

fit = fitcsvm(input, output);
parameters = fit;