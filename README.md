# BestSlurmPartition

Find the Slurm partition with the minimum delay to run your job.

- Find and print Slurm configuration: `sh findBestP.sh -f submit.sh -o set`
- Check for the best Slurm partition: `sh findBestP.sh -f submit.sh -o check`
- Help: `sh findBestP.sh -o help`

- Sample output:

--- Error in using partition: bigmem  
--- Error in using partition: gpu_requeue  

--- Results sorted by time (sec)  
--- 0 seconds on: gpu  
--- 0 seconds on: olveczky  
--- 0 seconds on: olveczkygpu  
--- 0 seconds on: test  
--- 0 seconds on: unrestricted  
--- 1380 seconds on: serial_requeue  
--- 86520 seconds on: shared  
--- 133980 seconds on: general  


- Check `tmpwdir/error.log` for error log.


![alt text](Example.gif?raw=true "Example Run")
