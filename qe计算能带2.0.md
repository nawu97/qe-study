# 计算MoS2的能带
基本步骤： 弛豫计算==>自洽计算==>非自洽计算==>能带计算


## 自洽计算
关于MoS2的自洽计算，输入文件如下：
```
&CONTROL
 calculation='scf',
 restart_mode='from_scratch',
 prefix='MoS2_scf',
 pseudo_dir='./pseudo',
 outdir='./tmp',
 forc_conv_thr=1.0d-3
/
&SYSTEM
  ibrav = 0
  A=3.19032
  nat = 3
  ntyp = 2
  ecutwfc=70
  nbnd=30
  starting_magnetization(1)=0
  starting_magnetization(2)=0
  lspinorb=.TRUE.
  nosym=.TRUE. 
  noinv = .True.
  noncolin=.TRUE.
/
&ELECTRONS
   conv_thr=1.0d-6
/
&IONS
   ion_dynamics='bfgs'
/
&CELL
   cell_dynamics='bfgs',
   press=0.0d0,
   press_conv_thr=0.5d0
/
CELL_PARAMETERS {alat}
  1.000000000000000   0.000000000000000   0.000000000000000
 -0.500000000000000   0.866025403784439   0.000000000000000
  0.000000000000000   0.000000000000000   4.663803021124211
ATOMIC_SPECIES
   Mo   95.96000  Mo.rel-pz-spn-kjpaw_psl.0.2.UPF
   S    32.06750  S.rel-pz-n-kjpaw_psl.0.1.UPF
ATOMIC_POSITIONS {crystal}
Mo   0.666666666666667   0.333333333333333   0.750000000000000
 S   0.333333333333333   0.666666666666667   0.855174000000000
 S   0.333333333333333   0.666666666666667   0.644826000000000
K_POINTS {automatic}
10 10 1 0 0 0
```
### 注意事项：注意选择正确的晶体结构描述方式，如ibrav=0（可用cif2cell生成，有的时候这个软件不太好使需要反复调整验证，最好结合vesta来实际计算一次）




## 非自洽计算
具体代码：
```
&CONTROL
 calculation='nscf',
 restart_mode='restart',
 prefix='MoS2_scf',
 pseudo_dir='./pseudo',
 outdir='./tmp',
 forc_conv_thr=1.0d-3
/
&SYSTEM
  ibrav = 0
  A =    3.19032
  nat = 3
  ntyp = 2
  occupations='smearing'
  smearing='gauss', 
  degauss=1.0d-3,
  ecutwfc=70
  nbnd=30
  starting_magnetization(1)=0
  starting_magnetization(2)=0
  lspinorb=.TRUE.
  nosym=.TRUE.
  noinv=.TRUE. 
  noncolin=.TRUE.
/
&ELECTRONS
   conv_thr=1.0d-6
/
&IONS
   ion_dynamics='bfgs'
/
&CELL
   cell_dynamics='bfgs',
   press=0.0d0,
   press_conv_thr=0.5d0
/
CELL_PARAMETERS {alat}
  1.000000000000000   0.000000000000000   0.000000000000000
 -0.500000000000000   0.866025403784439   0.000000000000000
  0.000000000000000   0.000000000000000   4.663803021124211
ATOMIC_SPECIES
   Mo   95.96000  Mo.rel-pz-spn-kjpaw_psl.0.2.UPF
   S    32.06750  S.rel-pz-n-kjpaw_psl.0.1.UPF
ATOMIC_POSITIONS {crystal}
Mo   0.666666666666667   0.333333333333333   0.750000000000000
 S   0.333333333333333   0.666666666666667   0.855174000000000
 S   0.333333333333333   0.666666666666667   0.644826000000000
K_POINTS {automatic}
50 50 1 0 0 0
```

### 注意事项：非自洽计算能带时，k点数目需要适当增多，这样计算的才会准确，在MoS2中已经达到50 50 1


## 能带计算
在非自洽计算的基础上，进行能带计算
```
&CONTROL
 calculation='bands',
 restart_mode='from_scratch',
 prefix='MoS2_scf',
 pseudo_dir='./pseudo',
 outdir='./tmp',
 forc_conv_thr=1.0d-3
/
&SYSTEM
  ibrav = 0
  A =    3.19032
  nat = 3
  ntyp = 2
  occupations='smearing'
  smearing='gauss', 
  degauss=1.0d-3,
  ecutwfc=70
  nbnd=30
  starting_magnetization(1)=0
  starting_magnetization(2)=0
  lspinorb=.TRUE.
  nosym=.TRUE.
  noinv=.TRUE. 
  noncolin=.TRUE.
/
&ELECTRONS
   conv_thr=1.0d-6
/
&IONS
   ion_dynamics='bfgs'
/
&CELL
   cell_dynamics='bfgs',
   press=0.0d0,
   press_conv_thr=0.5d0
/
CELL_PARAMETERS {alat}
  1.000000000000000   0.000000000000000   0.000000000000000
 -0.500000000000000   0.866025403784439   0.000000000000000
  0.000000000000000   0.000000000000000   4.663803021124211
ATOMIC_SPECIES
   Mo   95.96000  Mo.rel-pz-spn-kjpaw_psl.0.2.UPF
   S    32.06750  S.rel-pz-n-kjpaw_psl.0.1.UPF
ATOMIC_POSITIONS {crystal}
Mo   0.666666666666667   0.333333333333333   0.750000000000000
 S   0.333333333333333   0.666666666666667   0.855174000000000
 S   0.333333333333333   0.666666666666667   0.644826000000000
K_POINTS {crystal_b}
4
 0.0000000000	0.0000000000	0.0000000000  50
 0.5000000000	0.0000000000	0.0000000000  50
 0.3333333333	0.3333333333	0.0000000000  50
 0.0000000000	0.0000000000	0.0000000000  1
```
[MoS2-SOC.zip](https://github.com/nawu97/qe-study/files/6120087/MoS2-SOC.zip)
### 注意事项：
一定要注意描述高对称点路径时，一定要选择{crystal_b}这是画能带图采用晶体的相对坐标来描述的
