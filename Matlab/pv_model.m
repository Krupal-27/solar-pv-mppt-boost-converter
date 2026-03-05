%% STEP 1: Solar PV Panel Mathematical Model
% Improved version with accurate MPP calculation
% Clear workspace
clc
clear all
close all

%% ==================== PV PANEL PARAMETERS ====================
% Based on real 250W solar panel specifications
Isc = 8.21;      % Short circuit current (A) at 1000W/m², 25°C
Voc = 32.9;      % Open circuit voltage (V) at 1000W/m², 25°C
Ns = 60;         % Number of cells in series
q = 1.602e-19;   % Electron charge (C)
k = 1.38e-23;    % Boltzmann constant (J/K)
A = 1.3;         % Ideality factor (typically 1-2)

%% ==================== ENVIRONMENTAL CONDITIONS ====================
T = 298;         % Cell temperature in Kelvin (25°C + 273)
Tref = 298;      % Reference temperature (Kelvin)
S = 1000;        % Solar irradiance (W/m²)
Sref = 1000;     % Reference irradiance (W/m²)

%% ==================== THERMAL VOLTAGE CALCULATION ====================
Vt = (A * k * T) / q;                    % Thermal voltage per cell (V)
Vt_total = Ns * Vt;                       % Total thermal voltage for panel (V)

fprintf('=== Thermal Voltage ===\n');
fprintf('Vt per cell: %.4f V\n', Vt);
fprintf('Total Vt: %.4f V\n\n', Vt_total);

%% ==================== MODEL PARAMETERS ====================
Rs = 0.221;      % Series resistance (Ω) - accounts for internal losses
Rsh = 415;       % Shunt resistance (Ω) - accounts for leakage current

% Reverse saturation current at reference conditions (A)
Irs = Isc / (exp(Voc/(Ns * A * Vt)) - 1);

% Saturation current (A) - temperature dependent
Eg = 1.12;       % Band gap energy of silicon (eV)
Is = Irs * (T/Tref)^3 * exp((q * Eg)/(A*k) * (1/Tref - 1/T));

% Photo-generated current (A) - depends on irradiance and temperature
Iph = (Isc + 0.0001*(T - Tref)) * (S/Sref);

fprintf('=== Model Parameters ===\n');
fprintf('Irs: %.2e A\n', Irs);
fprintf('Is: %.2e A\n', Is);
fprintf('Iph: %.4f A\n\n', Iph);

