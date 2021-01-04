# 一 . 实现结构弛豫收敛的原则与方法
## 1.结构弛豫收敛标准：
1） 相邻两个离子步总能的变化小于`etot_conv_thr`(1.0D-4)
2)  各个离子之间受力小于 `forc_conv_thr`(1.0D-3)
3)  vc-relax还要求cell受到压强`press_conv_thr`(0.5)

## 2.relax过程的报错：
如果relax计算的前几步电荷正常收敛，而进行到某一步报错，即结构优化不收敛，常用方法有：
法一：
对于原胞做vc-relax得到晶格常数，用该结果建超胞；
对于超胞优化ion，即`calculation=relax`
