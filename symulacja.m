%% PARAMETRY
% Parametry radaru
Pn = 20; % dBm
L = 1; % Straty
SNR_min = 10; % dB
EIRP = 10e3; % Pt * Gt [W]
Gr = 1; % Zysk odbiornika
lambda = 3; % m
B = 200e3; % Hz
T = 1; % s

% Parametry symulacji Monte Carlo
numberOfPoints = 10000; % Liczba punktów losowanych Monte Carlo
TX_pos = [0, 0]; % Pozycja TX
RX_pos = [200, 0]; % Pozycja RX


%% MONTE CARLO - GENERACJA FAŁSZYWYCH PLOTÓW
% Generowanie losowych punktów w przestrzeni 2D (x, y)
x_values = rand(numberOfPoints, 1) * (RX_pos(1) - TX_pos(1)) + TX_pos(1);  % Losowe współrzędne x
y_values = rand(numberOfPoints, 1) * (200) - 100;  % Losowe współrzędne y w zakresie [-100, 100]
rcs_values = rand(numberOfPoints, 1) * 50; % RCS do 50 dB

% Tworzenie tablicy obiektów Punkt
RandomPoints = Punkt.empty(numberOfPoints, 0);
for i = 1:numberOfPoints
    RandomPoints(i) = Punkt([x_values(i), y_values(i)], rcs_values(i));
end

%% RYSUNEK - losowe ploty
figure;
hold on;
plot(TX_pos(1), TX_pos(2), 'ro', 'MarkerSize', 10, 'DisplayName', 'TX'); % Punkt TX
plot(RX_pos(1), RX_pos(2), 'bo', 'MarkerSize', 10, 'DisplayName', 'RX'); % Punkt RX

% Rysowanie losowych punktów trajektorii
for i = 1:numberOfPoints
    plot(RandomPoints(i).Position(1), RandomPoints(i).Position(2), 'k.', 'MarkerSize', 5);
end

% Konfiguracja wykresu
xlabel('Odległość (m)');
ylabel('Odległość (m)');
title('Losowe ploty z radaru - fałszywe wykrycia');
grid on;
axis equal;
hold off;

%% "Odsiewanie" plotów niewidocznych przez radar
FilteredPoints = Punkt.empty(0, filteredCount);
filteredCount = 0;

for i = 1:numberOfPoints
    % Obliczenie odległości od TX i RX
    R1 = RandomPoints(i).getDistance(TX_pos); % Odległość od TX
    R2 = RandomPoints(i).getDistance(RX_pos); % Odległość od RX

    % Przeliczenie Pn z dBm na waty
    Pn_watts = 10^((Pn - 30)/10);
    Pr_min = Pn_watts * 10^((SNR_min - L)/10); % Minimalna moc odbiornika [W]

    % Obliczenie minimalnego wykrywalnego RCS
    RCS_det = (Pr_min * (4 * pi)^3 * R1^2 * R2^2) / (EIRP * Gr * lambda^2); % Minimalny RCS (wartość liniowa)

    % Filtracja punktów
    if RandomPoints(i).getRCSLinear() >= RCS_det
        filteredCount = filteredCount + 1;
        FilteredPoints(filteredCount) = RandomPoints(i);
    end
end

% Informacja o liczbie punktów
disp(['Liczba punktów po filtracji: ', num2str(filteredCount)]);

%% RYSUNEK - po odsianiu
figure;
hold on;
plot(TX_pos(1), TX_pos(2), 'ro', 'MarkerSize', 10, 'DisplayName', 'TX'); % Punkt TX
plot(RX_pos(1), RX_pos(2), 'bo', 'MarkerSize', 10, 'DisplayName', 'RX'); % Punkt RX

% Rysowanie punktów trajektorii po odsianiu
for i = 1:filteredCount
    plot(FilteredPoints(i).Position(1), FilteredPoints(i).Position(2), 'g.', 'MarkerSize', 5);
end

% Konfiguracja wykresu
xlabel('Odległość (m)');
ylabel('Odległość (m)');
title('Ploty z radaru po odsianiu niewidocznych');
grid on;
axis equal;
hold off;