clc;
clear all;
close all;

% Given specifications
P = (25 * 746) / 1000;     % Power in kW
v = 500;                   % Voltage
p = 4;                     % Poles
N = 600;                   % Speed in rpm
n = N / 60;                % Speed in rps
eff = 0.82;                % Efficiency
si = 0.67;                 % Space factor
Bav = 0.55;                % Average flux density
ac = 17000;                % Specific electric loading

% Coefficient calculation
Co = (pi^2) * Bav * (ac / 1000);
x = Co * n;

% Machine type
Mac_type = input('If generator enter 1 otherwise 0, Mac_type: ');
if (Mac_type == 1)
    Pa = (P / eff);
else
    Pa = P;
end

% Calculate D and L
D_L = Pa / x;
disp(['D^2 * L = ', num2str(D_L)]);

LD_ratio = si * (pi / p);
D = ((D_L) / LD_ratio)^(1/3);
L = LD_ratio * D;

fprintf('Calculated Diameter (D) = %.3f m\n', D);
fprintf('Calculated Length (L) = %.3f m\n', L);

% Type of winding
Ia = (Pa * 1000) / (v * eff);  % Armature current in A
fprintf('Armature Current = %.2f A\n', Ia);

Ia1 = round(Ia);
if (Ia1 < 400)
    disp('Wave winding selected');
    winding = 1;
else
    disp('Lap winding selected');
    winding = 0;
end

% Armature conductors
p_pi = Bav * pi * D * L;
E = v;
if (winding == 1)
    A = 2;
else
    A = p;
end
fprintf('A = %d\n', A);

Z = ((E * 60 * A) / (p_pi * N));
Z = round(Z);
fprintf('Number of Armature Conductors (Z) = %d\n', Z);

% Armature slots
Sa1 = round(pi * D * 100 / 3.5);
Sa2 = round(pi * D * 100 / 2.5);
Sa3 = 9 * p;
Sa4 = 16 * p;
r1 = max(Sa1, Sa3);
r2 = min(Sa2, Sa4);
fprintf('Number of slots range: %d to %d\n', r1, r2);

pole_pair = p / 2;
fprintf('Pole pairs = %d\n', pole_pair);

% Slot selection
slots = 0;
for i = r1:r2
    if mod(i, 2) == 1
        w_w = (0.67 * i / p);
        w_w = round(w_w, 1);
        if mod(w_w, 1) == 0.5
            slots = i;
            fprintf('Valid slot: %d (w_w = %.2f)\n', slots, w_w);
            break;
        end
    end
end

if slots == 0
    error('No valid slots found in the given range.');
else
    fprintf('Final selected slots: %d\n', slots);
end

% Winding suitability
zss = round(Z / slots);
if mod(zss, 2) == 1
    zss = zss - 1;
end
fprintf('Conductors per slot = %d\n', zss);

% Slot loading
slot_loading = round(Ia * zss / A);
if (slot_loading < 1500)
    fprintf('Slot loading = %d A (less than 1500 A)\n', slot_loading);
else
    fprintf('Slot loading = %d A (exceeds 1500 A!)\n', slot_loading);
end

% Minimum number of armature coils
c_min = round(v * p / 15);
fprintf('Minimum number of armature coils (c_min) = %d\n', c_min);

% Determine number of armature coils
for i = 2:2:10
    c = (slots * i / 2);
    if (c > c_min)
        coil_sides = i;
        fprintf('Coil sides = %d\n', coil_sides);
        break;
    end
end

% Turns per coil
ztotal = zss * slots;
Tc = (ztotal / (2 * c));

fprintf('Total number of conductors = %d\n', ztotal);
fprintf('Turns per coil (Tc) = %.2f\n', Tc);
