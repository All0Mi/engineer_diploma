%% generowanie trajektorii obiektów
function trajectories = generateTrajectory(params, space)
    trajectories = zeros(params.numObjects, params.timeSteps, 2);

    for obj = 1:params.numObjects
        position = params.initPositions(obj, :);
        velocity = params.initVelocities(obj, :);

        %trajektoria w czasie:
        for t = 1:params.timeSteps
            position = position + velocity * 0.1; %czas: 0.1h
            position = mod(position, [space.width, space.height]); %prawdzenie, czy obiekt nadal mieści się w naszej przestrzeni
            trajectories(obj, t, :) = position;

        end
    end
end