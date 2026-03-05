function [shutdown, V_limit, I_limit, T_limit] = protection_system(Vpv, Ipv, Temp, Vout)
% PROTECTION SYSTEM for Solar MPPT Boost Converter
% This function monitors parameters and triggers shutdown

% Protection limits
V_PV_MAX = 33.5;      % PV max voltage
V_PV_MIN = 10;        % PV min voltage
V_OUT_MAX = 60;       % Output max voltage
I_PV_MAX = 9.0;       % PV max current
TEMP_MAX = 85;        % Maximum temperature
TEMP_MIN = -20;       % Minimum temperature

% Initialize flags
shutdown = 0;
V_limit = 0;
I_limit = 0;
T_limit = 0;

% Check PV Over-Voltage
if Vpv > V_PV_MAX
    shutdown = 1;
    V_limit = 1;
    fprintf('PROTECTION: PV Over-Voltage! Vpv=%.2fV > %.2fV\n', Vpv, V_PV_MAX);
end

% Check PV Under-Voltage
if Vpv < V_PV_MIN && Vpv > 0.1
    shutdown = 1;
    V_limit = 1;
    fprintf('PROTECTION: PV Under-Voltage! Vpv=%.2fV < %.2fV\n', Vpv, V_PV_MIN);
end

% Check Output Over-Voltage
if Vout > V_OUT_MAX
    shutdown = 1;
    V_limit = 1;
    fprintf('PROTECTION: Output Over-Voltage! Vout=%.2fV > %.2fV\n', Vout, V_OUT_MAX);
end

% Check Over-Current
if Ipv > I_PV_MAX
    shutdown = 1;
    I_limit = 1;
    fprintf('PROTECTION: PV Over-Current! Ipv=%.2fA > %.2fA\n', Ipv, I_PV_MAX);
end

% Check Temperature
if Temp > TEMP_MAX || Temp < TEMP_MIN
    shutdown = 1;
    T_limit = 1;
    fprintf('PROTECTION: Temperature out of range! Temp=%.1f°C\n', Temp);
end

if shutdown == 1
    fprintf('🚨 EMERGENCY SHUTDOWN TRIGGERED!\n');
end

end