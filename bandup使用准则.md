# Bandup 使用准则
## 一.安装
### 1.下载安装anaconda2
#### 1)下载：国内用户可以到Anaconda清华镜像网站下载：@https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/
       
       选择Anaconda2-...-linux-X86_64.sh
#### 2)安装： sh Anaconda2-X.X.X-Linux-x86_64.sh
#### 3)验证：输入bash => 输入which python（出现~/anaconda2/bin/python）=> 均满足表示安装成功
#### 4）简单使用： 更新：conda update anaconda => 安装 python package：pip install package-name => 卸载python package:pip uninstall package-name

### 2.下载安装bandup（一定要基于安装python库后进行这一步）
#### 1)下载安装：git clone @https://github.com/band-unfolding/bandup.git 或者 压缩包@https://github.com/band-unfolding/bandup
#### 2）cd bandup 
#### 3)执行 ./build 即可完成安装
#### 注意事项：如果安装过程中出现缺失文件，可以用pip install xxxx安装，安装完后将bandup路径加入bashrc，即：
新增 export PATH=/home/xxx/bandup:$PATH;保存退出编辑，source ~/.bashrc;用which bandup或者bandup -h 来检查路径是否正确


## 二.基本使用方法
### 以bandup/tutorial/Quantum-espresso/example_2_bulk_Si来研究
### 切记 不要使用example_1_graphene_rectangular_SC！！！（这个tutorial有问题，大坑！）

#### Step1.得到收敛的电荷密度
基本做法： 准备一个输入文件*scf.in*和一个提交任务的脚本（重新修饰；提交任务）
提交任务的脚本（适合于怀柔服务器的脚本）如下：
```
#!/bin/bash
#SBATCH --nodes 1 
#SBATCH -J Si
#SBATCH -t 1-00:00:00
#SBATCH -p regular

ulimit -s unlimited
ulimit -c unlimited
#module load pmix/2.2.2
module load parallel_studio/2020.2.254
module load intelmpi/2020.2.254

# Path to QE. You probably need to modify this!
pwscf=/home/users/nawu/qe/TDPW6.6/pw.x
# Modify or remove this to suit your needs
export ESPRESSO_TMPDIR="./outdir" 
# Modify this to point to your pseudopotential folder
export ESPRESSO_PSEUDO=`pwd`/'../../upf_files'

mpirun $pwscf -input bulk_Si_pwscf.in > pwscf.out

#End of script


```
这样便可以得到一系列自洽的波函数于`/outdir`文件中

#### Step2.得到用于超胞能带结构计算的k点
##### 1）基本做法： 准备三个文件：primtivecell lattice.in(包含原胞的晶格信息)，supercell lattice.in（包含超胞的晶格信息）,KPOINTS_primitive cell.in（包含primitive cell的高对称路径）
##### 2）文件内容：
###### primtivecell lattice.in(包含原胞的晶格信息)
```
Si ! Bulk Si, primitive cell vectors (diamond structure)
   5.430000000
   0.000000000   0.500000000   0.500000000
   0.500000000   0.000000000   0.500000000
   0.500000000   0.500000000   0.000000000

```
###### supercell lattice.in（包含超胞的晶格信息）
```
 Si ! Bulk Si, SC vectors                                                                    
   5.430000000
   1.000000000   0.000000000   0.000000000
   0.000000000   1.000000000   0.000000000
   0.000000000   0.000000000   1.000000000

```
###### KPOINTS_primitive cell.in（包含primitive cell的高对称路径）
```
Kpoints along some high symmetry directions on the pcbz of Si (diamond structure)
23 27 9 29
Line-mode
Reciprocal
0.500 0.500 0.500   1  ! L
0.000 0.000 0.000   1  ! G

0.000 0.000 0.000   1  ! G
0.500 0.000 0.500   1  ! X

0.500 0.000 0.500   1  ! X
0.625 0.250 0.625   1  ! U

0.375 0.375 0.750   1  ! K
0.000 0.000 0.000   1  ! G

```
###### 提交任务的脚本如下：
```
#!/bin/bash


exe="bandup"
task='kpts-sc-get'
task_args=''

command_to_run="${exe} ${task} ${task_args}"

eval $command_to_run

```
执行上述脚本进一步可以得到原胞到超胞产生的超胞k点路径
#### Step3.得到用于反折叠的超胞波函数