%% ==================== GENERATE I-V AND P-V CURVES ====================
% Create voltage vector from 0 to Voc (don't exceed Voc for physical accuracy)
V = linspace(0, Voc, 1000);  % 1000 points for smooth curves

% Initialize arrays
I = zeros(1, length(V));
P = zeros(1, length(V));

%% ==================== SOLVE PV EQUATION USING NEWTON-RAPHSON ====================
fprintf('Calculating I-V curve...\n');
for j = 1:length(V)
    % Initial guess: start with photo-generated current
    I_old = Iph;
    
    % Newton-Raphson iteration
    for iter = 1:100
        % Calculate diode voltage
        Vd = V(j) + I_old * Rs;
        
        % Calculate current using PV cell equation
        % I = Iph - Is*(exp(Vd/(Ns*A*Vt)) - 1) - Vd/Rsh
        I_new = Iph - Is * (exp(Vd/(Ns * A * Vt)) - 1) - Vd/Rsh;
        
        % Check convergence
        if abs(I_new - I_old) < 1e-8
            break;
        end
        
        % Update for next iteration
        I_old = I_new;
    end
    
    % Store results (ensure current is not negative)
    I(j) = max(0, I_new);
    P(j) = V(j) * I(j);
end
fprintf('Calculation complete!\n\n');

%% ==================== FIND MAXIMUM POWER POINT (MPP) ====================
[Pmax, idx] = max(P);
Vmpp = V(idx);
Impp = I(idx);

%% ==================== ADDITIONAL PARAMETERS ====================
% Fill Factor (FF) - measure of squareness of I-V curve
FF = (Pmax / (Voc * Isc)) * 100;

% Efficiency (assuming 1m² panel area for standard testing)
area = 1.63;     % Typical area for 250W panel (m²)
efficiency = (Pmax / (1000 * area)) * 100;

%% ==================== DISPLAY RESULTS ====================
fprintf('========================================\n');
fprintf('    PV PANEL CHARACTERISTICS\n');
fprintf('========================================\n');
fprintf('Open Circuit Voltage (Voc):      %.2f V\n', Voc);
fprintf('Short Circuit Current (Isc):     %.2f A\n', Isc);
fprintf('----------------------------------------\n');
fprintf('MAXIMUM POWER POINT (MPP):\n');
fprintf('  Voltage at MPP (Vmpp):         %.2f V\n', Vmpp);
fprintf('  Current at MPP (Impp):         %.2f A\n', Impp);
fprintf('  Power at MPP (Pmax):           %.2f W\n', Pmax);
fprintf('----------------------------------------\n');
fprintf('Fill Factor:                      %.2f %%\n', FF);
fprintf('Panel Efficiency:                 %.2f %%\n', efficiency);
fprintf('========================================\n');

%% ==================== VERIFICATION CHECKS ====================
fprintf('\n=== VERIFICATION CHECKS ===\n');
if Vmpp < Voc
    fprintf('✓ PASS: Vmpp (%.2f V) < Voc (%.2f V)\n', Vmpp, Voc);
else
    fprintf('✗ FAIL: Vmpp (%.2f V) > Voc (%.2f V) - Check calculations\n', Vmpp, Voc);
end

if Impp < Isc
    fprintf('✓ PASS: Impp (%.2f A) < Isc (%.2f A)\n', Impp, Isc);
else
    fprintf('✗ FAIL: Impp (%.2f A) > Isc (%.2f A) - Check calculations\n', Impp, Isc);
end

if FF < 100 && FF > 50
    fprintf('✓ PASS: Fill Factor (%.2f%%) is in normal range (50-100%%)\n', FF);
else
    fprintf('⚠ WARNING: Fill Factor (%.2f%%) outside normal range\n', FF);
end

%% ==================== PLOT I-V CURVE ====================
figure('Position', [100, 100, 1400, 600]);

% I-V Curve Subplot
subplot(2,3,1);
plot(V, I, 'b-', 'LineWidth', 2);
hold on;
plot(Vmpp, Impp, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot(Voc, 0, 'gs', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
plot(0, Isc, 'ms', 'MarkerSize', 10, 'MarkerFaceColor', 'm');
grid on;
xlabel('Voltage (V)', 'FontSize', 11);
ylabel('Current (A)', 'FontSize', 11);
title('PV Panel I-V Characteristic', 'FontSize', 12, 'FontWeight', 'bold');
legend('I-V Curve', 'MPP', 'Voc', 'Isc', 'Location', 'best');
xlim([0 Voc*1.05]);
ylim([0 Isc*1.1]);

%% ==================== PLOT P-V CURVE ====================
subplot(2,3,2);
plot(V, P, 'r-', 'LineWidth', 2);
hold on;
plot(Vmpp, Pmax, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
grid on;
xlabel('Voltage (V)', 'FontSize', 11);
ylabel('Power (W)', 'FontSize', 11);
title('PV Panel P-V Characteristic', 'FontSize', 12, 'FontWeight', 'bold');
legend('P-V Curve', 'MPP', 'Location', 'best');
xlim([0 Voc*1.05]);
ylim([0 Pmax*1.1]);

%% ==================== POWER VS VOLTAGE WITH MPP HIGHLIGHTED ====================
subplot(2,3,3);
plot(V, P, 'b-', 'LineWidth', 1.5);
hold on;
% Highlight the MPP region
fill([Vmpp-2 Vmpp-2 Vmpp+2 Vmpp+2], [0 Pmax Pmax 0], ...
    'y', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(Vmpp, Pmax, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
grid on;
xlabel('Voltage (V)', 'FontSize', 11);
ylabel('Power (W)', 'FontSize', 11);
title('MPP Tracking Region', 'FontSize', 12, 'FontWeight', 'bold');
legend('P-V Curve', 'MPP Region', 'MPP', 'Location', 'best');

%% ==================== EFFECT OF IRRADIANCE ====================
subplot(2,3,4);
hold on;
irradiance_levels = [1000, 800, 600, 400, 200];
colors = ['r', 'g', 'b', 'm', 'c'];
P_max_values = zeros(1, length(irradiance_levels));

for i = 1:length(irradiance_levels)
    S_test = irradiance_levels(i);
    
    % Recalculate for new irradiance
    Iph_test = (Isc + 0.0001*(T - Tref)) * (S_test/Sref);
    
    % Generate I-V curve
    I_test = zeros(1, length(V));
    for j = 1:length(V)
        I_old = Iph_test;
        for iter = 1:100
            Vd = V(j) + I_old * Rs;
            I_new = Iph_test - Is * (exp(Vd/(Ns * A * Vt)) - 1) - Vd/Rsh;
            if abs(I_new - I_old) < 1e-8
                break;
            end
            I_old = I_new;
        end
        I_test(j) = max(0, I_new);
    end
    
    % Find max power for this irradiance
    P_test = V .* I_test;
    P_max_values(i) = max(P_test);
    
    plot(V, I_test, colors(i), 'LineWidth', 1.5);
end
grid on;
xlabel('Voltage (V)', 'FontSize', 11);
ylabel('Current (A)', 'FontSize', 11);
title('I-V at Different Irradiance Levels', 'FontSize', 12, 'FontWeight', 'bold');
legend('1000 W/m²', '800 W/m²', '600 W/m²', '400 W/m²', '200 W/m²', 'Location', 'best');

%% ==================== EFFECT OF TEMPERATURE ====================
subplot(2,3,5);
hold on;
temp_levels = [298, 308, 318, 328];  % 25°C, 35°C, 45°C, 55°C
colors_temp = ['r', 'g', 'b', 'm'];

for i = 1:length(temp_levels)
    T_test = temp_levels(i);
    
    % Recalculate temperature-dependent parameters
    Vt_test = (A * k * T_test) / q;
    Is_test = Irs * (T_test/Tref)^3 * exp((q * Eg)/(A*k) * (1/Tref - 1/T_test));
    Iph_test = (Isc + 0.0001*(T_test - Tref)) * (S/Sref);
    
    % Generate I-V curve
    I_test = zeros(1, length(V));
    for j = 1:length(V)
        I_old = Iph_test;
        for iter = 1:100
            Vd = V(j) + I_old * Rs;
            I_new = Iph_test - Is_test * (exp(Vd/(Ns * A * Vt_test)) - 1) - Vd/Rsh;
            if abs(I_new - I_old) < 1e-8
                break;
            end
            I_old = I_new;
        end
        I_test(j) = max(0, I_new);
    end
    
    plot(V, I_test, colors_temp(i), 'LineWidth', 1.5);
end
grid on;
xlabel('Voltage (V)', 'FontSize', 11);
ylabel('Current (A)', 'FontSize', 11);
title('I-V at Different Temperatures', 'FontSize', 12, 'FontWeight', 'bold');
legend('25°C', '35°C', '45°C', '55°C', 'Location', 'best');

%% ==================== POWER SUMMARY BAR CHART ====================
subplot(2,3,6);
bar(irradiance_levels, P_max_values, 'FaceColor', [0.3 0.6 0.9]);
xlabel('Irradiance (W/m²)', 'FontSize', 11);
ylabel('Maximum Power (W)', 'FontSize', 11);
title('Max Power vs Irradiance', 'FontSize', 12, 'FontWeight', 'bold');
grid on;
for i = 1:length(irradiance_levels)
    text(irradiance_levels(i), P_max_values(i)+5, ...
        sprintf('%.0fW', P_max_values(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 9);
end

%% ==================== ADD PARAMETERS ANNOTATION ====================
annotation('textbox', [0.15, 0.01, 0.7, 0.03], ...
    'String', sprintf('Parameters: G=%dW/m², T=%d°C, Voc=%.1fV, Isc=%.2fA, Pmpp=%.1fW, Vmpp=%.1fV, Impp=%.2fA, FF=%.1f%%', ...
    S, T-273, Voc, Isc, Pmax, Vmpp, Impp, FF), ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 9, ...
    'EdgeColor', 'none', ...
    'BackgroundColor', [0.9 0.9 0.9]);

%% ==================== SAVE RESULTS ====================
% Save figure
saveas(gcf, 'pv_characteristics_improved.png');
fprintf('\n✅ Figure saved as: pv_characteristics_improved.png\n');

% Save parameters for Simulink
save('pv_params.mat', 'Isc', 'Voc', 'Ns', 'Vmpp', 'Impp', 'Pmax', 'FF');
fprintf('✅ Parameters saved to: pv_params.mat\n');

%% ==================== EXPORT DATA TO CSV ====================
% Create table with I-V and P-V data
T_data = table(V', I', P', 'VariableNames', {'Voltage_V', 'Current_A', 'Power_W'});
writetable(T_data, 'pv_curve_data.csv');
fprintf('✅ Curve data saved to: pv_curve_data.csv\n');

%% ==================== FINAL SUMMARY ====================
fprintf('\n========================================\n');
fprintf('    STEP 1 COMPLETED SUCCESSFULLY\n');
fprintf('========================================\n');
fprintf('✓ PV panel mathematical model created\n');
fprintf('✓ I-V and P-V curves generated\n');
fprintf('✓ Maximum Power Point (MPP) identified\n');
fprintf('✓ Irradiance effects analyzed\n');
fprintf('✓ Temperature effects analyzed\n');
fprintf('✓ Parameters saved for Simulink\n');
fprintf('✓ Data exported to CSV\n');
fprintf('========================================\n\n');

disp('Ready for Step 2: Building the Boost Converter in Simulink!');