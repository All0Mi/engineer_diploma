function trajectories = mahalanobisTrajectories(points, threshold)
    % INPUT:
    % detectedPoints - macierz wykryć [X, Y, czas]
    % maxPoints - maksymalna liczba punktów w trajektorii
    % threshold - maksymalna odległość Mahalanobisa dla przypisania do trajektorii
    % OUTPUT:
    % trajectories - lista utworzonych trajektorii
    
    % Sortowanie punktów według czasu
    points = sortrows(points, 3); % Kolumna 3 to czas
    maxPoints = 5;
    % Inicjalizacja zmiennych
    numPoints = size(points, 1);
    trajectories = {};
    assigned = false(numPoints, 1); % Tablica oznaczająca przypisanie punktów

    % Główna pętla tworzenia trajektorii
    for i = 1:numPoints
        if assigned(i)
            continue; % Punkt już należy do trajektorii
        end

        % Tworzenie nowej trajektorii
        trajectory = points(i, :); % Pierwszy punkt
        assigned(i) = true;

        % Wyszukiwanie kolejnych punktów do trajektorii
        for j = 1:numPoints
            if assigned(j)
                continue; % Punkt już przypisany
            end

            % Obliczenie odległości Mahalanobisa
            covMatrix = cov(trajectory(:, 1:2)); % Kowariancja X, Y
            if rank(covMatrix) < 2
                covMatrix = covMatrix + eye(size(covMatrix)) * 1e-6; % Korekta numeryczna
            end
            mahalDistance = sqrt((points(j, 1:2) - mean(trajectory(:, 1:2), 1)) / covMatrix ...
                * (points(j, 1:2) - mean(trajectory(:, 1:2), 1))');

            % Dodanie punktu do trajektorii, jeśli spełnia warunek
            if mahalDistance <= threshold
                trajectory = [trajectory; points(j, :)]; % Dodanie punktu
                assigned(j) = true;

                % Przerwanie, jeśli osiągnięto maksymalną liczbę punktów
                if size(trajectory, 1) >= maxPoints
                    break;
                end
            end
        end

        % Zapisanie trajektorii
        if size(trajectory, 1) >= 3 % Metoda "3 z 5"
            trajectories{end + 1} = trajectory;
        end
    end
end