##### 基于上一部分得到的超胞的k点来计算对应的超胞的波函数，也就是在step2得到的k点的基础上进行超胞的自洽计算
##### 1）基本做法： 准备三个文件：supercell.in(包含超胞的晶格信息，这时候K点也对应的是超胞的k点)与提交任务的脚本
##### 2）文件内容：
 提交任务的脚本如下
```
#!/bin/bash
#SBATCH --nodes 1
#SBATCH -J  G_SC_Bands
#SBATCH -t 1-00:00:00
#SBATCH -p regular


ulimit -s unlimited
ulimit -c unlimited
#module load pmix/2.2.2
module load parallel_studio/2020.2.254
module load intelmpi/2020.2.254

# Path to QE. You probably need to modify this!
pwscf=/home/users/nawu/qe-6.4.1-oldxml/bin/pw.x

# Modify or remove this to suit your needs
export ESPRESSO_TMPDIR="outdir" 
# Modify this to point to your pseudopotential folder
export ESPRESSO_PSEUDO=`pwd`/'../../upf_files'

ln -s ../step_1_get_converged_charge_density/${ESPRESSO_TMPDIR} .
mpirun $pwscf -input bulk_Si_pwscf_bands.in > pwscf_bands.out

#End of script

```
#### Step4.执行Bandup并且画图
基本做法： 准备.sh文件
#!/bin/bash
```

# BandUP可以自己从自洽结果中得到费米能的数值，如果没办法得到，可以手动设置"-efermi VALUE_IN_eV"
unfolding_task_args="-qe -prefix bulk_Si_exmpl2_BandUP -outdir ../step_3*/outdir"
unfolding_task_args="${unfolding_task_args} -emin -13 -emax 6 -dE 0.050"
plot_task_args='-input_file unfolded_EBS_symmetry-averaged.dat --show --save'
plot_task_args="${plot_task_args} -plotdir plot --round_cb 0"

# Choose OMP_NUM_THREADS=1 if you do not want openmp parallelization. 
# I normally use OMP_NUM_THREADS=n_cores/2
export OMP_NUM_THREADS=2

exe="bandup"

# Preparing to run BandUP's "unfold" task
task='unfold'
task_args=${unfolding_task_args}
command_to_run="${exe} ${task} ${task_args}"
# Running BandUP with the task and task-specific options requested
ulimit -s unlimited
eval $command_to_run

# Preparing to run BandUP's "plot" task
task='plot'
task_args=${plot_task_args}
command_to_run="${exe} ${task} ${task_args}"
# Running BandUP with the task and task-specific options requested
eval $command_to_run

# End of script

```
最后，如果输出这样的内容证明，完成BANDUP能带反折叠的基本功能
<img width="521" alt="捕获" src="https://user-images.githubusercontent.com/76439954/111279965-212a5600-85f0-11eb-9c8c-aea66816173e.PNG">

## 三.注意事项
### 1.问题1:显示无法打开xml文件，如下图所示
<img width="926" alt="26fe4553f907e04a7a74d2b555199eb" src="https://user-images.githubusercontent.com/76439954/111239652-8f910780-8634-11eb-9333-de2667dea408.png">

#### 1) 原因：
qe从6.4之后就不支持老版本的波函数和xml文件输出了而bandup不识别新的输出格式

#### 2)解决方法：重装了qe6.4，改了一下源码，第三步用qe6.4来做，也就是说第一步利用qe6.6产生，第三步利用qe6.4产生，注意处理器的选择!
```
module load compiler/intel/intel-compiler-2019u3
module load mpi/intelmpi/2017.4.239
```
也就是在使用时
configure的时候记得加上这个指令：
`-D__OLDXML`或者改`make.inc`，其中`DFLAGS = -D__DFTI -D__MPI -D__OLDXML`，然后`make pw`
### 一定要注意 `-D__OLDXML`中间是__（两个下划横线）不是_（一个下划横线）！

### 2.问题2:验证例子千万不要用ex1
