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
 **还有这里应该`ecutwfc`打成了`ecut`**

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
```srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin```
需要加要执行的文件名还有输出的文件名，具体为：

```srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin/pw.x  -i pw.graphene.scf.in | tee pw.out ```( ```| tee```管道符识别输入输出)

# 3.qe中关于*.in文件不完整带来的错误

## 报错：

```
run: Job step aborted: Waiting up to 32 seconds for job step to finish.
     Program PWSCF v.6.6 starts on 24Dec2020 at 21:22:21

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
     Error in routine  read_namelists (2):
      could not find namelist &cell
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Error in routine  read_namelists (2):
      could not find namelist &cell
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Error in routine  read_namelists (2):
      could not find namelist &cell
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

```
## 原因：由于*.in文件中缺少 `NMAELIST &CELL`
```
&CONTROL
  calculation='vc-relax',
  restart_mode='from_scratch'
  prefix='Graphene_relax',
  pseudo_dir = '../pseudo/',
  outdir='../tmp',
  forc_conv_thr=1.0d-5
/
&SYSTEM
  ibrav = 4, celldm(1) = 2.46772, nat = 2, ntyp = 1,
  ecutwfc = 30, ecutrho=300,
  occupations='smearing', smearing='gaussian', degauss=0.01,
/
&ELECTRONS
  conv_thr=1.0d-8
/
&IONS
  ion_dynamics='bfgs'
/
ATOMIC_SPECIES
   C   12.01060  C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS {crystal}
C   0.000000000000000   0.000000000000000   0.750000000000000
C   0.333333333333333   0.666666666666667   0.750000000000000
K_POINTS {automatic}
5 5 1 0 0 0
```
**不妨加入`NMAELIST &CELL`部分，如下：**
```
&CONTROL
  calculation='vc-relax',
  restart_mode='from_scratch'
  prefix='Graphene_relax',
  pseudo_dir = '../pseudo/',
  outdir='../tmp',
  forc_conv_thr=1.0d-5
/
&SYSTEM
  ibrav = 4, celldm(1) = 2.46772, nat = 2, ntyp = 1,
  ecutwfc = 30, ecutrho=300,
  occupations='smearing', smearing='gaussian', degauss=0.01,
/
&ELECTRONS
  conv_thr=1.0d-8
/
&CELL
  cell_dynamics='bfgs',
  press=0.0,
  press_conv_thr=0.5
/
&IONS
  ion_dynamics='bfgs'
/
ATOMIC_SPECIES
   C   12.01060  C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS {crystal}
C   0.000000000000000   0.000000000000000   0.750000000000000
C   0.333333333333333   0.666666666666667   0.750000000000000
K_POINTS {automatic}
5 5 1 0 0 0
```
**但这样改完还是不对！**
**_事实上，如果`&CELL`里面没有参数也要写着，即：_**
```
&CELL
/
```
### 于是，重要的提醒！！！

### 一定要参见qe官网的指南，包括 `&ELECTRONS /`，`&IONS /`，`&CELL /`的顺序
#### 先写 `&ELECTRONS /` 后写`&IONS /`最后写`&CELL /`

示例改为：
```

&CONTROL
   calculation='vc-relax',
   restart_mode='from_scratch'
   prefix='Graphene_relax',
   pseudo_dir = '../pseudo-in-use/',
   outdir='../tmp',
   forc_conv_thr=1.0d-5,
/
&SYSTEM
   ibrav = 4, celldm(1) = 2.46772, celldm(3) = 8.68503, nat = 2, ntyp = 1,
   ecutwfc = 30, ecutrho=300,
   occupations='smearing', smearing='gaussian', degauss=0.01,
/
&ELECTRONS
   conv_thr=1.0d-8,
/
&IONS
   ion_dynamics='bfgs',
/
&CELL
   cell_dynamics='bfgs',
   press=0.0d0,
   press_conv_thr=0.5d0,
/
ATOMIC_SPECIES
C  12.01060  C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS {crystal}
C   0.000000000000000   0.000000000000000   0.750000000000000
C   0.333333333333333   0.666666666666667   0.750000000000000
K_POINTS {automatic}
5 5 1 0 0 0

```
# 4.qe自身的问题
最好在输入文件最后一行加上空格
QE有问题，读到最后一行是空白就停了，没有空行容易读卡死
在QE的后处理程序里面经常遇到这样的错误

# 5.
## 报错：
```
http://xn--linux-9n1h./
Intel MKL ERROR: Parameter 8 was incorrect on entry to ZGEMM .


     Error in routine davcio (3):
     wrong record length
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...
Abort(1) on node 35 (rank 35 in comm 0): application called MPI_Abort(MPI_COMM_WORLD, 1) - process 35
srun: Job step aborted: Waiting up to 32 seconds for job step to finish.
slurmstepd: error: *** STEP 1694456.0 ON comput19 CANCELLED AT 2020-12-25T12:23:27 ***
Abort(1) on node 19 (rank 19 in comm 0): application called MPI_Abort(MPI_COMM_WORLD, 1) - process 19
```
## 官方指南
**davcio** is the routine that performs most of the I/O operations (read from disk and write to disk) in pw.x; error in davcio means a failure of an I/O operation.

