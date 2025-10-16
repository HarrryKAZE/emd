clc; clear;

% Input Section
P = input('Enter the power rating of the machine (in watts), P: ');
V = input('Enter the terminal voltage of the machine, V: ');
p = input('Enter the number of poles of the machine, p: ');
N = input('Enter the speed of the machine (in rpm), N: ');
Bav = input('Enter the specific magnetic loading, Bav (in Wb/m^2): ');
ac = input('Enter the specific electric loading, ac (in A/m): ');
eff = input('Enter the efficiency of the machine (in decimal, e.g. 0.9): ');
si = input('Enter the ratio of pole arc to pole pitch, si: ');
n = N / 60;   % Convert rpm to rps

Mac_type = input('If Generator enter 1, otherwise enter 0 for Motor: ');

% Step 1: Power handling
if (Mac_type == 1)
    Pa = P / eff;
    disp(['Armature Power Output (Generator) = ', num2str(Pa), ' W']);
else
    Pa = P;
    disp(['Power Input (Motor) = ', num2str(Pa), ' W']);
end

% Step 2: Coefficient of Output (Co)
Co = (pi^2) * Bav * ac * (1/1000);
disp(['Output Coefficient (Co) = ', num2str(Co)]);

% Step 3: Calculate D^2 * L
x = Co * n;
D_L = Pa / x;
disp(['D^2 * L = ', num2str(D_L)]);

% Step 4: Ratio of L/D
LD_ratio = si * (pi / p);
disp(['L/D ratio = ', num2str(LD_ratio)]);

% Step 5: Calculate Diameter (D) and Length (L)
D = (D_L / LD_ratio)^(1/3);
L = LD_ratio * D;

% Step 6: Display Results
fprintf('\n--- MACHINE MAIN DIMENSIONS ---\n');
fprintf('Armature Diameter, D = %.4f m\n', D);
fprintf('Core Length, L = %.4f m\n', L);
fprintf('L/D Ratio = %.4f\n', LD_ratio);
fprintf('Output Coefficient, Co = %.4f\n', Co);
