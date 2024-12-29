%% symulacja detekcji radaru
function detectedPoints = radarDetection(trajectories, falsePoints, radar, params)
    % Inicjalizacja struktury wykryć
    detectedPoints.trajectories = [];
    detectedPoints.falsePoints = [];

    % Obliczanie progu detekcji na podstawie P_FA
    P_FA = params.P_FA; % prawdopodobieństwo fałszywego alarmu
    threshold = sqrt(-2 * log(1 - P_FA)); % próg dla rozkładu Rayleigha

    % Detekcja dla trajektorii
    for obj = 1:params.numObjects
        for t = 1:params.timeSteps
            currentPoint = squeeze(trajectories(obj, t, :))';
            distanceTx = norm(currentPoint - radar.transmitter);
            distanceRx = norm(currentPoint - radar.receiver);

            if (distanceTx + distanceRx) <= radar.range
                detectedPoints.trajectories = [detectedPoints.trajectories; ...
                    currentPoint, t]; % [X, Y, czas]
            end
        end
    end

    % Detekcja dla fałszywych punktów
    for fp = 1:params.numFalsePoints
        for t = 1:params.timeSteps
            currentPoint = squeeze(falsePoints(fp, t, 1:2))';
            RCS = falsePoints(fp, t, 3);
            distanceTx = norm(currentPoint - radar.transmitter);
            distanceRx = norm(currentPoint - radar.receiver);

            if (distanceTx + distanceRx) <= radar.range && RCS >= threshold
                detectedPoints.falsePoints = [detectedPoints.falsePoints; ...
                    currentPoint, t]; % [X, Y, czas]
            end
        end
    end
end
