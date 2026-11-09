from odbAccess import openOdb
import math
import sys

seeds = [0.55, 0.50, 0.45, 0.40, 0.35]
seed_strs = ['55', '50', '45', '40', '35']
R_fillet = 2.0  # meters

c3d10_dir = 'd:/daigaku/me2091/hcm-metro-pier-fea/data'
c3d4_dir = 'd:/daigaku/me2091/test_c3d4'

results = []

for idx, s in enumerate(seeds):
    s_str = seed_strs[idx]
    # Geometric arc error
    theta = 2.0 * math.asin(s / (2.0 * R_fillet))
    delta_linear = R_fillet * (1.0 - math.cos(theta / 2.0)) * 1000.0  # in mm
    # quadratic sagitta is O(h^4 / (8 R^3))
    delta_quad = (s**4) / (8.0 * (R_fillet**3)) * 1000.0 # in mm
    
    # 1. C3D10
    odb_10 = openOdb(f'{c3d10_dir}/Job-Local-{s_str}.odb')
    nodes_10 = len(odb_10.rootAssembly.instances['METROPIER-1'].nodes)
    elems_10 = len(odb_10.rootAssembly.instances['METROPIER-1'].elements)
    
    # OneTrain
    f_10_c2 = odb_10.steps['OneTrain'].frames[-1]
    mises_10_c2 = max([v.mises for v in f_10_c2.fieldOutputs['S'].values if v.mises is not None])
    u_mag_10_c2 = max([v.magnitude for v in f_10_c2.fieldOutputs['U'].values if v.magnitude is not None]) * 1000.0
    u3_10_c2 = min([v.data[2] for v in f_10_c2.fieldOutputs['U'].values if v.data is not None]) * 1000.0
    u2_10_c2 = min([v.data[1] for v in f_10_c2.fieldOutputs['U'].values if v.data is not None]) * 1000.0
    
    # TwoTrains
    f_10_c3 = odb_10.steps['TwoTrains'].frames[-1]
    mises_10_c3 = max([v.mises for v in f_10_c3.fieldOutputs['S'].values if v.mises is not None])
    u_mag_10_c3 = max([v.magnitude for v in f_10_c3.fieldOutputs['U'].values if v.magnitude is not None]) * 1000.0
    u3_10_c3 = min([v.data[2] for v in f_10_c3.fieldOutputs['U'].values if v.data is not None]) * 1000.0
    odb_10.close()
    
    # 2. C3D4
    odb_4 = openOdb(f'{c3d4_dir}/Job-Local-{s_str}-C3D4.odb')
    nodes_4 = len(odb_4.rootAssembly.instances['METROPIER-1'].nodes)
    elems_4 = len(odb_4.rootAssembly.instances['METROPIER-1'].elements)
    
    # OneTrain
    f_4_c2 = odb_4.steps['OneTrain'].frames[-1]
    mises_4_c2 = max([v.mises for v in f_4_c2.fieldOutputs['S'].values if v.mises is not None])
    u_mag_4_c2 = max([v.magnitude for v in f_4_c2.fieldOutputs['U'].values if v.magnitude is not None]) * 1000.0
    u3_4_c2 = min([v.data[2] for v in f_4_c2.fieldOutputs['U'].values if v.data is not None]) * 1000.0
    u2_4_c2 = min([v.data[1] for v in f_4_c2.fieldOutputs['U'].values if v.data is not None]) * 1000.0
    
    # TwoTrains
    f_4_c3 = odb_4.steps['TwoTrains'].frames[-1]
    mises_4_c3 = max([v.mises for v in f_4_c3.fieldOutputs['S'].values if v.mises is not None])
    u_mag_4_c3 = max([v.magnitude for v in f_4_c3.fieldOutputs['U'].values if v.magnitude is not None]) * 1000.0
    u3_4_c3 = min([v.data[2] for v in f_4_c3.fieldOutputs['U'].values if v.data is not None]) * 1000.0
    odb_4.close()
    
    results.append({
        'seed': s,
        'delta_linear_mm': delta_linear,
        'delta_quad_mm': delta_quad,
        'c3d10': {
            'nodes': nodes_10, 'elems': elems_10,
            'c2_mises': mises_10_c2, 'c2_umag': u_mag_10_c2, 'c2_u3': u3_10_c2, 'c2_u2': u2_10_c2,
            'c3_mises': mises_10_c3, 'c3_umag': u_mag_10_c3, 'c3_u3': u3_10_c3
        },
        'c3d4': {
            'nodes': nodes_4, 'elems': elems_4,
            'c2_mises': mises_4_c2, 'c2_umag': u_mag_4_c2, 'c2_u3': u3_4_c2, 'c2_u2': u2_4_c2,
            'c3_mises': mises_4_c3, 'c3_umag': u_mag_4_c3, 'c3_u3': u3_4_c3
        }
    })

print("Extraction completed! Summary:")
for r in results:
    s = r['seed']
    c10 = r['c3d10']
    c4 = r['c3d4']
    print("Seed %.2fm | Arc Sagitta: Linear=%.2fmm, Quad=%.3fmm" % (s, r['delta_linear_mm'], r['delta_quad_mm']))
    print("  C3D10: %d nodes, %d elems | C2 Mises=%.3f MPa, Disp=%.3f mm (U3=%.3f) | C3 Mises=%.3f MPa, Disp=%.3f mm" %
          (c10['nodes'], c10['elems'], c10['c2_mises'], c10['c2_umag'], c10['c2_u3'], c10['c3_mises'], c10['c3_umag']))
    print("  C3D4:  %d nodes, %d elems | C2 Mises=%.3f MPa, Disp=%.3f mm (U3=%.3f) | C3 Mises=%.3f MPa, Disp=%.3f mm" %
          (c4['nodes'], c4['elems'], c4['c2_mises'], c4['c2_umag'], c4['c2_u3'], c4['c3_mises'], c4['c3_umag']))

# Also save to JSON
import json
with open('d:/daigaku/me2091/test_c3d4/convergence_comparison_results.json', 'w') as jf:
    json.dump(results, jf, indent=2)
print("Saved JSON results!")
