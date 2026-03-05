function duty = mppt_po(V, I)
% MPPT Perturb & Observe Algorithm
% Inputs: V = PV voltage, I = PV current
% Output: duty = duty cycle for boost converter

% Persistent variables to remember previous values
persistent Vprev Pprev duty_prev

% Initialize on first call
if isempty(Vprev)
    Vprev = 0;        % Previous voltage
    Pprev = 0;        % Previous power
    duty_prev = 0.5;  % Initial duty cycle (50%)
end

% Calculate current power
P = V * I;

% Perturb & Observe logic
if P > Pprev
    % Power increased → continue same direction
    if V > Vprev
        duty = duty_prev + 0.01;  % Increase duty
    else
        duty = duty_prev - 0.01;  % Decrease duty
    end
else
    % Power decreased → reverse direction
    if V > Vprev
        duty = duty_prev - 0.01;  % Decrease duty
    else
        duty = duty_prev + 0.01;  % Increase duty
    end
end

% Limit duty cycle to safe range (10% to 90%)
duty = max(0.1, min(0.9, duty));

% Update persistent variables for next call
Vprev = V;
Pprev = P;
duty_prev = duty;

end