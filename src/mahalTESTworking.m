clear all
% Parametry symulacji
numPoints = 1000; % Liczba punktów do wygenerowania
xRange = [0, 200]; % Zakres współrzędnych X
yRange = [0, 200]; % Zakres współrzędnych Y
timeRange = [0, 10]; % Zakres czasu (w sekundach)

% Generowanie losowych punktów
detectedPoints = [rand(numPoints, 1) * (xRange(2) - xRange(1)) + xRange(1), ...
                  rand(numPoints, 1) * (yRange(2) - yRange(1)) + yRange(1), ...
                  rand(numPoints, 1) * (timeRange(2) - timeRange(1)) + timeRange(1)]; % Dodanie kolumny czasu

% Wizualizacja wygenerowanych punktów
figure;
scatter(detectedPoints(:, 1), detectedPoints(:, 2), 'x');
title('Wygenerowane punkty symulacyjne');
xlabel('X [km]');
ylabel('Y [km]');
grid on;

% Parametry trajektorii
maxPoints = 5;
threshold = 10; % Próg Mahalanobisa

% Wykrywanie trajektorii
trajectories = mahalanobisTrajectories(detectedPoints, threshold);

% Wizualizacja wyników
figure;
hold on;

% Rysowanie trajektorii i łączenie ich liniami
colors = lines(length(trajectories)); % Generowanie unikalnych kolorów
for i = 1:length(trajectories)
    traj = trajectories{i};
    % Rysowanie linii łączących punkty
    plot(traj(:, 1), traj(:, 2), '-o', 'Color', colors(i, :), 'LineWidth', 1.5, ...
        'DisplayName', ['Trajektoria ' num2str(i)]);
end

% Rysowanie wszystkich wykryć jako punkty
scatter(detectedPoints(:, 1), detectedPoints(:, 2), 50, 'kx', 'DisplayName', 'Wykrycia');

% Ustawienia wykresu
legend;
title('Analiza trajektorii z Mahalanobisem');
xlabel('X [km]');
ylabel('Y [km]');
grid on;
hold off;
