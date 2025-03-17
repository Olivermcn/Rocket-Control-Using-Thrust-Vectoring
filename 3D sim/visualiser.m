%%
% --- 1) Extract numeric arrays ---
t_data     = out.t.Time;        
x_data     = out.x.Data;        
z_data     = out.z.Data;        
theta_data = out.theta.Data;
theta_ref_data = out.theta_ref.Data; % Assuming theta_ref is stored in out

% Define rocket length
L = 2;

% Create a figure
figure('Name', 'Rocket Animation', 'Color', 'w');
hold on; grid on; axis equal;

% Fix axis limits (adjust as needed)
axis([0 50 0 50]);
axis manual;

% Skip factor
skipFactor = 1;

% Pre-plot some empty handles so we can update them
rocketLine = plot(NaN, NaN, 'b-', 'LineWidth', 2, 'DisplayName', 'Rocket Body');
rocketDot  = plot(NaN, NaN, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Centre of Mass');
pathLine   = plot(NaN, NaN, 'k--', 'DisplayName', 'Actual Trajectory');

% Add placeholders for legend (these will be the ONLY reference lines in the legend)
legend_theta_ref = plot(NaN, NaN, 'g-', 'LineWidth', 2, 'DisplayName', 'Reference Orientation');
legend_theta_actual = plot(NaN, NaN, 'm-', 'LineWidth', 2, 'DisplayName', 'Actual Orientation at Reference Times');

xlabel('X Position');
ylabel('Z Position');
title('Rocket Animation with Reference');

% Ensure legend only contains the correct entries
legend({'Rocket Body', 'Centre of Mass', 'Actual Trajectory', ...
    'Reference Orientation', 'Actual Orientation at Reference Times'}, ...
    'Location', 'best');

% --- Main Loop ---
for i = 1:skipFactor:length(t_data)
    % Current state
    x_i = x_data(i);
    z_i = z_data(i);
    th  = theta_data(i);
    
    % Find the reference theta corresponding to the current time
    th_ref = theta_ref_data(i);
    
    % Nose and tail positions (actual orientation)
    x_nose = x_i + (L / 2) * sin(th);
    z_nose = z_i + (L / 2) * cos(th);
    x_tail = x_i - (L / 2) * sin(th);
    z_tail = z_i - (L / 2) * cos(th);
    
    % Compute reference and actual rocket orientation every 4 seconds and persist them
    if mod(t_data(i), 2) == 0
        % Compute reference body orientation
        x_nose_ref = x_i + (L / 2) * sin(th_ref);
        z_nose_ref = z_i + (L / 2) * cos(th_ref);
        x_tail_ref = x_i - (L / 2) * sin(th_ref);
        z_tail_ref = z_i - (L / 2) * cos(th_ref);
        
        % Plot reference rocket orientation (green) **without adding to legend**
        plot([x_tail_ref, x_nose_ref], [z_tail_ref, z_nose_ref], 'g-', 'LineWidth', 2, 'HandleVisibility', 'off');

        % Plot actual rocket orientation at reference times (magenta) **without adding to legend**
        plot([x_tail, x_nose], [z_tail, z_nose], 'm-', 'LineWidth', 2, 'HandleVisibility', 'off');
    end

    % Update the plots
    set(rocketLine, 'XData', [x_tail, x_nose], 'YData', [z_tail, z_nose]);
    set(rocketDot,  'XData', x_i, 'YData', z_i);
    set(pathLine,   'XData', x_data(1:i), 'YData', z_data(1:i));

    % Update the title with the current time
    title(sprintf('Time = %.2f s', t_data(i)));
    drawnow limitrate
end
%%
%this section is for plotting in the y-z plane
%%
% --- 1) Extract numeric arrays ---
t_data     = out.t.Time;        
y_data     = out.y.Data;  % Use Y instead of X
z_data     = out.z.Data;        
phi_data   = out.phi.Data; % Use Phi instead of Theta
phi_ref_data = out.phi_ref.Data; % Assuming reference Phi data exists

% Define rocket length
L = 20;

% Create a figure
figure('Name', 'Rocket Animation (Y vs Z)', 'Color', 'w');
hold on; grid on; axis equal;

% Fix axis limits (adjust as needed)
axis([-200 200 -200 200]);
axis manual;

% Skip factor
skipFactor = 1;

