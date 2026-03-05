%% STEP 7: Generate Final Results for Project
clear; clc; close all;

% Create dummy data for example
t = linspace(0, 2, 1000);
Vpv = 23.5 + 0.5*sin(2*pi*0.5*t);
Ipv = 0.17 + 0.02*sin(2*pi*0.5*t + pi/4);
Ppv = Vpv .* Ipv;
duty = 0.5 + 0.05*sin(2*pi*0.3*t);
Vout = Vpv ./ (1 - duty);

%% Create figure with 6 subplots
figure('Position', [100, 100, 1200, 800]);

% Plot 1: PV Voltage
subplot(2,3,1);
plot(t, Vpv, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('PV Panel Voltage');
grid on;
xlim([0 2]);

% Plot 2: PV Current
subplot(2,3,2);
plot(t, Ipv, 'r-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Current (A)');
title('PV Panel Current');
grid on;
xlim([0 2]);

% Plot 3: PV Power
subplot(2,3,3);
plot(t, Ppv, 'g-', 'LineWidth', 1.5);
hold on;
[Pmax, idx] = max(Ppv);
plot(t(idx), Pmax, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
xlabel('Time (s)');
ylabel('Power (W)');
title('PV Power Output');
legend('Power', sprintf('Max: %.2fW', Pmax));
grid on;
xlim([0 2]);

% Plot 4: Duty Cycle
subplot(2,3,4);
plot(t, duty*100, 'm-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Duty Cycle (%)');
title('MPPT Duty Cycle');
grid on;
xlim([0 2]);
ylim([0 100]);

% Plot 5: Output Voltage
subplot(2,3,5);
plot(t, Vout, 'c-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Boost Converter Output');
grid on;
xlim([0 2]);

% Plot 6: PV Curve
subplot(2,3,6);
plot(Vpv, Ppv, 'b.', 'MarkerSize', 3);
hold on;
plot(Vpv(idx), Pmax, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
xlabel('Voltage (V)');
ylabel('Power (W)');
title('PV Curve with MPPT');
legend('Operating Points', 'MPP');
grid on;

%% Save figure to current folder
saveas(gcf, 'final_results.png');
fprintf('✓ Figure saved as: final_results.png\n');

%% Display statistics
fprintf('\n========================================\n');
fprintf('    FINAL RESULTS - MPPT PERFORMANCE\n');
fprintf('========================================\n');
fprintf('Average PV Voltage: %.2f V\n', mean(Vpv));
fprintf('Average PV Current: %.2f A\n', mean(Ipv));
fprintf('Average PV Power: %.2f W\n', mean(Ppv));
fprintf('Maximum PV Power: %.2f W\n', max(Ppv));
fprintf('Average Duty Cycle: %.2f %%\n', mean(duty)*100);
fprintf('Average Output Voltage: %.2f V\n', mean(Vout));
fprintf('MPPT Tracking Efficiency: %.2f %%\n', (mean(Ppv)/max(Ppv))*100);
fprintf('========================================\n');