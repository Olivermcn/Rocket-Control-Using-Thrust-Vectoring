clear
clc
clf
close all
load("rocket.mat")
set(0,'defaulttextInterpreter','latex','DefaultLegendInterpreter','latex','DefaultLineLineWidth', 1.5,'defaultAxesFontSize',11);

% Run simulation
out = sim('RocketPlant.slx', 'StopTime', '300');

% Extract data from timeseries objects
euler_angles = get(out, 'euler_angles'); % [1x1 timeseries]
position_earth = get(out, 'position');  % [1x1 timeseries]
thrust = get(out, 'thrust');            % [1x1 timeseries]

% Extract time and data from timeseries
time_array = euler_angles.time;              % time vector
euler_angles_array = euler_angles.data;      % Euler angles data
position_earth_array = position_earth.data;  % Position data
thrust_array = thrust.data;                  % Thrust data

% Verify the data
disp(size(time_array)); % Display size of time_array
disp(size(euler_angles_array)); % Display size of euler_angles_array
disp(size(position_earth_array)); % Display size of position_earth_array
disp(size(thrust_array)); % Display size of thrust_array

% Display first few values to check if data is correct
disp('First 5 time values:');
disp(time_array(1:5)); % Display first 5 time values
disp('First 5 Euler angles:');
disp(euler_angles_array(1:5, :)); % Display first 5 rows of Euler angles
disp('First 5 Position data:');
disp(position_earth_array(1:5, :)); % Display first 5 rows of position
disp('First 5 Thrust data:');
disp(thrust_array(1:5)); % Display first 5 values of thrust

save("rocket","euler_angles","position_earth","thrust")
Length = [0.5 0.5 1.5]; % Side length of the cube
figure;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Wireframe Cube');
grid on;
view(3);

% Loop through each time step
for i = 1:length(time_array)
    % Extract position and Euler angles
    cg = position_earth_array(i, 1:3);
    cg(3) = -cg(3); % Adjust z-coordinate
    cg(2) = -cg(2); % Adjust y-coordinate
    phi = euler_angles_array(i,1);
    theta = euler_angles_array(i,2);
    psi = euler_angles_array(i,3);

    % Ensure thrust data is valid (get the 1x3 vector for thrust at time i)
    thrust = thrust_array(i, :); % Get the thrust vector for the i-th time step
    disp(['Thrust at time step ', num2str(i), ': ', num2str(thrust)]); % Display thrust data for verification

    % Transformation matrix from Euler angles
    T_etob = [cos(theta)*cos(psi), sin(theta)*sin(phi)*cos(psi)-cos(phi)*sin(psi), cos(phi)*sin(theta)*cos(psi)+sin(phi)*sin(psi);
              cos(theta)*sin(psi), sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi), cos(phi)*sin(theta)*cos(psi)-sin(phi)*cos(psi);
              -sin(theta), sin(phi)*cos(theta), cos(phi)*cos(theta)]';

    cla; % Clear current axes
    plotRocket3D(cg, Length, T_etob, thrust); % Pass thrust as a 1x3 vector
    pause(0.001); % Pause for better visualization
end


function plotRocket3D(cg, lengths, Tetob, thrust_array)
    % lengths is a vector [length, width, height]
    length = lengths(1);
    width = lengths(2);
    height = lengths(3);

    % Define the half side lengths
    halfLength = length / 2;
    halfWidth = width / 2;
    halfHeight = height / 2;

    % Define the vertices of the cuboid
    vertices = [
        -halfLength, -halfWidth, -halfHeight;
        halfLength, -halfWidth, -halfHeight;
        halfLength, halfWidth, -halfHeight;
        -halfLength, halfWidth, -halfHeight;
        -halfLength, -halfWidth, halfHeight;
        halfLength, -halfWidth, halfHeight;
        halfLength, halfWidth, halfHeight;
        -halfLength, halfWidth, halfHeight;
    ];

    % Transform vertices using Tetob matrix
    [row, ~] = size(vertices);
    newVertices = zeros(size(vertices));
    for v = 1:row
        newVertices(v, :) = (Tetob * vertices(v, :)')';
    end

    % Shift vertices to be centered at cg
    newVertices = newVertices + cg;

    % Define the edges of the cuboid
    edges = [
        1, 2; 2, 3; 3, 4; 4, 1; % bottom edges
        5, 6; 6, 7; 7, 8; 8, 5; % top edges
        1, 5; 2, 6; 3, 7; 4, 8; % vertical edges
    ];

    nose = Tetob * [0; 0; halfHeight + 0.5] + cg';

    % Plot body
    hold on;
    for i = 1:size(edges, 1)
        plot3(newVertices(edges(i, :), 1), newVertices(edges(i, :), 2), newVertices(edges(i, :), 3), 'b');
    end

    % Plot nose
    for j = 5:row
        plot3([nose(1); newVertices(j, 1)], [nose(2); newVertices(j, 2)], [nose(3); newVertices(j, 3)], 'r');
    end

    support_end = vertices(1:4, :) + [-0.2 -0.2 -0.2; 0.2 -0.2 -0.2; 0.2 0.2 -0.2; -0.2 0.2 -0.2];

    % Rotate support coordinates
    for k = 1:4
        newSupport_end(k, :) = (Tetob * support_end(k, :)')';
    end 

    newSupport_end = newSupport_end + cg;

    % Plot landing supports
    for L = 1:4
        plot3([newVertices(L, 1); newSupport_end(L, 1)], [newVertices(L, 2); newSupport_end(L, 2)], [newVertices(L, 3); newSupport_end(L, 3)], 'b');
    end

    % Plot thrust
    thrust_start = Tetob * [0; 0; -halfHeight] + cg';

    thrust_scaling = 0.0005;
    alpha = thrust_array(1);  % Extract thrust components
    beta = thrust_array(2);
    T = thrust_array(3);
    Tx = -T * sin(alpha) * thrust_scaling;
    Ty = -T * cos(alpha) * sin(beta) * thrust_scaling;
    Tz = -T * cos(alpha) * cos(beta) * thrust_scaling;

    thrust_end = Tetob * [Tx; Ty; -halfHeight + Tz] + cg';

    plot3([thrust_start(1); thrust_end(1)], [thrust_start(2); thrust_end(2)], [thrust_start(3); thrust_end(3)], 'g')
    hold off;
end
