function parameters = TrainClassifier2(input, output)

fit = fitcknn(input, output, ...
              'Standardize', 1, ...
              'CrossVal', 'on');

parameters = fit;