## BestSlurmPartition

Find a Slurm partition with the minimum delay to start your job on cluster.

- Check for the Slurm partition with the minimum delay: `sh find-best-partition -f submit.sh -o check`
- [Optional] Find and save Slurm configuration files in `tmpwdir` directory: `sh find-best-partition -f submit.sh -o set`
- Help: `sh find-best-partition -o help`

You may omit the `sh` command if the file has the execute permission.

### Sample output:

--- Error using partition: fas_gpu  
--- Error using partition: bigmem  
--- Error using partition: gpu  
--- Error using partition: gpu_requeue  
--- Error using partition: test  
--- Check tmpwdir/error.log for error log  

--- Waiting time to run this job on SLURM partitions sorted by time (sec)  
--- 0: knl_centos7  
--- 0: olveczky  
--- 0: remotedesktop  
--- 0: serial_requeue  
--- 1: shared  
--- 2: olveczkygpu  
--- 360: general  
--- 310497045: unrestricted  

--- Find SLURM submission scripts inside tmpwdir/ folder  



![alt text](Example.gif?raw=true "Example Run")
