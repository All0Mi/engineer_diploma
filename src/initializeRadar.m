%% inicjalizacja radaru bistatycznego
function radar = initializeRadar()
    radar.transmitter = [50, 50]; %pozycja TX (X,Y) [km]
    radar.receiver = [150, 150];    % pozycja RX (X,Y) [km]
    radar.range = 200;              %maksymalny zasięg radaru [km]
end