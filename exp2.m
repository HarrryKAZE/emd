clc;
clear all;
close all;

% Given data
P_in = 75000;         % Input power in watts
eff = 0.91;           % Efficiency
P_out = eff * P_in;   % Output power in watts
N = 840;              % Speed in rpm
p = 4;                % Number of poles
si = 0.7;             % Space factor
n = N / 60;           % Speed in rps

% Given arrays
D_arr = [0.1 0.2 0.3 0.4 0.5 0.6];              % Diameter (m)
Bav_ac_arr = [5200 9300 12700 15500 18000 20000]; % Bav * ac (W/m^3)

% Pre-allocate array for lengths
L_arr = zeros(1, length(D_arr));

fprintf(' D (m)\tBav*ac (W/m^3)\tL (m)\n');
fprintf('---------------------------------\n');

% Calculate L for each D
for i = 1:length(D_arr)
    D = D_arr(i);
    Bav_ac = Bav_ac_arr(i);

    % Power equation: P = π² * D² * L * n * Bav * ac
    L = P_out / (pi^2 * D^2 * n * Bav_ac);

    % Store in array
    L_arr(i) = L;

    % Display results
    fprintf(' %.3f\t%6d\t\t%.3f\n', D, Bav_ac, L);
end

% Header for T values
fprintf('\nAll calculated T values:\n');
fprintf(' D (m)\tL (m)\tT = (L*p)/(0.7πD)\n');
fprintf('---------------------------------\n');

min_diff = inf;
closest_index = -1;

for i = 1:length(D_arr)
    D = D_arr(i);
    L = L_arr(i);

    % Calculate T
    T = (L * p) / (0.7 * pi * D);

    % Print the T value
    fprintf(' %.3f\t%.3f\t%.3f\n', D, L, T);

    % Check how close T is to 1
    diff = abs(T - 1);
    if diff < min_diff
        min_diff = diff;
        closest_index = i;
    end
end

% Closest T value details
D_closest = D_arr(closest_index);
L_closest = L_arr(closest_index);
T_closest = (L_closest * p) / (0.7 * pi * D_closest);

fprintf('\nClosest T ≈ 1 found:\n');
fprintf(' D = %.3f m, L = %.3f m, T = %.3f\n', D_closest, L_closest, T_closest);
