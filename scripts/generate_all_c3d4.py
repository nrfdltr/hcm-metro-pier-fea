import os
import subprocess

seed_levels = [55, 50, 45, 40, 35]
work_dir = 'd:/daigaku/me2091/test_c3d4'

for s in seed_levels:
    orig_inp = f'd:/daigaku/me2091/hcm-metro-pier-fea/simulation/Job-Local-{s}.inp'
    new_inp = f'{work_dir}/Job-Local-{s}-C3D4.inp'
    
    with open(orig_inp, 'r') as f:
        lines = f.readlines()
        
    new_lines = []
    in_element = False
    for line in lines:
        if line.startswith('*Element, type=C3D10'):
            new_lines.append('*Element, type=C3D4\n')
            in_element = True
        elif in_element:
            if line.startswith('*'):
                in_element = False
                new_lines.append(line)
            else:
                parts = [p.strip() for p in line.split(',')]
                if len(parts) >= 5:
                    c3d4_line = ', '.join(parts[:5]) + '\n'
                    new_lines.append(c3d4_line)
                else:
                    new_lines.append(line)
        else:
            new_lines.append(line)
            
    with open(new_inp, 'w') as f:
        f.writelines(new_lines)
        
    print(f'Generated Job-Local-{s}-C3D4.inp')

print('All 5 C3D4 INP files generated!')
