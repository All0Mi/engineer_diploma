%% generowanie trajektorii obiektów
function trajectoriesWithRCS = generateTrajectory(params, space)
    % Tworzenie trajektorii
    trajectories = zeros(params.numObjects, params.timeSteps, 2);

    % Inicjalizacja macierzy na RCS
    RCS = zeros(params.numObjects, params.timeSteps);

    for obj = 1:params.numObjects
        position = params.initPositions(obj, :);
        velocity = params.initVelocities(obj, :);

        for t = 1:params.timeSteps
            % Aktualizacja pozycji
            position = position + velocity * 0.1; % czas: 0.1h
            position = mod(position, [space.width, space.height]);
            trajectories(obj, t, :) = position;

            % Losowanie RCS
            objectPower = chi2rnd(1);              % Moc obiektu (Chi²)
            noisePower = raylrnd(params.rayleighSigma); % Moc szumu (Rayleigh)
            RCS(obj, t) = objectPower + noisePower; % Suma mocy
        end
    end

    % Dodanie RCS jako trzeciego wymiaru
    trajectoriesWithRCS = cat(3, trajectories, RCS);
end
