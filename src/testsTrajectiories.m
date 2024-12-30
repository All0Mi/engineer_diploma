clear all;
[space,params] = initializeSimulation();
trajectories = generateTrajectory(params, space);
falsePoints = generateFalsePoints(params, space);

%% wstępna wizualizacja
hold on;
for obj = 1:params.numObjects
    plot(squeeze(trajectories(obj, :, 1)), squeeze(trajectories(obj, :, 2)), '-o');
end
scatter(falsePoints(:,1,1), falsePoints(:,1,2), 'r*');
title('Trajektorie i punkty fałszywe');
xlabel('X [km]');
ylabel('Y [km]');
hold off;

%% Test bistatycznego radaru - wizualizacja tylko wykryć
radar = initializeRadar();
detectedPoints = radarDetection(trajectories, falsePoints, radar, params);

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
    plot(1:params.timeSteps, squeeze(trajectories(obj, :, 3)), '-o');
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

%% Filtracja i analiza trajektorii za pomocą przestrzeni Mahalonobisa

% Połączenie wszystkich wykryć w jedną macierz
allDetections = [noisyTrajectories; noisyFalsePoints];

% Ustawienie parametru odległości Mahalanobisa
mahalDistThreshold = 5; % Przykładowa wartość progowa

% Testowanie funkcji grupowania punktów w trajektorie
groupedTrajectories = mahalonobisTrajectories(allDetections, mahalDistThreshold);

% Wizualizacja wyników grupowania
figure;
hold on;
scatter(radar.transmitter(1), radar.transmitter(2), 100, 'bs', 'filled', 'DisplayName', 'Nadajnik');
scatter(radar.receiver(1), radar.receiver(2), 100, 'ms', 'filled', 'DisplayName', 'Odbiornik');

colors = lines(length(groupedTrajectories)); % Generowanie różnych kolorów
for i = 1:length(groupedTrajectories)
    traj = groupedTrajectories{i};
    plot(traj(:, 1), traj(:, 2), '-o', 'Color', colors(i, :), 'DisplayName', sprintf('Trajektoria %d', i));
end

title('Grupowanie punktów w trajektorie');
xlabel('X [km]');
ylabel('Y [km]');
legend;
hold off;