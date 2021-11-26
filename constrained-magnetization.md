# 关于constrained-magnetization的一些问题
涉及到的参数：
```
starting_magnetization(i), i=1,ntyp
angle1(i) , i=1,ntyp
angle2(i),i=1,ntyp
constrained_magnetization	CHARACTER
```
## 说明：
### `starting_magnetization(i), i=1,ntyp`
指定一个原子上的磁矩，从1（up）到-1（down），如果不设置的话是0，这会算不出来磁矩
-1的时候应该是自旋极化的时候（nspin=2）
### `angle1(i) , i=1,ntyp`
指定初始磁矩与z方向的夹角
### `angle2(i),i=1,ntyp`
指定初始磁矩在x-y平面的投影与x方向的夹角
### `constrained_magnetization	CHARACTER`常用在非共线的计算中
### `fixed_magnetization(i), i=1,3	REAL `
### 'fixed_magnetization(i), i=1,3	REAL' 
当constrained_magnetization='total'总磁矩的各个分量固定
### `starting_spin_angle	`
选择有：
```
'none' #默认
'total' #在总能中添加惩罚函数约束总磁矩
'atomic' #在初始磁矩中添加约束函数约束原子磁矩  #如果是该选项，starting——magnetization=1不要改变了在变化
'total direction' #约束总磁矩与z轴之间的夹角(theta = fixed_magnetization(3))
'atomic direction' #并非所有原子磁矩的成分被约束，只是angle1被约束

```
