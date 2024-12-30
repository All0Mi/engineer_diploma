function trajectories = mahalonobisTrajectories(detections, threshold)
    % Funkcja grupuje punkty detekcji w trajektorie na podstawie
    % odległości Mahalanobisa
    %
    % Wejście:
    % detections - macierz [X, Y, czas] punktów detekcji
    % threshold - próg odległości Mahalanobisa do grupowania
    %
    % Wyjście:
    % trajectories - komórka zawierająca trajektorie (każda trajektoria to macierz [X, Y, czas])

    % Inicjalizacja trajektorii
    trajectories = {};

    % Iteracja po każdym wykryciu
    for i = 1:size(detections, 1)
        point = detections(i, :); % [X, Y, czas]
        addedToTrajectory = false;

        % Przeszukiwanie istniejących trajektorii
        for j = 1:length(trajectories)
            traj = trajectories{j};
            lastPoint = traj(end, :); % ostatni punkt w trajektorii

            % Obliczanie macierzy kowariancji trajektorii
            if size(traj, 1) > 1
                covariance = cov(traj(:, 1:2)); % Obliczanie kowariancji dla współrzędnych X i Y
            else
                covariance = eye(2); % Jeśli trajektoria ma tylko jeden punkt, zakładaj jednostkową macierz kowariancji
            end

            % Obliczenie odległości Mahalanobisa (poprawione)
            delta = point(1:2) - lastPoint(1:2); % różnica pozycji (X, Y)
            % Sprawdzamy, czy macierz kowariancji jest odwrotna
            try
                invCovariance = inv(covariance);
                distance = sqrt(delta' * invCovariance * delta); % obliczenie odległości Mahalanobisa
            catch
                distance = inf; % Jeśli nie uda się obliczyć odwrotności (np. macierz jest osobliwa), ustawiamy odległość na nieskończoność
            end

            % Sprawdzenie, czy punkt należy do trajektorii
            if distance < threshold && point(3) > lastPoint(3) % czas musi być rosnący
                trajectories{j} = [trajectories{j}; point]; % dodaj punkt do trajektorii
                addedToTrajectory = true;
                break;
            end
        end

        % Jeśli punkt nie pasuje do żadnej trajektorii, twórz nową
        if ~addedToTrajectory
            trajectories{end+1} = point;
        end
    end
end
