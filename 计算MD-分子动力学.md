# 计算分子动力学
## qe中分子动力学的计算
### 一.关于设置
`calculation='md'`表示的是 分子动力学，将电子对离子的作用看成离子感受到的势，根据势能和离子出事的速度求解离子运动的牛顿方程
`calculation='vc-md'`表示的是 改变cell的分子动力学


###  二.相关参数
#### `tstress`默认`.false.` 
计算stress (如果`calculation='vc-md'`或者`calculation='vc-relax'`,该参数会自动设置为.true.)
#### `tprnfor` 计算forces 
(如果`calculation='vc-md'`或者`calculation='relax'`或者`calculation='md'`,该参数会自动设置为.true.)
#### `nosym`默认`.false.` 
如果对称性没有应用（.true.）,
①在输入中提供k点的列表：则按“原样”使用它：不生成对称不等价的k点，并且电荷密度不对称
②在输入中提供均匀的k点网格，扩展到整个布里渊区，而与晶体的对称性无关。如果考虑时间反演对称性，除非指定noinv=.true.，否则k与-k可视为等价处理

##### 注意事项：如果不知道确切需要使用什么，不要使用这一选项，且这一选项可能在以下情形中有用：
①在低对称大原胞中，无法提供准确对称性的k点网格
②在分子动力学模拟
③计算孤立原子

#### `nosym` 字符串
可供选择有：
'atomic'  原子电荷叠加的起始势（默认：scf,relax,md）
'file'   从变量prefix和outdir指定的目录中的现有“ charge-density.xml”文件开始。对于nscf和band计算，这是默认设置，也是唯一可行的选择

####
