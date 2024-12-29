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

%% MAHALONOBIS
%%TODO
% Parametry funkcji dopasowania trajektorii
params.matchThreshold = 55; % Przykładowy próg dopasowania, do dostosowania w zależności od aplikacji
params.noiseStd = [0.5, 0.5]; % Standardowe odchylenie szumu (500m w każdej osi)

% Wywołanie funkcji dopasowania trajektorii
matchedTrajectories = mahalonobisTrajectories(detectedPoints, params);

% Wizualizacja dopasowanych trajektorii
figure;
hold on;
scatter(radar.transmitter(1), radar.transmitter(2), 100, 'bs', 'filled', 'DisplayName', 'Nadajnik');
scatter(radar.receiver(1), radar.receiver(2), 100, 'ms', 'filled', 'DisplayName', 'Odbiornik');

% Wykres trajektorii z szumem
if ~isempty(noisyTrajectories)
    scatter(noisyTrajectories(:, 1), noisyTrajectories(:, 2), 'g+', 'DisplayName', 'Trajektorie zaszumione');
end
if ~isempty(noisyFalsePoints)
    scatter(noisyFalsePoints(:, 1), noisyFalsePoints(:, 2), 'k+', 'DisplayName', 'Fałszywe punkty zaszumione');
end

% Wykres trajektorii wykrytych przez radar (przed dodaniem szumu)
if ~isempty(detectedPoints.trajectories)
    scatter(detectedPoints.trajectories(:, 1), detectedPoints.trajectories(:, 2), 'ro', 'DisplayName', 'Trajektorie wykryte');
end

% Dodanie dopasowanych trajektorii do wykresu
if ~isempty(matchedTrajectories)
    scatter(matchedTrajectories(:, 1), matchedTrajectories(:, 2), 'y*', 'DisplayName', 'Dopasowane trajektorie');
end

title('Wykrycia radarowe z dopasowanymi trajektoriami');
xlabel('X [km]');
ylabel('Y [km]');
legend;
hold off;
