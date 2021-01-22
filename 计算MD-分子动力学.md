# 计算分子动力学
## qe中分子动力学的计算
### 一.关于设置
`calculation='md'`表示的是 分子动力学，将电子对离子的作用看成离子感受到的势，根据势能和离子出事的速度求解离子运动的牛顿方程
`calculation='vc-md'`表示的是 改变cell的分子动力学


###  二.相关参数
#### 1.`tstress`默认`.false.` 
计算stress (如果`calculation='vc-md'`或者`calculation='vc-relax'`,该参数会自动设置为.true.)
#### 2.`tprnfor` 计算forces 
(如果`calculation='vc-md'`或者`calculation='relax'`或者`calculation='md'`,该参数会自动设置为.true.)
#### 3.`nosym`默认`.false.` 
如果对称性没有应用（.true.）,
①在输入中提供k点的列表：则按“原样”使用它：不生成对称不等价的k点，并且电荷密度不对称
②在输入中提供均匀的k点网格，扩展到整个布里渊区，而与晶体的对称性无关。如果考虑时间反演对称性，除非指定noinv=.true.，否则k与-k可视为等价处理

##### 注意事项：如果不知道确切需要使用什么，不要使用这一选项，且这一选项可能在以下情形中有用：
①在低对称大原胞中，无法提供准确对称性的k点网格
②在分子动力学模拟
③计算孤立原子

#### 4.`nosym` 字符串
可供选择有：
'atomic'  原子电荷叠加的起始势（默认：scf,relax,md）
'file'   从变量prefix和outdir指定的目录中的现有“ charge-density.xml”文件开始。对于nscf和band计算，这是默认设置，也是唯一可行的选择

#### 5.针对&IONS
如果计算`calculation='relax'`，`'md'`，`'vc-relax'`或`'vc-md'`则必需计算`calculation='scf'`的可选选项（仅使用ion_positions）
##### ion_dynamics 字符串----用于指定不同类型的离子动力学
下面是不同类型的动力学可能性与规则:
当calculation='relax'
    'bfgs' （默认）基于trust radius过程，使用BFGS拟牛顿算法进行结构弛豫
    'damp'  使用阻尼（快速最小Verlet）动力学进行结构弛豫
当calculation='md'
    'verlet' (默认)使用Verlet算法对牛顿方程进行积分
    'langevin'  离子动力学过度阻尼langevin
    'langevin-smc'   
当calculation='vc-relax'
     'bfgs' (默认) 使用bfgs准牛顿算法
     'damp' 使用阻尼（贝曼）动力学进行结构弛豫
当calculation='vc-md'
      'beeman' （默认）使用贝曼动力学进行结构弛豫
      
##### ion_temperature 字符串，默认：'not_controlled'
可供选择有：
'rescaling' 通过速度缩放（第一种方法）控制离子温度，请参见参数tempw，tolp和nraise（仅适用于VC-MD）。
这种重新缩放方法是VC-MD当前唯一实现的方法
'rescale-v' 通过速度缩放控制离子温度
'rescale-T'
'reduce-T'
'berendsen' 使用“软”速度控制离子温度
'andersen' 使用Andersen恒温器控制离子温度
'svr' 使用参数tempw和nraise使用随机速度重新缩放控制离子温度
'initial' 将离子速度初始化为温度温度，然后继续不受控制
'not_controlled' 默认，离子温度不受控制

##### tempw 实数，默认：300D.0
对于大多数恒温器MD运行开始时的温度


#### 6.针对&CELL

###  三.分子动力学
```
&CONTROL
calculation='md'
nstep=68
dt=4
/
&IONS
!tempw起始温度
tempw=0.1
!系综，verlet(NVE)
ion_dynamics='verlet'
/
&CELL
/
```
`dt`实数，默认20.D0 
### 一般默认20au，精确至少用10au
分子动力学的时间步长（以Rydberg原子单位表示）（1 a.u. = 4.8378 * 10 ^ -17 s：请注意，CP代码使用Hartree原子单位，仅为后者的一半！）

`nstep` 整数，默认：
当calculation='scf','nscf','bands' 默认值为1
当calculation为其他，默认值为50
### nstep 在TDPW中可以续算，不用担心
如果看电子吸收谱，分辨率为0.1eV时， nstep*dt > 40fs. 看THz光谱 nstep * dt > 3ps

###  四.分子动力学系综的选择---NVE,NVT,NPT
@https://www.charmm.org/ubbthreads/ubbthreads.php?ubb=showflat&Number=11071
@https://en.wikipedia.org/wiki/Molecular_dynamics#Microcanonical_ensemble_(NVE)


上述三者表示正则统计系综，暗示着变量守恒或者变化。N表示粒子数守恒
###### NVE---微正则系综
对应无热交换的过程，其分子动力学轨迹可以看作是势能和动能的交换，总能量是守恒的
粒子数（N）,体积（V）,能量（E）以及动能（KE）与势能(PE)之和守恒 :constant number (N), volume (V), and energy (E); the sum of kinetic (KE) and potential energy (PE) is conserved, T and P are unregulated 
###### NVT---正则系综
也称为恒温分子动力学（CTMD）。在NVT中，吸热和放热过程的能量与恒温器进行交换。粒子数（N）,体积（V），温度（T）守恒,通过一个热容器向守恒的哈密顿量中加入一个自由度，P不受约束
constant number (N), volume (V), and temperature (T); T is regulated via a thermostat, which typically adds a degree of freedom to the conserved Hamiltonian;  P is unregulated
###### NPT---除了恒温器外，还需要一个恒压器。
烧瓶在环境温度和压力下均可打开，最适合实验室条件同上
as for NVT, but pressure (P) is regulated
###### 注意事项：
####### NVE完全孤立，体系类似平衡位置震荡
####### 你可以不开SOC，不开自旋跑MD， 然后把结构提出来做scf计算，这样即节约计算量又才样丰富
####### 跑MD的精度，k点之类的都可以降低，只是为了采样构型，不用算的那么精确后期算磁性时需要精确
####### 可以看下体系的能量变化，取能量低的点结构
