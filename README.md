# qe-study
这是一些关于QE的脚本。

downupf用来下载qe上所有pslibrary元素的赝势，形成赝势库。
test-cutwfc用来测试截断能。

tdapw-presentation主要包括关于tdapw的ppt,cif2cell文件包括转换cif文件。
QE-Tutorial是关于QE的教程，主要针对的是graphene。

QE计算的能带没有减去费米能级

nstep 这个参数默认值：
    1   如果calculation='scf','nscf','bands'
    50  其他情况
## 产生*.in文件
将cif2cell安装，命令
```
cif2cell *.cif -p quantumn-espreeso
```
得到*.in文件，包含坐标信息
具体的，可参阅：
```
cif2cell 222-nv_center-\[10-1\].cif -p quantum-espresso


```
## k点并行计算可以调高计算速率
参数有
`-nk`,`-npool`,`-npools`，`-npool 3`
记得一定要设成核数的整数倍，可以使K点均分，因此最好是偶数
还有就是与Node数等同

## vesta 不显示小黑框
Objects > Properties > General > do not show


## 增加SOC
1）赝势的选择：选择带有rel的赝势

2）对称性
关于对称性，有关的参数包括``
```
nosym	LOGICAL
Default:	.FALSE
```
这一参数是指对称性默认情况下是考虑了的，我们计算的时候需要打破对称性，即把选项设置成.true.使得k与-k不等价


3）&SYSTEM里的参数
```
lspinorb	LOGICAL
if .TRUE. the noncollinear code can use a pseudopotential with
spin-orbit.
```
将lspinorb设置成true，非线性过程开始计算SOC的情况

## qe里关于弛豫的一点思考
@https://www.researchgate.net/post/relax_or_vc-relax_which_one_for_optimization_of_primary_cell_in_QE_or_generally_other_DFT_codes2
### calculation='vc-relax'和calculation='relax'的选择
If you use 'vc-relax', you are simulating the effect of periodic defects on the lattice constants of the entire crystal, as well as on the local atomic positions of the atoms. On the other hand, 'relax' implies that the lattice constants are fixed to the values set by the rest of the crystal (implying that the rest of the crystal is more or less defect-free). Performing vc-relax with and without a defect will also give you information about the effect of the defect on the lattice constant.

解释：如果是周期性的晶胞，弛豫改变通常要用'vc-relax'；如果是'relax'通常是指固定晶格常数

## 参考@https://zhuanlan.zhihu.com/p/84789491


## 高对称点的寻找
1）materials cloud @https://www.materialscloud.org/work/tools/seekpath


2) vaspkit (huairou 集群)


3) 文献 @https://www.sciencedirect.com/science/article/pii/S0927025610002697


4) aflow

### 格式：
```
K_POINTS {crystal}
8
   0.0000000000     0.0000000000     0.0000000000     40
   0.0000000000     0.5000000000     0.0000000000     40
   0.5000000000     0.5000000000     0.0000000000     40
   0.0000000000     0.0000000000     0.0000000000     40
   0.5000000000     0.4933333333     0.4933333333     40
   0.0000000000     0.5000000000     0.0000000000     40
   0.5000000000     0.5000000000     0.0000000000     40
   0.5000000000     0.4933333333     0.4933333333     40
```

