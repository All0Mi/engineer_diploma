%% funckja odpowiadają za inicjalizacje symulacji - jej parametry, dane etc.
function [space, params] = initializeSimulation()
    %przestrzeń symulacyjna
    space.width = 200;      % km
    space.height = 200;     % km

    %stałe symulacyjne, parametry
    params.numObjects = 10;
    params.numFalsePoints = 50;
    params.timeSteps = 100;
    params.speedRange = [0, 50];    % km/h
    params.P_FA = 1e-3; % prawdopodobieństwo fałszywego alarmu

    %losowanie pozycji i prędkości
    params.initPositions = rand(params.numObjects, 2) .* [space.width, space.height];
    params.initVelocities = rand(params.numObjects, 2) .* params.speedRange(2);
    params.rayleighSigma = 1; % domyślna wartość dla Rayleigha

end