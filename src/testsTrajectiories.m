clear all;
[space,params] = initializeSimulation();
detectedTrajectories = generateTrajectory(params, space);
falsePoints = generateFalsePoints(params, space);

%% wstępna wizualizacja
hold on;
for obj = 1:params.numObjects
    plot(squeeze(detectedTrajectories(obj, :, 1)), squeeze(detectedTrajectories(obj, :, 2)), '-o');
end
scatter(falsePoints(:,1,1), falsePoints(:,1,2), 'r*');
title('Trajektorie i punkty fałszywe');
xlabel('X [km]');
ylabel('Y [km]');
hold off;

%% Test bistatycznego radaru - wizualizacja tylko wykryć
radar = initializeRadar();
detectedPoints = radarDetection(detectedTrajectories, falsePoints, radar, params);

figure;
hold on;
scatter(radar.transmitter(1), radar.transmitter(2), 100, 'bs', 'filled', 'DisplayName', 'Nadajnik');
scatter(radar.receiver(1), radar.receiver(2), 100, 'ms', 'filled', 'DisplayName', 'Odbiornik');
if ~isempty(detectedPoints.trajectories)
    scatter(detectedPoints.trajectories(:, 1), detectedPoints.trajectories(:, 2), 'go', 'DisplayName', 'Trajektorie wykryte');
end
if ~isempty(detectedPoints.falsePoints)
    scatter(detectedPoints.falsePoints(:, 1), detectedPoints.falsePoints(:, 2), 'kx', 'DisplayName', 'Fałszywe punkty wykryte');
end
title('Wykrycia bistatycznego radaru');
xlabel('X [km]');
ylabel('Y [km]');
legend;
hold off;

%% wizualizacja z szumem
noiseStd = [0.5, 0.5]; %zaklócenia 500m w każdej osi
noisyTrajectories = addNoiseToDetections(detectedPoints.trajectories, noiseStd);
noisyFalsePoints = addNoiseToDetections(detectedPoints.falsePoints, noiseStd);


figure;
hold on;
scatter(radar.transmitter(1), radar.transmitter(2), 100, 'bs', 'filled', 'DisplayName', 'Nadajnik');
scatter(radar.receiver(1), radar.receiver(2), 100, 'ms', 'filled', 'DisplayName', 'Odbiornik');
if ~isempty(noisyTrajectories)
    scatter(noisyTrajectories(:, 1), noisyTrajectories(:, 2), 'g+', 'DisplayName', 'Trajektorie zaszumione');
end
if ~isempty(noisyFalsePoints)
    scatter(noisyFalsePoints(:, 1), noisyFalsePoints(:, 2), 'k+', 'DisplayName', 'Fałszywe punkty zaszumione');
end

% Punkty trajektorii wykryte przez radar (przed dodaniem szumu, dla
% porównania)
if ~isempty(detectedPoints.trajectories)
    scatter(detectedPoints.trajectories(:, 1), detectedPoints.trajectories(:, 2), 'ro', 'DisplayName', 'Trajektorie wykryte');
end
title('Wykrycia radarowe z zakłóceniami');
xlabel('X [km]');
ylabel('Y [km]');
legend;
hold off;

%% Po nałożeniu RCS:
figure;
hold on;
for obj = 1:params.numObjects
    plot(1:params.timeSteps, squeeze(detectedTrajectories(obj, :, 3)), '-o');
    %disp(squeeze(trajectories(obj, :, 3)));
end
title('RCS prawdziwych obiektów w czasie');
xlabel('Czas [krok symulacji]');
ylabel('RCS');
hold off;

figure;
hold on;
for obj = 1:params.numObjects
    plot(1:params.timeSteps, squeeze(falsePoints(obj, :, 3)), '-o');
    %disp(squeeze(trajectories(obj, :, 3)));
end
title('RCS fałszwych obiektów w czasie');
xlabel('Czas [krok symulacji]');
ylabel('RCS');
hold off;

%% Filtracja i analiza trajektorii za pomocą przestrzeni Mahalanobisa + metoda 3 z 5
points = [];
if ~isempty(noisyTrajectories) && ~isempty(noisyFalsePoints)
    points = [noisyTrajectories; noisyFalsePoints]; % Łączenie macierzy
end

threshold = 10; % Próg Mahalanobisa
detectedTrajectories = mahalanobisTrajectories(points, threshold);

figure;
hold on;
colors = lines(length(detectedTrajectories)); 
for i = 1:length(detectedTrajectories)
    traj = detectedTrajectories{i};
    plot(traj(:, 1), traj(:, 2), '-o', 'Color', colors(i, :), 'LineWidth', 1.5, ...
        'DisplayName', ['Trajektoria ' num2str(i)]);
end
% Rysowanie wszystkich wykryć:
scatter(points(:, 1), points(:, 2), 50, 'kx', 'DisplayName', 'Wykrycia');
title('Analiza trajektorii z Mahalanobisem');
xlabel('X [km]');
ylabel('Y [km]');
grid on;
hold off;

%% Wyświetlenie statystyk w terminalu
disp('--- Statystyki trajektorii ---');
disp(['Liczba prawdziwych trajektorii (wygenerowanych): ', num2str(params.numObjects)]);
disp(['Liczba trajektorii stworzonych przez przestrzeń Mahalanobisa: ', num2str(length(detectedTrajectories))]);