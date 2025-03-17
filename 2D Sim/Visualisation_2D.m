% --- 1) Extract numeric arrays ---
t_data     = out.t.Time;        
x_data     = out.x.Data;        
z_data     = out.z.Data;        
theta_data = out.theta.Data;

% --- 1a) Extract & squeeze reference data ---
x_ref_data = squeeze(out.x_ref.Data);
z_ref_data = squeeze(out.z_ref.Data);

% Define rocket length
L = 2;

% Create a figure
figure('Name', 'Rocket Animation', 'Color', 'w');
hold on; grid on; axis equal;

% Fix axis limits (adjust as needed)
axis([0 5 0 5]);
axis manual;

% Plot the complete reference trajectory in green dashed (constant)
plot(x_ref_data, z_ref_data, 'g--', 'LineWidth', 2, 'DisplayName', 'Reference Trajectory');

% Skip factor
skipFactor = 3;

% Pre-plot some empty handles so we can update them
rocketLine = plot(NaN, NaN, 'b-', 'LineWidth', 2, 'DisplayName', 'Rocket Body');
rocketDot  = plot(NaN, NaN, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Centre of Mass');
pathLine   = plot(NaN, NaN, 'k--', 'DisplayName', 'Actual Trajectory');
refPathLine = plot(NaN, NaN, 'r-', 'LineWidth', 2, 'DisplayName', 'Tracked Reference Trajectory');

% Add placeholders for legend
legend_theta_ref = plot(NaN, NaN, 'g-', 'LineWidth', 2, 'DisplayName', 'Reference Orientation');
legend_theta_actual = plot(NaN, NaN, 'm-', 'LineWidth', 2, 'DisplayName', 'Actual Orientation');

xlabel('X Position');
ylabel('Z Position');
title('Rocket Animation with Reference');
legend('show', 'Location', 'best');

% Store reference and actual orientations persistently
hold on;

% Initialize arrays for tracking the reference trajectory
tracked_x_ref = [];
tracked_z_ref = [];

% --- Main Loop ---
for i = 1:skipFactor:length(t_data)
    % Current state
    x_i = x_data(i);
    z_i = z_data(i);
    th  = theta_data(i);

    % Nose and tail positions
    x_nose = x_i + (L / 2) * sin(th);
    z_nose = z_i + (L / 2) * cos(th);
    x_tail = x_i - (L / 2) * sin(th);
    z_tail = z_i - (L / 2) * cos(th);

    % Update the plots
    set(rocketLine, 'XData', [x_tail, x_nose], 'YData', [z_tail, z_nose]);
    set(rocketDot,  'XData', x_i, 'YData', z_i);
    set(pathLine,   'XData', x_data(1:i), 'YData', z_data(1:i));

    % Track reference and actual orientations every 4 seconds
    if mod(t_data(i), 1) == 0
        % Find corresponding reference point
        x_ref = x_ref_data(i);
        z_ref = z_ref_data(i);
        
        % Compute reference body orientation (green line)
        x_nose_ref = x_ref + (L / 2) * sin(th);
        z_nose_ref = z_ref + (L / 2) * cos(th);
        x_tail_ref = x_ref - (L / 2) * sin(th);
        z_tail_ref = z_ref - (L / 2) * cos(th);
        
        % Plot reference rocket orientation (green) persistently
        plot([x_tail_ref, x_nose_ref], [z_tail_ref, z_nose_ref], 'g-', 'LineWidth', 2, 'HandleVisibility', 'off');

        % Plot actual rocket orientation (magenta) persistently
        plot([x_tail, x_nose], [z_tail, z_nose], 'm-', 'LineWidth', 2, 'HandleVisibility', 'off');
        
        % Append tracked reference trajectory points
        tracked_x_ref = [tracked_x_ref, x_ref];
        tracked_z_ref = [tracked_z_ref, z_ref];

        % Update the reference trajectory tracking line
        %set(refPathLine, 'XData', tracked_x_ref, 'YData', tracked_z_ref);
    end

    % Update the title with the current time
    title(sprintf('Time = %.2f s', t_data(i)));
    drawnow limitrate
end