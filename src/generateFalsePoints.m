function falsePoints = generateFalsePoints(params, space)
    falsePoints = rand(params.numFalsePoints, params.timeSteps, 2);

    % Skalowanie do wymiarów przestrzeni
    falsePoints(:, :, 1) = falsePoints(:, :, 1) * space.width;
    falsePoints(:, :, 2) = falsePoints(:, :, 2) * space.height;

    % Generowanie wartości RCS zgodnie z rozkładem Rayleigha
    sigma = params.rayleighSigma;
    falsePointsRCS = raylrnd(sigma, params.numFalsePoints, params.timeSteps);
    falsePoints = cat(3, falsePoints, falsePointsRCS); % Dodanie trzeciego wymiaru dla RCS
end
