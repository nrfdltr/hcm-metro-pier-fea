import matplotlib.pyplot as plt
import numpy as np
import json

with open('d:/daigaku/me2091/test_c3d4/convergence_comparison_results.json', 'r') as f:
    data = json.load(f)

# Sort by seed descending (coarse to fine: 0.55 -> 0.35)
data = sorted(data, key=lambda x: x['seed'], reverse=True)

seeds = [d['seed'] for d in data]
labels = [f"h={s:.2f}m" for s in seeds]

c10_nodes = [d['c3d10']['nodes'] for d in data]
c4_nodes = [d['c3d4']['nodes'] for d in data]

ref_mises_c2 = 3.177 # Job-Local-35 C3D10
ref_disp_c2 = 3.166  # Job-Local-35 C3D10

c10_mises_c2 = [d['c3d10']['c2_mises'] for d in data]
c4_mises_c2 = [d['c3d4']['c2_mises'] for d in data]

c10_disp_c2 = [d['c3d10']['c2_umag'] for d in data]
c4_disp_c2 = [d['c3d4']['c2_umag'] for d in data]

# Normalized values
c10_norm_mises = [val / ref_mises_c2 for val in c10_mises_c2]
c4_norm_mises = [val / ref_mises_c2 for val in c4_mises_c2]

c10_norm_disp = [val / ref_disp_c2 for val in c10_disp_c2]
c4_norm_disp = [val / ref_disp_c2 for val in c4_disp_c2]

sagitta_linear = [d['delta_linear_mm'] for d in data]

plt.rcParams['font.family'] = 'DejaVu Sans'
plt.rcParams['font.size'] = 10

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(13, 5.5), dpi=300)

# ----------------- PLOT 1: Normalized Peak von Mises Stress (Fig 9 style) -----------------
ax1.axhline(1.0, color='gray', linestyle='--', linewidth=1.2, label='Converged Baseline (3.177 MPa)')
ax1.plot(seeds, c10_norm_mises, marker='o', markersize=8, color='#1f77b4', linewidth=2.0, label='C3D10 (Quadratic Tet)')
ax1.plot(seeds, c4_norm_mises, marker='s', markersize=8, color='#d62728', linewidth=2.0, label='C3D4 (Linear Tet)')

# Annotate points
for s, val in zip(seeds, c10_norm_mises):
    ax1.annotate(f"{val:.3f}\n({val*ref_mises_c2:.2f} MPa)", (s, val), textcoords="offset points", xytext=(0, 10), ha='center', fontsize=8, color='#1f77b4')
for s, val in zip(seeds, c4_norm_mises):
    ax1.annotate(f"{val:.3f}\n({val*ref_mises_c2:.2f} MPa)", (s, val), textcoords="offset points", xytext=(0, -22), ha='center', fontsize=8, color='#d62728')

ax1.set_xlim(0.58, 0.32) # Inverted x-axis so left is coarse, right is fine
ax1.set_ylim(0.65, 1.12)
ax1.set_xlabel('Localized Haunch Seed Size $h_{\\mathrm{local}}$ (m)\n[Coarse $\\longrightarrow$ Refined]', fontweight='bold')
ax1.set_ylabel('Normalized Peak von Mises Stress $\\sigma_{\\mathrm{vM,max}} / \\sigma_{\\mathrm{ref}}$', fontweight='bold')
ax1.set_title('(a) Equivalent von Mises Stress Convergence (Fig. 9 Paradigm)', fontweight='bold', pad=12)
ax1.grid(True, linestyle=':', alpha=0.6)
ax1.legend(loc='lower left', framealpha=0.95)

# ----------------- PLOT 2: Normalized Tip Deflection / Stiffness (Fig 7 style) -----------------
ax2.axhline(1.0, color='gray', linestyle='--', linewidth=1.2, label='Converged Baseline (3.166 mm)')
ax2.plot(seeds, c10_norm_disp, marker='o', markersize=8, color='#1f77b4', linewidth=2.0, label='C3D10 (Quadratic Tet)')
ax2.plot(seeds, c4_norm_disp, marker='s', markersize=8, color='#d62728', linewidth=2.0, label='C3D4 (Linear Tet - Shear Locked)')

# Annotate points
for s, val in zip(seeds, c10_norm_disp):
    ax2.annotate(f"{val:.3f} ({val*ref_disp_c2:.2f} mm)", (s, val), textcoords="offset points", xytext=(0, 10), ha='center', fontsize=8, color='#1f77b4')
for s, val in zip(seeds, c4_norm_disp):
    ax2.annotate(f"{val:.3f} ({val*ref_disp_c2:.2f} mm)", (s, val), textcoords="offset points", xytext=(0, 10), ha='center', fontsize=8, color='#d62728')

# Callout for shear locking
ax2.annotate('Severe Shear Locking in Bending\n(~76% Compliance Deficit)', xy=(0.45, 0.24), xytext=(0.48, 0.45),
             arrowprops=dict(facecolor='#d62728', shrink=0.08, width=1.5, headwidth=7),
             fontsize=9, fontweight='bold', color='#d62728',
             bbox=dict(boxstyle="round,pad=0.3", fc="#ffebee", ec="#d62728", lw=1))

ax2.set_xlim(0.58, 0.32)
ax2.set_ylim(0.15, 1.15)
ax2.set_xlabel('Localized Haunch Seed Size $h_{\\mathrm{local}}$ (m)\n[Coarse $\\longrightarrow$ Refined]', fontweight='bold')
ax2.set_ylabel('Normalized Cantilever Tip Deflection $|\\mathbf{U}| / |\\mathbf{U}|_{\\mathrm{ref}}$', fontweight='bold')
ax2.set_title('(b) Kinematic Tip Deflection Convergence (Fig. 7 Paradigm)', fontweight='bold', pad=12)
ax2.grid(True, linestyle=':', alpha=0.6)
ax2.legend(loc='center left', framealpha=0.95)

plt.tight_layout()
out_fig = 'C:/Users/Lenovo/.gemini/antigravity/brain/e9d8dab5-0ae5-4283-a119-f7fb4505aa7c/element_formulation_convergence_study.png'
plt.savefig(out_fig, dpi=300)
print(f'Successfully saved convergence plot to {out_fig}!')
