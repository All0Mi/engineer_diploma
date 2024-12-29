function matchedTrajectories = mahalonobisTrajectories(detectedPoints, params)
    matchedTrajectories = []; % przechowuje połączone trajektorie

    if isempty(detectedPoints.trajectories)
        return;
    end

    % Obliczanie odległości Mahalanobisa dla każdego punktu
    sigma = diag([params.noiseStd(1)^2, params.noiseStd(2)^2]); % macierz kowariancji
    for t = 1:max(detectedPoints.trajectories(:, 3)) % iteracja po czasie
        currentDetections = detectedPoints.trajectories(detectedPoints.trajectories(:, 3) == t, 1:2);

        if ~isempty(currentDetections)
            for i = 1:size(currentDetections, 1)
                point = currentDetections(i, :);
                distances = mahal(point, currentDetections); % oblicz odległości Mahalanobisa

                % Dopasowanie punktów w zakresie odległości progowej
                threshold = params.matchThreshold; % próg dopasowania
                matchedIdx = find(distances < threshold);

                % Zapisanie dopasowanych punktów
                matchedTrajectories = [matchedTrajectories; point, t];
            end
        end
    end
end
