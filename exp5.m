clc; clear;

% Given Data
P = 70;          % Power in kW
V = 1100;        % Voltage (line)
f = 50;          % Frequency (Hz)
p = 10;          % Number of poles
Bav = 0.4;       % Average flux density (Wb/m^2)
ac = 25000;      % Specific electric loading (A/m)
Eff = 0.88;      % Efficiency
pf = 0.88;       % Power factor
kw = 0.96;       % Winding factor
Sl = 500;        % Slot loading limit (A-conductors/slot)
m = 3;           % Number of phases

% Step 1: Stator Power (in watts)
S = (P * 1000) / (Eff * pf);

% Step 2: Output Coefficient (Co)
Co = 11 * Bav * ac * kw * 1e-3;  % (kVA/m^3/rps)
disp(['Output Coefficient (Co) = ', num2str(Co)]);

% Step 3: Synchronous Speed
Ns = (120 * f) / p;  % rpm
n = Ns / 60;         % rps

% Step 4: Ratio of L/D
LD = (1.5 * pi) / p;

% Step 5: Find D^2 * L
D_L = S / (Co * n);

% Step 6: Calculate Diameter (D) and Length (L)
D = (D_L / LD)^(1/3);
L = LD * D;

% Step 7: Peripheral Velocity
v = pi * D * n;

% Display basic dimensions
fprintf('\n--- MACHINE MAIN DIMENSIONS ---\n');
fprintf('Stator Diameter (D) = %.4f m\n', D);
fprintf('Stator Core Length (L) = %.4f m\n', L);
fprintf('Peripheral Velocity (v) = %.2f m/s\n', v);

% Step 8: Flux per Pole
F_p = (pi * D * L * Bav) / p;
fprintf('Flux per pole (F_p) = %.5f Wb\n', F_p);

% Step 9: Turns per Phase (approx)
Eph = V / sqrt(3);
T_p = Eph / (4.44 * f * F_p * kw);
fprintf('Turns per phase (T_p) = %.2f turns\n', T_p);

% Step 10: Number of Slots and Slot Pitch
Ss = m * p * 3;              % Assume 3 slots per pole per phase
Yss = (pi * D) / Ss;         % Slot pitch (m)

% Step 11: Total Conductors and per Slot
Z = 6 * T_p;                 % Total conductors
Zs = Z / Ss;                 % Conductors per slot

% Step 12: Phase Current and Slot Loading
Iph = S / (3 * V);           % Phase current (A)
Slot_Loading = Iph * Zs;     % Ampere-conductors per slot

fprintf('\n--- SLOT DESIGN CHECK ---\n');
fprintf('Slot Pitch (Yss) = %.5f m\n', Yss);
fprintf('Conductors per Slot (Zs) = %.2f\n', Zs);
fprintf('Slot Loading = %.2f A-conductors\n', Slot_Loading);

% Step 13: Check Design
if Slot_Loading < Sl
    disp('✅ Design Accepted (Slot loading within limits)');
else
    disp('❌ Design Rejected (Slot loading too high)');
end
