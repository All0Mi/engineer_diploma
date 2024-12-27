function falsePoints = generateFalsePoints(params, space)
    falsePoints = rand(params.numFalsePoints, params.timeSteps, 2);
    % Skalowanie do wymiarów przestrzeni
    falsePoints(:, :, 1) = falsePoints(:, :, 1) * space.width;
    falsePoints(:, :, 2) = falsePoints(:, :, 2) * space.height;
end