% Pre-plot some empty handles so we can update them
rocketLine = plot(NaN, NaN, 'b-', 'LineWidth', 2, 'DisplayName', 'Rocket Body');
rocketDot  = plot(NaN, NaN, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Centre of Mass');
pathLine   = plot(NaN, NaN, 'k--', 'DisplayName', 'Actual Trajectory');

% Add placeholders for legend (these will be the ONLY reference lines in the legend)
legend_phi_ref = plot(NaN, NaN, 'g-', 'LineWidth', 2, 'DisplayName', 'Reference Orientation (Phi)');
legend_phi_actual = plot(NaN, NaN, 'm-', 'LineWidth', 2, 'DisplayName', 'Actual Orientation at Reference Times (Phi)');

xlabel('Y Position');
ylabel('Z Position');
title('Rocket Animation with Reference (Y vs Z)');

% Ensure legend only contains the correct entries
legend({'Rocket Body', 'Centre of Mass', 'Actual Trajectory', ...
    'Reference Orientation (Phi)', 'Actual Orientation at Reference Times (Phi)'}, ...
    'Location', 'best');

% --- Main Loop ---
for i = 1:skipFactor:length(t_data)
    % Current state
    y_i = y_data(i);
    z_i = z_data(i);
    phi  = phi_data(i);
    
    % Find the reference phi corresponding to the current time
    phi_ref = phi_ref_data(i);
    
    % Nose and tail positions (actual orientation using Phi)
    y_nose = y_i + (L / 2) * sin(phi);
    z_nose = z_i + (L / 2) * cos(phi);
    y_tail = y_i - (L / 2) * sin(phi);
    z_tail = z_i - (L / 2) * cos(phi);
    
    % Compute reference and actual rocket orientation every 4 seconds and persist them
    if mod(t_data(i), 4) == 0
        % Compute reference body orientation
        y_nose_ref = y_i + (L / 2) * sin(phi_ref);
        z_nose_ref = z_i + (L / 2) * cos(phi_ref);
        y_tail_ref = y_i - (L / 2) * sin(phi_ref);
        z_tail_ref = z_i - (L / 2) * cos(phi_ref);
        
        % Plot reference rocket orientation (green) **without adding to legend**
        plot([y_tail_ref, y_nose_ref], [z_tail_ref, z_nose_ref], 'g-', 'LineWidth', 2, 'HandleVisibility', 'off');

        % Plot actual rocket orientation at reference times (magenta) **without adding to legend**
        plot([y_tail, y_nose], [z_tail, z_nose], 'm-', 'LineWidth', 2, 'HandleVisibility', 'off');
    end

    % Update the plots
    set(rocketLine, 'XData', [y_tail, y_nose], 'YData', [z_tail, z_nose]);
    set(rocketDot,  'XData', y_i, 'YData', z_i);
    set(pathLine,   'XData', y_data(1:i), 'YData', z_data(1:i));

    % Update the title with the current time
    title(sprintf('Time = %.2f s', t_data(i)));
    drawnow limitrate
end
%%
% --- 1) Extract numeric arrays ---
t_data     = out.t.Time;        
x_data     = out.x.Data;        
y_data     = out.y.Data;        
z_data     = out.z.Data;        
phi_data   = out.phi.Data; % Roll angle
theta_data = out.theta.Data; % Pitch angle

% Define rocket length
L = 20;

% Create a figure
figure('Name', '3D Rocket Animation', 'Color', 'w');
hold on; grid on;
axis equal;

% Set 3D axis limits (adjust as needed)
xlim([-200 200]);
ylim([-200 200]);
zlim([-200 200]);

% Labels
xlabel('X Position');
ylabel('Y Position');
zlabel('Z Position');
title('3D Rocket Animation');

% Skip factor
skipFactor = 1;

% Pre-plot some empty handles so we can update them
rocketLine = plot3(NaN, NaN, NaN, 'b-', 'LineWidth', 2, 'DisplayName', 'Rocket Body');
rocketDot  = plot3(NaN, NaN, NaN, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Centre of Mass');
pathLine   = plot3(NaN, NaN, NaN, 'k--', 'DisplayName', 'Actual Trajectory');

legend({'Rocket Body', 'Centre of Mass', 'Actual Trajectory'}, 'Location', 'best');

% --- Main Loop ---
for i = 1:skipFactor:length(t_data)
    % Current state
    x_i = x_data(i);
    y_i = y_data(i);
    z_i = z_data(i);
    theta = theta_data(i); % Pitch
    phi = phi_data(i); % Roll
    
    % Compute rocket nose and tail positions
    x_nose = x_i + (L / 2) * cos(theta) * cos(phi);
    y_nose = y_i + (L / 2) * cos(theta) * sin(phi);
    z_nose = z_i + (L / 2) * sin(theta);
    
    x_tail = x_i - (L / 2) * cos(theta) * cos(phi);
    y_tail = y_i - (L / 2) * cos(theta) * sin(phi);
    z_tail = z_i - (L / 2) * sin(theta);
    
    % Update the plots
    set(rocketLine, 'XData', [x_tail, x_nose], 'YData', [y_tail, y_nose], 'ZData', [z_tail, z_nose]);
    set(rocketDot,  'XData', x_i, 'YData', y_i, 'ZData', z_i);
    set(pathLine,   'XData', x_data(1:i), 'YData', y_data(1:i), 'ZData', z_data(1:i));

    % Update the title with the current time
    title(sprintf('Time = %.2f s', t_data(i)));
    drawnow limitrate
end
