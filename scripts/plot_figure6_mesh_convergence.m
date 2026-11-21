% PLOT_FIGURE6_MESH_CONVERGENCE.M

clear; clc; close all;

%% 1. SIMULATION CONVERGENCE DATA (FROM ABAQUS .ODB & .DAT)
% Levels: Local_80, Local_70, Local_45, Local_40, Local_30
mesh_labels = {'Local\_80', 'Local\_70', 'Local\_45', 'Local\_40', 'Local\_30'};
local_seeds = [0.80, 0.70, 0.45, 0.40, 0.30];
elements    = [3193, 16854, 20739, 21582, 32111];        % C3D10 quadratic elements
nodes       = [5386, 25836, 31596, 32852, 48360];
dofs        = [16158, 77508, 94788, 98556, 145080];

% Maximum von Mises Stress \sigma_{vM,max} (MPa)
svm_case2 = [3.927, 3.989, 3.953, 3.870, 3.842];
svm_case3 = [2.888, 2.924, 2.901, 3.019, 3.021]; 

% Maximum Nodal Displacement U_{max} (mm)
u_case2   = [3.422, 3.430, 3.430, 3.430, 3.433]; 
u_case3   = [0.922, 0.923, 0.924, 0.924, 0.924]; 
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
ylim(ax1, [2.5, 4.3]);
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
ylim(ax2, [0.5, 3.8]);
xticks(ax2, x);
xticklabels(ax2, mesh_labels);

xlabel(ax2, 'Local Edge Refinement Level (Haunch Seed)', 'FontSize', 10.5);
ylabel(ax2, 'Max Nodal Displacement U_{max} (mm)', 'FontSize', 10.5);
title(ax2, '(b) Displacement Convergence', 'FontWeight', 'bold', 'FontSize', 11);
legend(ax2, 'Location', 'east', 'FontSize', 9, 'Box', 'off');

%% 6. EXPORT PNG
exportgraphics(fig, 'd:/daigaku/me2091/mesh_convergence_study.png', 'Resolution', 300);
fprintf('Local mesh convergence plot exported successfully.\n');
