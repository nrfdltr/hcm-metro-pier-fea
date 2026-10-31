# hcmc metro viaduct t-pier 3d fea simulation (me2091)

![Abaqus](https://img.shields.io/badge/Abaqus-2026_Standard-blue.svg)
![Mesh](https://img.shields.io/badge/Mesh-C3D10_Quadratic_Tet-green.svg)
![Standard](https://img.shields.io/badge/Standard-TCVN_11823--2017-orange.svg)

finite element stress and serviceability deflection simulation of an elevated viaduct t-pier substructure for ho chi minh city metro line 1 (ben thanh - suoi tien) in abaqus/standard. contains complete abaqus simulation databases (.cae), parametric solver input decks (.inp), solved binary output databases (.odb), convergence and element diagnostics (.dat, .msg, .sta), python/matlab post-processing scripts, and high-resolution setup dialogs.

---

## outline

### simulation/ >>>>>abaqus setup<<<<<
* `hcm_metro_pier_analysis.cae`: full abaqus/cae database containing partitioned geometry, c40 concrete material definitions, encastre base constraint, step history (cases 1-3), global and local seed configurations, and all 5 parametric mesh jobs.
* `Job-Local-35.inp`: primary converged solver input deck ($h_{\text{local}} = 0.35\,\text{m}$, 517 c3d10 elements, 953 nodes, 2,859 active dofs) compliant with student license limits (<1,000 nodes).
* `Job-Local-40.inp`: parametric input deck for local seed size $0.40\,\text{m}$ (433 elements, 813 nodes).
* `Job-Local-45.inp`: parametric input deck for local seed size $0.45\,\text{m}$ (428 elements, 806 nodes).
* `Job-Local-50.inp`: parametric input deck for local seed size $0.50\,\text{m}$ (354 elements, 673 nodes).
* `Job-Local-55.inp`: baseline coarse local seed input deck for local seed size $0.55\,\text{m}$ (204 elements, 432 nodes).
* `LinearStatic.inp`: historical baseline deck.

### data/ >>>>>output & diagnostics<<<<<
* `Job-Local-*.odb`: solved binary abaqus output databases across all 5 local refinement levels containing 3d tensor fields for von mises stress, principal stresses ($\sigma_1, \sigma_2, \sigma_3$), and displacement vector components ($U_1, U_2, U_3$) across all load cases.
* `Job-Local-*.dat`: abaqus printed output files recording element topology tallies, dof distributions, and memory statistics.
* `Job-Local-*.msg`: step convergence diagnostics verifying standard implicit equilibrium solutions with zero cutbacks.
* `Job-Local-*.sta`: status files recording wall-clock and cpu runtimes ($0.80\,\text{s}$ to $4.10\,\text{s}$).

### scripts/ >>>>>post-processing & visualization<<<<<
* `generate_mesh_convergence_plot.py`: standalone python script using matplotlib to render the publication-grade mesh convergence plot with dual y-axes and horizontal asymptote.
* `plot_figure6_mesh_convergence.m`: matlab script for convergence evaluation and asymptotic regression.

### images/ >>>>>high-res setup & analysis captures<<<<<
* viewport contour plots, haunch close-ups, partition diagrams, and dialog captures.

---

## substructure geometry & context

![Substructure Context](images/hcm_metro_t_pier.JPG)

* **overall pier height:** $15.100\,\text{m}$ ($2.500\,\text{m}$ pile cap footing + $9.400\,\text{m}$ prismatic column stem + $3.200\,\text{m}$ crosshead).
* **crosshead breadth:** $8.600\,\text{m}$ across top bearing deck ($2.500\,\text{m}$ longitudinal track depth).
* **column cross-section:** $2.500\,\text{m} \times 2.500\,\text{m}$ square shaft with $R = 0.500\,\text{m}$ corner fillets.
* **cantilever haunch transitions:** double-curved concave circular fillets ($R = 2.000\,\text{m}$).

---

## abaqus model & simulation setup

### 1. coordinate system & boundary conditions
![Abaqus Model](images/hcm_metro_pier_abaqus.png)

* **x-axis (track direction):** along the railway alignment ($[-1.250\,\text{m}, +1.250\,\text{m}]$).
* **y-axis (transverse):** along the crosshead cantilever arms ($[-4.300\,\text{m}, +4.300\,\text{m}]$).
* **z-axis (vertical):** opposed to gravity ($0.000\,\text{m}$ at pile cap bottom to $+15.100\,\text{m}$ at bearing seats).
* **foundation constraint:** fully fixed (encastre: $U_1 = U_2 = U_3 = UR_1 = UR_2 = UR_3 = 0$) across the bottom surface of the footing ($10.0\,\text{m} \times 8.0\,\text{m} = 80.0\,\text{m}^2$).

### 2. material properties & load cases
![Material Properties - Density](images/mat_properties_1.png)
![Material Properties - Elasticity](images/mat_properties_2.png)

* **concrete grade:** high-performance concrete (hpc) grade c40 (tcvn 11823:2017).
* **young's modulus:** $E = 32,500\,\text{MPa}$ ($3.25 \times 10^4\,\text{N/mm}^2$).
* **poisson's ratio:** $\nu = 0.20$.
* **mass density:** $\rho = 2,450\,\text{kg/m}^3 \rightarrow \rho_{\text{FEA}} = 2.45 \times 10^{-9}\,\text{tonne/mm}^3$.
* **gravity load:** $g = -9,810\,\text{mm/s}^2$ downward along component 3 ($z$-axis).
* **superstructure + train bearing pressure:** $q = 0.320\,\text{MPa}$ applied over elastomeric bearing areas ($1.000\,\text{m} \times 0.650\,\text{m}$).
  * **case 1 (self-weight only):** gravity load acting on pier volume.
  * **case 2 (one train loaded):** asymmetric live loading producing maximum transverse cantilever flexure and tip deflection.
  * **case 3 (two trains loaded):** symmetric live loading producing maximum axial compression and footing settlement.

---

## hybrid mesh refinement & convergence study

to achieve high-fidelity stress resolution around the haunch re-entrant corners while strictly respecting the 1,000-node student edition limit, a hybrid geometric partitioning and local seeding strategy was executed:
* **global seed size:** $h_{\text{global}} = 1.00\,\text{m}$ maintained constant across the footing and column shaft.
* **local haunch partition seed:** $h_{\text{local}}$ systematically refined from $0.55\,\text{m}$ down to $0.35\,\text{m}$ across 5 discrete solver jobs.

| Mesh Refinement Level | Job Name | Local Seed $h_{\text{local}}$ (m) | Elements (C3D10) | Nodes | Total DOFs | CPU Time (s) | Case 2 Mises $\sigma_{\text{vM}}$ (MPa) | Case 3 Mises $\sigma_{\text{vM}}$ (MPa) | Case 2 Tip Disp $U_y$ (mm) | Case 3 Settlement $U_z$ (mm) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | `Job-Local-55` | 0.55 | 204 | 432 | 1,296 | 0.80 | 3.216 | 2.737 | 3.112 | 0.770 |
| 2 | `Job-Local-50` | 0.50 | 354 | 673 | 2,019 | 4.10 | 3.158 | 2.606 | 3.173 | 0.767 |
| 3 | `Job-Local-45` | 0.45 | 428 | 806 | 2,418 | 1.60 | 3.054 | 2.620 | 3.165 | 0.767 |
| 4 | `Job-Local-40` | 0.40 | 433 | 813 | 2,439 | 1.50 | 3.055 | 2.603 | 3.167 | 0.768 |
| 5 (Optimal) | `Job-Local-35` | 0.35 | 517 | 953 | 2,859 | 1.10 | 3.177 | 2.590 | 3.166 | 0.768 |

![Mesh Convergence Study](images/mesh_convergence_study.png)

### mesh comparison: coarse vs fine haunch discretization
| Mesh 1: Job-Local-55 Overview (204 Elements) | Mesh 1: Haunch Detail |
| :---: | :---: |
| ![Mesh 55 Overview](images/abaqus_mesh_local55.png) | ![Mesh 55 Detail](images/abaqus_mesh_local55_closeup.png) |
| **Mesh 5: Job-Local-35 Overview (517 Elements)** | **Mesh 5: Haunch Detail** |
| ![Mesh 35 Overview](images/abaqus_mesh_local35.png) | ![Mesh 35 Detail](images/abaqus_mesh_local35_closeup.png) |

---

## visual results (optimal job-local-35)

### 1. 3d nodal displacement field contours ($|\mathbf{u}|$)

| Case 2: One Train Loaded (Asymmetric Cantilever Flexure) | Case 3: Two Trains Loaded (Symmetric Compression) |
| :---: | :---: |
| ![Displacement One Train](images/contour_u_onetrain.png) | ![Displacement Two Trains](images/contour_u_twotrains.png) |

* **case 2 cantilever flexure:** peak transverse tip deflection reaches $u_{\text{tip}} = 3.166\,\text{mm}$ at the loaded wingtip, showing excellent agreement with analytical Euler-Bernoulli beam theory ($3.190\,\text{mm}$, discrepancy $<0.75\%$) and well within the serviceability limit $\Delta_{\text{allow}} = \frac{L}{800} = 4.375\,\text{mm}$.
* **case 3 axial settlement:** uniform vertical compression and axial shortening yielding downward settlement of $u_z = 0.768\,\text{mm}$ across the bearing seats, strictly bounded within the foundation allowance.

### 2. von mises stress contours & haunch stress concentrations

| Case 2: One Train (Overall View) | Case 2: Haunch Root Close-up |
| :---: | :---: |
| ![Mises One Train](images/contour_mises_onetrain.png) | ![Mises One Train Close-up](images/contour_mises_onetrain_closeup.png) |
| **Case 3: Two Trains (Overall View)** | **Case 3: Haunch Root Close-up** |
| ![Mises Two Trains](images/contour_mises_twotrains.png) | ![Mises Two Trains Close-up](images/contour_mises_twotrains_closeup.png) |

* **case 2 peak stress:** localized von mises stress reaches $\sigma_{\text{vM}} = 3.177\,\text{MPa}$ along the haunch re-entrant corner fillet ($R = 2.0\,\text{m}$), safely below the compressive design strength ($f'_{cd} = 17.86\,\text{MPa}$, safety factor $SF = 5.62$).
* **case 3 peak stress:** symmetric haunch stress concentration reaches $\sigma_{\text{vM}} = 2.590\,\text{MPa}$ ($SF = 6.90$).

### 3. principal stress fields ($\sigma_1$ tension & $\sigma_3$ compression)

| Maximum Principal Stress ($\sigma_1$, Tension) | Minimum Principal Stress ($\sigma_3$, Compression) |
| :---: | :---: |
| ![Max Principal Stress S1](images/contour_s1_tension.png) | ![Min Principal Stress S3](images/contour_s3_compression.png) |

* **$\sigma_1$ (top deck & haunch tension):** peak tensile stress reaches $+3.861\,\text{MPa}$ along the upper cantilever fibers, close to the concrete tensile rupture modulus ($f_r = 3.98\,\text{MPa}$), demonstrating the necessity of longitudinal top tieback reinforcement.
* **$\sigma_3$ (haunch compression):** peak compressive stress reaches $-2.716\,\text{MPa}$ along the inner haunch face, well below allowable limits.

### 4. stress distribution along haunch path
![Haunch 3D Path Definition](images/abaqus_path_haunch_3d.png)
![Stress Distribution along Haunch Path](images/abaqus_path_haunch.png)

---

## usage & reproduction

### option a: run solver directly via abaqus cli
```bash
abaqus job=Job-Local-35 input=simulation/Job-Local-35.inp interactive
```

### option b: open complete model in abaqus/cae
1. launch abaqus/cae.
2. `File` $\rightarrow$ `Open Database` $\rightarrow$ select `simulation/hcm_metro_pier_analysis.cae`.
3. under the **Job** module, submit `Job-Local-35` or any of the parametric jobs (`Job-Local-40`, `Job-Local-45`, `Job-Local-50`, `Job-Local-55`).

### option c: inspect precomputed output database
```bash
abaqus viewer odb=data/Job-Local-35.odb
```

### option d: reproduce mesh convergence plot
```bash
python scripts/generate_mesh_convergence_plot.py
```

---

## references

* **metro line 1 dossier:** management authority for urban railways (maur), *design documentation for ho chi minh city urban railway construction project: substructure and superstructure specifications (cầu giản đơn dầm chữ u btdul)*, hcmc, 2020.
* **bridge design code:** ministry of science and technology, *tcvn 11823:2017: highway bridge design specifications (tiêu chuẩn thiết kế cầu đường bộ)*, ministry of transport, hanoi, 2017.
* **fea methodology:** chandrupatla & belegundu, *introduction to finite elements in engineering*, 4th ed., pearson, 2012.
