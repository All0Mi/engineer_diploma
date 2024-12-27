%% wprowadzenie szumów do wykryć radarowych
    % dectections = macierz wykrytych punktów [X,Y,czas]
    % noiseStd = odchylenie standardowe szumów [sigmaX, sigmaY]

function noisyDetections = addNoiseToDetections(detections, noiseStd)
    noisyDetections = detections;
    if ~isempty(detections)
        noisyDetections(:,1) = detections(:,1) + noiseStd(1) *randn(size(detections, 1), 1);
        noisyDetections(:,2) = detections(:,2) + noiseStd(2) *randn(size(detections, 1), 1);
    end
end