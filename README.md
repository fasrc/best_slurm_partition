# BestSlurmPartition

Find the Slurm partition with the minimum delay to run your job.

- Find and print Slurm configuration: `sh findBestP.sh -f submit.sh -o set`
- Check for the best Slurm partition: `sh findBestP.sh -f submit.sh -o check`
- Help: `sh findBestP.sh -o help`

- Sample output:

--- Error using partition: aagk80  
--- Error using partition: bigmem  
--- Error using partition: gpu_requeue  
--- Check tmpwdir/error.log for error log  

--- Waiting time to run this job on SLURM partitions sorted by time (sec)  
--- 0: gpu  
--- 0: olveczky  
--- 0: olveczkygpu  
--- 0: test  
--- 0: unrestricted  
--- 1: aagk80_requeue  
--- 2: knl_centos7  
--- 480: serial_requeue  
--- 1500: general  
--- 212520: shared   


- Check `tmpwdir/error.log` for error log.


![alt text](Example.gif?raw=true "Example Run")
