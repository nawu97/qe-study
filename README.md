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
