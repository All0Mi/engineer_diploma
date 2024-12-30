%% symulacja detekcji radaru
function detectedPoints = radarDetectionWithRCS(trajectoriesWithRCS, falsePoints, radar, params)
    detectedPoints.trajectories = [];
    detectedPoints.falsePoints = [];

    % Obliczanie progu detekcji na podstawie P_FA
    P_FA = params.P_FA; % prawdopodobieństwo fałszywego alarmu
    threshold = sqrt(-2 * log(1 - P_FA)); % próg dla Rayleigha (szum)

    % Detekcja dla trajektorii (prawdziwych obiektów)
    for obj = 1:params.numObjects
        for t = 1:params.timeSteps
            currentPoint = squeeze(trajectoriesWithRCS(obj, t, 1:2))'; % Pozycja
            RCS = trajectoriesWithRCS(obj, t, 3); % RCS obiektu

            distanceTx = norm(currentPoint - radar.transmitter);
            distanceRx = norm(currentPoint - radar.receiver);

            if (distanceTx + distanceRx) <= radar.range && RCS >= threshold
                detectedPoints.trajectories = [detectedPoints.trajectories; ...
                    currentPoint, t]; % [X, Y, czas]
            end
        end
    end

    % Detekcja dla fałszywych punktów (bez zmian)
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
