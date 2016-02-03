muMin = min(train_Input);
muMax = max(train_Input);

NumBasicFnsx = 7;
NumBasicFnsy = 7;

mu = zeros(NumBasicFnsx * NumBasicFnsy, 2);
s = (muMax - muMin) ./ (NumBasicFnsx); % controls basis function spread

for i = 1:NumBasicFnsx
    for j = 1:NumBasicFnsy
        % step in x direction
        mu((i-1) * NumBasicFnsx + j, 1) = muMin(1, 1) + (i-1) * ...
                                            (muMax(1, 1) - muMin(1, 1))/...
                                                (NumBasicFnsx - 1);
        
        % step in y direction
        mu((i - 1) * NumBasicFnsy + j, 2) = muMin(1, 2) + (j-1) * ...
                                               (muMax(1, 2) - muMin(1, 2))/...
                                               (NumBasicFnsy - 1);
    end
end

                                                
