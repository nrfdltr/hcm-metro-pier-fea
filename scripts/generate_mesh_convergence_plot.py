import matplotlib.pyplot as plt
import numpy as np

mesh_labels = ["Local-55", "Local-50", "Local-45", "Local-40", "Local-35"]
x = np.arange(1, 6)

svm_case2 = [3.216, 3.158, 3.054, 3.055, 3.177]
svm_case3 = [2.737, 2.606, 2.620, 2.603, 2.590]

u_case2 = [3.112, 3.173, 3.165, 3.167, 3.166]
u_case3 = [0.770, 0.767, 0.767, 0.768, 0.768]

c_crimson = "#bf382e"
c_blue = "#2673d1"

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10.5, 4.2), dpi=300)

# Panel A
ax1.plot(x, svm_case2, "-o", color=c_crimson, linewidth=2.0, markersize=7, markerfacecolor=c_crimson, label="Case 2: 1 Train")
ax1.plot(x, svm_case3, "--s", color=c_blue, linewidth=1.8, markersize=6.5, markerfacecolor=c_blue, label="Case 3: 2 Trains")
ax1.set_xlim(0.7, 5.3)
ax1.set_ylim(2.2, 3.5)
ax1.set_xticks(x)
ax1.set_xticklabels(mesh_labels, fontsize=10)
ax1.set_xlabel("Local Edge Refinement Level (Haunch Seed)", fontsize=10.5)
ax1.set_ylabel("Max von Mises Stress $\\sigma_{\\mathrm{vM,max}}$ (MPa)", fontsize=10.5)
ax1.set_title("(a) von Mises Stress Convergence", fontweight="bold", fontsize=11)
ax1.grid(True, linestyle=":", alpha=0.6, linewidth=1.0)
ax1.legend(loc="lower left", fontsize=9, frameon=False)

# Panel B
ax2.plot(x, u_case2, "-o", color=c_crimson, linewidth=2.0, markersize=7, markerfacecolor=c_crimson, label="Case 2: 1 Train")
ax2.plot(x, u_case3, "--s", color=c_blue, linewidth=1.8, markersize=6.5, markerfacecolor=c_blue, label="Case 3: 2 Trains")
ax2.set_xlim(0.7, 5.3)
ax2.set_ylim(0.5, 3.6)
ax2.set_xticks(x)
ax2.set_xticklabels(mesh_labels, fontsize=10)
ax2.set_xlabel("Local Edge Refinement Level (Haunch Seed)", fontsize=10.5)
ax2.set_ylabel("Max Nodal Displacement $U_{\\mathrm{max}}$ (mm)", fontsize=10.5)
ax2.set_title("(b) Displacement Convergence", fontweight="bold", fontsize=11)
ax2.grid(True, linestyle=":", alpha=0.6, linewidth=1.0)
ax2.legend(loc="center right", fontsize=9, frameon=False)

plt.tight_layout()
plt.savefig("d:/daigaku/me2091/mesh_convergence_study.png", dpi=300)
print("Regenerated mesh_convergence_study.png cleanly.")
