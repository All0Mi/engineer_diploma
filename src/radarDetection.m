%% symulacja detekcji radaru
function detectedPoints = radarDetection(trajectories, falsePoints, radar, params)
    % Inicjalizacja struktury wykryć
    detectedPoints.trajectories = []; 
    detectedPoints.falsePoints = [];

    % Detekcja dla trajektorii
    for obj = 1:params.numObjects
        for t = 1:params.timeSteps
            currentPoint = squeeze(trajectories(obj, t, :))';
            distanceTx = norm(currentPoint - radar.transmitter);
            distanceRx = norm(currentPoint - radar.receiver);
            
            % Suma odległości
            if (distanceTx + distanceRx) <= radar.range
                detectedPoints.trajectories = [detectedPoints.trajectories; ...
                    currentPoint, t]; % [X, Y, czas]
            end
        end
    end

    % Detekcja dla fałszywych punktów
    for fp = 1:params.numFalsePoints
        for t = 1:params.timeSteps
            currentPoint = squeeze(falsePoints(fp, t, :))';
            distanceTx = norm(currentPoint - radar.transmitter);
            distanceRx = norm(currentPoint - radar.receiver);
            
            % Suma odległości
            if (distanceTx + distanceRx) <= radar.range
                detectedPoints.falsePoints = [detectedPoints.falsePoints; ...
                    currentPoint, t]; % [X, Y, czas]
            end
        end
    end
end
