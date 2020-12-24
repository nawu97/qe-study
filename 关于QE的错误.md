# 1.关键词错误

## 报错：

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
srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin```
 
 ## 原因：
srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin需要加要执行的文件名还有输出的文件名，具体为：
srun --mpi=pmi2 /public/home/wn970413/qe/q-e-qe-6.6-intel/bin/pw.x  -i pw.graphene.scf.in | tee pw.out ( | tee管道符识别输入输出)
