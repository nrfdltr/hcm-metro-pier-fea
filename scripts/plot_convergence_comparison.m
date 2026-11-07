% plot_convergence_comparison.m
% Generates publication-grade comparison plots between C3D10 and C3D4
% Paradigm inspired by Cadet & Paredes (2024), Mechanics & Industry

clear; clc; close all;

% Local seed sizes (m)
seeds = [0.55, 0.50, 0.45, 0.40, 0.35];

% Reference values from Job-Local-35 (C3D10)
ref_mises = 3.177; % MPa
ref_disp  = 3.166; % mm

% Raw extracted values
c10_mises = [3.216, 3.158, 3.054, 3.055, 3.177];
c4_mises  = [2.387, 2.476, 2.654, 2.650, 2.848];

c10_disp  = [3.112, 3.173, 3.165, 3.167, 3.166];
c4_disp   = [0.737, 0.768, 0.759, 0.762, 0.765];

% Normalized values
c10_norm_mises = c10_mises / ref_mises;
c4_norm_mises  = c4_mises  / ref_mises;

c10_norm_disp  = c10_disp  / ref_disp;
c4_norm_disp   = c4_disp   / ref_disp;

% Create Figure
fig = figure('Color', 'w', 'Position', [100, 100, 1100, 480]);

% Color definitions
color_c10 = [0.1216, 0.4667, 0.7059]; % Academic Blue
color_c4  = [0.8392, 0.1529, 0.1569]; % Academic Red
color_ref = [0.45, 0.45, 0.45];       % Neutral Gray

% --- SUBPLOT 1: Normalized Peak von Mises Stress (Cadet Fig. 9 style) ---
subplot(1, 2, 1);
hold on; box on; grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.6, 'FontSize', 10, 'FontName', 'Helvetica');

% Baseline asymptote
yline(1.0, '--', 'Color', color_ref, 'LineWidth', 1.3, 'DisplayName', 'Converged Baseline (3.177 MPa)');

% Trajectories
p1 = plot(seeds, c10_norm_mises, '-o', 'Color', color_c10, 'LineWidth', 1.8, ...
    'MarkerSize', 7, 'MarkerFaceColor', color_c10, 'DisplayName', 'C3D10 (Quadratic Tet)');
p2 = plot(seeds, c4_norm_mises, '-s', 'Color', color_c4, 'LineWidth', 1.8, ...
    'MarkerSize', 7, 'MarkerFaceColor', color_c4, 'DisplayName', 'C3D4 (Linear Tet)');

% Numerical point annotations
for i = 1:length(seeds)
    text(seeds(i), c10_norm_mises(i) + 0.025, sprintf('%.3f\n(%.2f MPa)', c10_norm_mises(i), c10_mises(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 8, 'Color', color_c10, 'FontWeight', 'bold');
    text(seeds(i), c4_norm_mises(i) - 0.045, sprintf('%.3f\n(%.2f MPa)', c4_norm_mises(i), c4_mises(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 8, 'Color', color_c4, 'FontWeight', 'bold');
end

set(gca, 'XDir', 'reverse'); % Coarse to fine
xlim([0.32, 0.58]);
ylim([0.65, 1.15]);
xlabel(sprintf('Localized Haunch Seed Size h_{local} (m)\n[Coarse \\rightarrow Refined]'), 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Normalized Peak von Mises Stress \sigma_{vM,max} / \sigma_{ref}', 'FontSize', 10, 'FontWeight', 'bold');
title('(a) Equivalent von Mises Stress Convergence', 'FontSize', 11, 'FontWeight', 'bold');
legend([p1, p2], 'Location', 'southwest', 'Box', 'on', 'Color', [1 1 1 0.9]);

% --- SUBPLOT 2: Normalized Cantilever Tip Deflection (Cadet Fig. 7 style) ---
subplot(1, 2, 2);
hold on; box on; grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.6, 'FontSize', 10, 'FontName', 'Helvetica');

% Baseline asymptote
yline(1.0, '--', 'Color', color_ref, 'LineWidth', 1.3, 'DisplayName', 'Converged Baseline (3.166 mm)');

% Trajectories
p3 = plot(seeds, c10_norm_disp, '-o', 'Color', color_c10, 'LineWidth', 1.8, ...
    'MarkerSize', 7, 'MarkerFaceColor', color_c10, 'DisplayName', 'C3D10 (Quadratic Tet)');
p4 = plot(seeds, c4_norm_disp, '-s', 'Color', color_c4, 'LineWidth', 1.8, ...
    'MarkerSize', 7, 'MarkerFaceColor', color_c4, 'DisplayName', 'C3D4 (Linear Tet)');

% Numerical point annotations
for i = 1:length(seeds)
    text(seeds(i), c10_norm_disp(i) + 0.04, sprintf('%.3f (%.2f mm)', c10_norm_disp(i), c10_disp(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 8, 'Color', color_c10, 'FontWeight', 'bold');
    text(seeds(i), c4_norm_disp(i) + 0.04, sprintf('%.3f (%.2f mm)', c4_norm_disp(i), c4_disp(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 8, 'Color', color_c4, 'FontWeight', 'bold');
end

set(gca, 'XDir', 'reverse');
xlim([0.32, 0.58]);
ylim([0.15, 1.15]);
xlabel(sprintf('Localized Haunch Seed Size h_{local} (m)\n[Coarse \\rightarrow Refined]'), 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Normalized Cantilever Tip Deflection |U| / |U|_{ref}', 'FontSize', 10, 'FontWeight', 'bold');
title('(b) Kinematic Tip Deflection Convergence', 'FontSize', 11, 'FontWeight', 'bold');
legend([p3, p4], 'Location', 'west', 'Box', 'on', 'Color', [1 1 1 0.9]);

% Export to PNG in artifact directory and local test folder
out_png_artifact = 'C:\Users\Lenovo\.gemini\antigravity\brain\e9d8dab5-0ae5-4283-a119-f7fb4505aa7c\matlab_convergence_comparison.png';
out_png_local    = 'd:\daigaku\me2091\test_c3d4\matlab_convergence_comparison.png';

exportgraphics(fig, out_png_artifact, 'Resolution', 300);
exportgraphics(fig, out_png_local,    'Resolution', 300);

fprintf('Successfully exported plots to:\n  %s\n  %s\n', out_png_artifact, out_png_local);
