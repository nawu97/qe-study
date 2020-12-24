# 1.关键词错误

## 报错A：

```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     Error in routine  read_namelists (2):
      could not find namelist &control
      
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


     stopping ...

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   Error in routine  read_namelists (2):
    could not find namelist &control
      
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 ```
 ## 原因：
 
 ```forc_conv_thr=1.0d-5```写成了 ```force_conv_thr=1.0d-5```
 
 ## 注意关键词啊！
 
 
 ## 报错B：

```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Error in routine  control_checkin (1):
      calculation "vc_relax" not allowed
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Error in routine  control_checkin (1):
      calculation "vc_relax" not allowed
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 ```
 ## 原因：
 ### **_官网指南_**
 ```
calculation	CHARACTER
Default:	'scf'
A string describing the task to be performed. Options are:
            
'scf'
            
'nscf'
            
'bands'
            
'relax'
            
'md'
            
'vc-relax'
            
'vc-md'
(vc = variable-cell).
```
 **很明显**这里不是`vc_relax`而是`vc-relax`

 
 ## 注意关键词啊！
 
## 报错C：

```

     Program PWSCF v.6.6 starts on 24Dec2020 at 12:40:16

     This program is part of the open-source Quantum ESPRESSO suite
     for quantum simulation of materials; please cite
         "P. Giannozzi et al., J. Phys.:Condens. Matter 21 395502 (2009);
         "P. Giannozzi et al., J. Phys.:Condens. Matter 29 465901 (2017);
          URL http://www.quantum-espresso.org",
     in publications or presentations arising from this work. More details at
     http://www.quantum-espresso.org/quote

     Parallel version (MPI), running on    36 processors

     MPI processes distributed on     1 nodes
     R & G space division:  proc/nbgrp/npool/nimage =      36
     Fft bands division:     nmany     =       1
     Reading input from pw.graphene.relax.in

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Error in routine  read_namelists (1):
      bad line in namelist &system: "  ecut = 30, ecutrho=300,," (error could be in the previous line)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...
Abort(1) on node 0 (rank 0 in comm 0): application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0
srun: Job step aborted: Waiting up to 32 seconds for job step to finish.
slurmstepd: error: *** STEP 1693636.0 ON comput126 CANCELLED AT 2020-12-24T12:40:17 ***
srun: error: comput126: tasks 0-35: Killed


 ```
 ## 原因：
 

 ```
&SYSTEM
  ibrav = 4, celldm(1) = 2.46772, nat = 2, ntyp = 1,
  ecut = 30, ecutrho=300,,
  occupations='smearing', smearing='gaussian', degauss=0.01,
/
```
 **这里多打了一个,**

 ## 注意细节啊！
 
 # 2.提交任务脚本格式错误
 
 ## 报错：
``` #!/bin/bash
#SBATCH --job-name=qe
#SBATCH -N 1
#SBATCH --ntasks-per-node=36
#SBATCH --time=72:00:00
#SBATCH -p regular

module load compiler/intel/intel-compiler-2019u3
module load mpi/intelmpi/2019u3
srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin
```
 
 ## 原因：
```srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin```需要加要执行的文件名还有输出的文件名，具体为：
```srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin/pw.x  -i pw.graphene.scf.in | tee pw.out ```( ```| tee```管道符识别输入输出)
