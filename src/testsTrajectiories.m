clear all;
[space,params] = initializeSimulation();
trajectories = generateTrajectory(params, space);
falsePoints = generateFalsePoints(params, space);

% wstępna wizualizacja
hold on;
for obj = 1:params.numObjects
    plot(squeeze(trajectories(obj, :, 1)), squeeze(trajectories(obj, :, 2)), '-o');
end
scatter(falsePoints(:,1,1), falsePoints(:,1,2), 'r*');
title('Trajektorie i punkty fałszywe');
xlabel('X [km]');
ylabel('Y [km]');
hold off;

% Test bistatycznego radaru - wizualizacja tylko wykryć
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
