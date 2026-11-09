import os
import subprocess
import time

abaqus_cmd = r'C:\Program Files\SIMULIA\Commands\abaqus.bat'
work_dir = r'd:\daigaku\me2091\test_c3d4'
seed_levels = [55, 50, 45, 40, 35]

for s in seed_levels:
    job_name = f'Job-Local-{s}-C3D4'
    inp_name = f'{job_name}.inp'
    print(f'Starting {job_name}...')
    t0 = time.time()
    cmd = [abaqus_cmd, f'job={job_name}', f'input={inp_name}', 'interactive']
    res = subprocess.run(cmd, cwd=work_dir, capture_output=True, text=True)
    dt = time.time() - t0
    print(f'Finished {job_name} in {dt:.2f}s, exit code: {res.returncode}')
    if res.returncode != 0:
        print(f'Error output:\n{res.stderr}\n{res.stdout}')

print('All 5 jobs finished!')
