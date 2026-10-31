% PLOT_FIGURE6_MESH_CONVERGENCE.M

clear; clc; close all;

%% 1. SIMULATION CONVERGENCE DATA (FROM ABAQUS .ODB & .DAT)
% Levels: Local-55, Local-50, Local-45, Local-40, Local-35
mesh_labels = {'Local-55', 'Local-50', 'Local-45', 'Local-40', 'Local-35'};
local_seeds = [0.55, 0.50, 0.45, 0.40, 0.35];
elements    = [204, 354, 428, 433, 517];        % C3D10 quadratic elements
nodes       = [432, 673, 806, 813, 953];
dofs        = [1296, 2019, 2418, 2439, 2859];

% Maximum von Mises Stress \sigma_{vM,max} (MPa)
svm_case2 = [3.216, 3.158, 3.054, 3.055, 3.177];
svm_case3 = [2.737, 2.606, 2.620, 2.603, 2.590]; 

% Maximum Nodal Displacement U_{max} (mm)
u_case2   = [3.112, 3.173, 3.165, 3.167, 3.166]; 
u_case3   = [0.770, 0.767, 0.767, 0.768, 0.768]; 
x = 1:5;

%% 2. COLOR PALETTE
c_crimson = [0.75, 0.22, 0.18];  % Case 2 
c_blue    = [0.15, 0.45, 0.82];  % Case 3 

%% 3. FIGURE SETUP
fig = figure('Name', 'Figure 13: Local Mesh Convergence Study', ...
             'Color', 'w', ...
             'Position', [150, 150, 1050, 420]);

t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

%% 4. PANEL (A)
ax1 = nexttile(t, 1);
hold(ax1, 'on'); box(ax1, 'on'); grid(ax1, 'on');
ax1.GridLineStyle = ':'; ax1.GridAlpha = 0.35; ax1.LineWidth = 1.0;
ax1.FontSize = 10;

plot(ax1, x, svm_case2, '-o', 'Color', c_crimson, 'LineWidth', 2.0, ...
     'MarkerSize', 7, 'MarkerFaceColor', c_crimson, ...
     'DisplayName', 'Case 2: 1 Train');
plot(ax1, x, svm_case3, '--s', 'Color', c_blue, 'LineWidth', 1.8, ...
     'MarkerSize', 6.5, 'MarkerFaceColor', c_blue, ...
     'DisplayName', 'Case 3: 2 Trains');

xlim(ax1, [0.7, 5.3]);
ylim(ax1, [2.2, 3.5]);
xticks(ax1, x);
xticklabels(ax1, mesh_labels);

xlabel(ax1, 'Local Edge Refinement Level (Haunch Seed)', 'FontSize', 10.5);
ylabel(ax1, 'Max von Mises Stress \sigma_{vM,max} (MPa)', 'FontSize', 10.5);
title(ax1, '(a) von Mises Stress Convergence', 'FontWeight', 'bold', 'FontSize', 11);
legend(ax1, 'Location', 'southwest', 'FontSize', 9, 'Box', 'off');

%% 5. PANEL (B)
ax2 = nexttile(t, 2);
hold(ax2, 'on'); box(ax2, 'on'); grid(ax2, 'on');
ax2.GridLineStyle = ':'; ax2.GridAlpha = 0.35; ax2.LineWidth = 1.0;
ax2.FontSize = 10;

plot(ax2, x, u_case2, '-o', 'Color', c_crimson, 'LineWidth', 2.0, ...
     'MarkerSize', 7, 'MarkerFaceColor', c_crimson, ...
     'DisplayName', 'Case 2: 1 Train');
plot(ax2, x, u_case3, '--s', 'Color', c_blue, 'LineWidth', 1.8, ...
     'MarkerSize', 6.5, 'MarkerFaceColor', c_blue, ...
     'DisplayName', 'Case 3: 2 Trains');

xlim(ax2, [0.7, 5.3]);
ylim(ax2, [0.5, 3.6]);
xticks(ax2, x);
xticklabels(ax2, mesh_labels);

xlabel(ax2, 'Local Edge Refinement Level (Haunch Seed)', 'FontSize', 10.5);
ylabel(ax2, 'Max Nodal Displacement U_{max} (mm)', 'FontSize', 10.5);
title(ax2, '(b) Displacement Convergence', 'FontWeight', 'bold', 'FontSize', 11);
legend(ax2, 'Location', 'east', 'FontSize', 9, 'Box', 'off');

%% 6. EXPORT PNG
exportgraphics(fig, 'd:/daigaku/me2091/mesh_convergence_study.png', 'Resolution', 300);
fprintf('Local mesh convergence plot exported successfully.\n');