**If the error is reproducible and happens at the beginning of a calculation:** check if you have read/write permission to the scratch directory specified in variable outdir. Also: check if there is enough free space available on the disk you are writing to, and check your disk quota (if any).

**If the error is irreproducible:** your might have flaky disks; if you are writing via the network using NFS (which you shouldn't do anyway), your network connection might be not so stable, or your NFS implementation is unable to work under heavy load

**If it happens while restarting from a previous calculation:** you might be restarting from the wrong place, or from wrong data, or the files might be corrupted. Note that, since QE 5.1, restarting from arbitrary places is no more supported: the code must terminate cleanly.

**If you are running two or more instances of pw.x at the same time**, check if you are using the same file names in the same temporary directory. For instance, if you submit a series of jobs to a batch queue, do not use the same outdir and the same prefix, unless you are sure that one job doesn't start before a preceding one has finished.

### 解析：`Intel MKL ERROR: Parameter 8 was incorrect on entry to ZGEMM`超过了可对角化的范围，也就是这个问题的方程无解，这个问题本身有问题
仔细想想，应该是这个材料的结构 **不正确** 
**官网上给出有关描述材料结构的两种方法，如下**
1)ibrav!=0 利用celldm(1)-celldm(6)分别描述a,b,c,cos(ab),cos(ac),cos(bc)**注意**:这时候单位是Bohr,1Bohr=0.529Anstrom，具体格式如下：
```
&CONTROL
   calculation='vc-relax',
   prefix='Graphene_relax',
   pseudo_dir = './pseudo/',
   outdir='./tmp',
   forc_conv_thr=1.0d-5
/
&SYSTEM
   ibrav = 4, celldm(1) = 4.6648847, celldm(3) = 3.5194523, nat = 2, ntyp = 1,
   ecutwfc = 30, ecutrho=300,
   occupations='smearing', smearing='gaussian', degauss=0.01
/
&ELECTRONS
   conv_thr=1.0d-8
/
&IONS
   ion_dynamics='bfgs'
/
&CELL
   cell_dynamics='bfgs',
   press=0.0d0,
   press_conv_thr=0.5d0
/
ATOMIC_SPECIES
C  12.01060  C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS {crystal}
C   0.000000000000000   0.000000000000000   0.750000000000000
C   0.333333333333333   0.666666666666667   0.750000000000000
K_POINTS {automatic}
5 5 1 0 0 0
```
2)ibrav=0 利用A=...(单位是Anstrom),CELL_PARAMETERS来描述原子位置，主要格式与VASP中的POSCAR对应，这个便于其后续查找对应，较为方便
```
&CONTROL
   calculation='vc-relax',
   prefix='Graphene_relax',
   pseudo_dir = './pseudo/',
   outdir='./tmp',
   forc_conv_thr=1.0d-5
/
&SYSTEM
   ibrav = 4, celldm(1) = 4.6648847, celldm(3) = 3.5194523, nat = 2, ntyp = 1,
   ecutwfc = 30, ecutrho=300,
   occupations='smearing', smearing='gaussian', degauss=0.01
/
&ELECTRONS
   conv_thr=1.0d-8
/
&IONS
   ion_dynamics='bfgs'
/
&CELL
   cell_dynamics='bfgs',
   press=0.0d0,
   press_conv_thr=0.5d0
/
ATOMIC_SPECIES
C  12.01060  C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS {crystal}
C   0.000000000000000   0.000000000000000   0.750000000000000
C   0.333333333333333   0.666666666666667   0.750000000000000
K_POINTS {automatic}
5 5 1 0 0 0
```
## 注意：这两种格式相互转换时，要注意单位变换第一种单位是Bohr，第二种是Anstrom
# 6.计算dos所出的问题
## 报错：
```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Error in routine read_conf_from_file (1):
     fatal error reading xml file
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...
                                            
```
## 原因：需要用prefix指定输入文件，在自洽基础上去非自洽，所以一定要注意prefix的合理性
**scf(pw.x)--->nscf(pw.x)--->dos(dos.x)**
# 7.开始时的错误
```
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Error in routine electrons (1):
     charge is wrong: smearing is needed
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     stopping ...
```
## 原因：需要指定
```
occupations='smearing', smearing='gaussian', degauss=0.01
```
这时，需要人为指定smearing跑一步（nstep=1），然后再利用`restart_mode='from_scratch'`更改为`restart_mode='restart'`在开始重新跑
