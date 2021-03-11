# 关于SOC计算的相关事项
## 1）赝势的选择：选择带有rel的赝势

## 2）对称性 关于对称性，有关的参数包括

### `nosym`
LOGICAL
Default:	.FALSE.
这一参数是指对称性默认情况下是考虑了的，我们计算的时候需要打破对称性，即把选项设置成.true.使得k与-k不等价
### `noinv` 
Default:	.FALSE.

## 3）&SYSTEM里的参数

### `lspinorb`
LOGICAL
if .TRUE. the noncollinear code can use a pseudopotential with spin-orbit.
将lspinorb设置成true，非线性过程开始计算SOC的情况

### `noncolin`
