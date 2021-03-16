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
### 以bandup/tutorial/Quantum-espresso/example_1_graphene_rectangular_SC来研究
#### Step1.得到收敛的电荷密度
基本做法： 准备一个输入文件*scf.in*和一个提交任务的脚本（重新修饰；提交任务）
提交任务的脚本（适合于怀柔服务器的脚本）如下：
```
#!/bin/bash
#SBATCH --nodes 1 
#SBATCH -J Graphene_SC
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

mpirun $pwscf -input graphene_rect_SC_pwscf.in > pwscf.out

#End of script
```
这样便可以得到一系列自洽的波函数于`/outdir`文件中

#### Step2.得到用于超胞能带结构计算的k点
##### 1）基本做法： 准备三个文件：primtivecell lattice.in(包含原胞的晶格信息)，supercell lattice.in（包含超胞的晶格信息）,KPOINTS_primitive cell.in（包含primitive cell的高对称路径）
##### 2）文件内容：
###### primtivecell lattice.in(包含原胞的晶格信息)
```
C ! Graphene primitive cell                                                                  
   2.467000000
   0.866025403  -0.500000000   0.000000000
   0.866025403   0.500000000   0.000000000
   0.000000000   0.000000000   6.080259424 # If this is the last line (or if the next line is blank), then BandUP ignores the positions of the atoms.
  2
Selective Dynamics  
Cartesian 
   0.288675135   0.000000000   3.040129712  F  F  F
   1.443375672   0.000000000   3.040129712  F  F  F

```
###### supercell lattice.in（包含超胞的晶格信息）
```
 C ! Graphene - Zigzag                                                          
   2.467000000
   3.464101614   0.000000000   0.000000000
   0.000000000   3.000000000   0.000000000
   0.000000000   0.000000000   6.080259424 # If this is the last line (or if the next line is blank), then BandUP ignores the positions of the atoms.
  C
  24
Selective Dynamics  
Cartesian 
   0.288675133   0.500000000   3.040129712  F  F  F
   0.577350267   0.000000000   3.040129712  F  F  F
   1.154700536   0.000000000   3.040129712  F  F  F
   1.443375670   0.500000000   3.040129712  F  F  F
   2.020725940   0.500000000   3.040129712  F  F  F
   2.309401074   0.000000000   3.040129712  F  F  F
   2.886751343   0.000000000   3.040129712  F  F  F
   3.175426477   0.500000000   3.040129712  F  F  F
   0.288675133   1.500000000   3.040129712  F  F  F
   0.577350267   1.000000000   3.040129712  F  F  F
   1.154700536   1.000000000   3.040129712  F  F  F
   1.443375670   1.500000000   3.040129712  F  F  F
   2.020725940   1.500000000   3.040129712  F  F  F
   2.309401074   1.000000000   3.040129712  F  F  F
   2.886751343   1.000000000   3.040129712  F  F  F
   3.175426477   1.500000000   3.040129712  F  F  F
   0.288675133   2.500000000   3.040129712  F  F  F
   0.577350267   2.000000000   3.040129712  F  F  F
   1.154700536   2.000000000   3.040129712  F  F  F
   1.443375670   2.500000000   3.040129712  F  F  F
   2.020725940   2.500000000   3.040129712  F  F  F
   2.309401074   2.000000000   3.040129712  F  F  F
   2.886751343   2.000000000   3.040129712  F  F  F
   3.175426477   2.500000000   3.040129712  F  F  F

```
###### KPOINTS_primitive cell.in（包含primitive cell的高对称路径）
```
K-points along the directions K1-Gamma, Gamma-M1, M1-K1
 25 25 13
Line-mode 0.000000000
Reciprocal
   0.333333333  0.666666667  0.000000000    1 ! K
   0.000000000  0.000000000  0.000000000    1 ! Gamma

   0.000000000  0.000000000  0.000000000    1 ! Gamma
   0.500000000  0.500000000  0.000000000    1 ! M

   0.500000000  0.500000000  0.000000000    1 ! M
   0.333333333  0.666666667  0.000000000    1 ! K

```
###### 提交任务的脚本如下：
```
#!/bin/bash

exe="bandup"

task='kpts-sc-get'

task_args=''

# Command that will be run. The syntax is always this. 
command_to_run="${exe} ${task} ${task_args}"

# Running BandUP with the task and task-specific options requested
eval $command_to_run

# End of script

```
执行上述脚本`./sh`进一步可以得到原胞到超胞产生的超胞k点路径
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
mpirun $pwscf -input graphene_rect_SC_pwscf_bands.in > pwscf_bands.out

#End of script

```
#### Step4.执行Bandup并且画图


## 三.注意事项
### 1.问题1:显示无法打开xml文件，如下图所示
<img width="926" alt="26fe4553f907e04a7a74d2b555199eb" src="https://user-images.githubusercontent.com/76439954/111239652-8f910780-8634-11eb-9333-de2667dea408.png">

#### 1) 原因：
qe从6.4之后就不支持老版本的波函数和xml文件输出了而bandup不识别新的输出格式

#### 2)解决方法：重装了qe6.4，改了一下源码，第三步用qe6.4来做，也就是说第一步利用qe6.6产生，第三步利用qe6.4产生，注意处理器的选择![273808575174326776](https://user-images.githubusercontent.com/76439954/111239952-3b3a5780-8635-11eb-8002-2c8df0163d86.png)
也就是在使用时
configure的时候记得加上这个指令：-D__OLDXML或者改make.inc，其中DFLAGS = -D__DFTI -D__MPI -D__OLDXML，然后make pw
