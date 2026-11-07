% plot_gauss_vs_nodal_extrapolation.m
% Visualizes element stress vs. viewport contour extrapolation
% Aligned with report Section 4.3 terminology.

clear; clc; close all;

% Coordinates along normalized element
x = linspace(0, 1, 200);

% 1. Gauss integration points (Barlow points for quadratic element)
x_g = [0.5 - 1/(2*sqrt(3)), 0.5 + 1/(2*sqrt(3))]; % [0.2113, 0.7887]
sigma_g = [1.80, 3.177];                           % Stresses at Gauss points

% 2. Linear contour extrapolation through Gauss points to element boundary
p = polyfit(x_g, sigma_g, 1);
sigma_extrap = polyval(p, x);

% 3. True physical stress curve passing through Gauss points to haunch surface
p_true = polyfit([0, x_g(1), x_g(2), 1.0], [1.25, sigma_g(1), sigma_g(2), 3.380], 3);
sigma_true = polyval(p_true, x);

% Set up figure (clean, simple, publication style)
fig = figure('Color', 'w', 'Position', [200, 200, 680, 420]);
ax = axes('Parent', fig);
hold(ax, 'on'); box(ax, 'on'); grid(ax, 'on');
set(ax, 'GridLineStyle', ':', 'GridAlpha', 0.5, 'GridColor', [0.75 0.75 0.75], ...
        'FontSize', 11, 'LineWidth', 1.0);

% Plot the three components with report-aligned labels
plot(ax, x, sigma_true, 'k-', 'LineWidth', 2.2, ...
     'DisplayName', 'True physical stress (Path-Haunch)');
plot(ax, x, sigma_extrap, 'r--', 'LineWidth', 1.8, ...
     'DisplayName', 'Viewport contour extrapolation');
plot(ax, x_g, sigma_g, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8.5, 'LineWidth', 1.2, ...
     'DisplayName', 'Element stress (Gauss points)');

% Formatting
xlim(ax, [0, 1]);
ylim(ax, [1.0, 4.0]);
xlabel(ax, 'Normalized position x/L (0 = Interior, 1 = Notch surface)', 'FontSize', 11.5);
ylabel(ax, 'Equivalent von Mises stress (MPa)', 'FontSize', 11.5);
legend(ax, 'Location', 'northwest', 'Box', 'off', 'FontSize', 10);

% Export
out_png_artifact = 'C:\Users\Lenovo\.gemini\antigravity\brain\e9d8dab5-0ae5-4283-a119-f7fb4505aa7c\gauss_vs_nodal_extrapolation.png';
out_png_repo     = 'd:\daigaku\me2091\hcm-metro-pier-fea\images\gauss_vs_nodal_extrapolation.png';
out_png_scripts  = 'd:\daigaku\me2091\hcm-metro-pier-fea\scripts\gauss_vs_nodal_extrapolation.png';

exportgraphics(fig, out_png_artifact, 'Resolution', 300);
exportgraphics(fig, out_png_repo,     'Resolution', 300);
exportgraphics(fig, out_png_scripts,  'Resolution', 300);
exportgraphics(fig, out_png_local,    'Resolution', 300);

fprintf('Successfully rendered and exported cohesive visual to:\n  %s\n', out_png_artifact);
