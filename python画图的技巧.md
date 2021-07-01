# 一.legend的设置
@https://www.cnblogs.com/shanger/p/13021463.html
```
legend(loc  # Location code string, or tuple (see below).
            #  图例所有figure位置。　　labels  # 标签名称。
    prop    # the font property.
            #  字体参数
    fontsize  # the font size (used only if prop is not specified).
              #  字号大小。
    markerscale  # the relative size of legend markers vs.
                 # original  图例标记与原始标记的相对大小
    markerfirst  # If True (default), marker is to left of the label.
                 #  如果为True，则图例标记位于图例标签的左侧
    numpoints  # the number of points in the legend for line.
               #  为线条图图例条目创建的标记点数
    scatterpoints  # the number of points in the legend for scatter plot.
                　　#  为散点图图例条目创建的标记点数
    scatteryoffsets    # a list of yoffsets for scatter symbols in legend.
               　　　　 #  为散点图图例条目创建的标记的垂直偏移量
    frameon    # If True, draw the legend on a patch (frame).
               #  控制是否应在图例周围绘制框架
    fancybox    # If True, draw the frame with a round fancybox.
                #  控制是否应在构成图例背景的FancyBboxPatch周围启用圆边
    shadow    # If True, draw a shadow behind legend.
                #  控制是否在图例后面画一个阴影
    framealpha  # Transparency of the frame.
                #  控制图例框架的 Alpha 透明度
    edgecolor    # Frame edgecolor.
    facecolor    # Frame facecolor.
    ncol    # number of columns.
            #  设置图例分为n列展示
    borderpad    # the fractional whitespace inside the legend border.
                # 图例边框的内边距
    labelspacing    # the vertical space between the legend entries.
               　　 #  图例条目之间的垂直间距
    handlelength    # the length of the legend handles.
                　　#   图例句柄的长度
    handleheight    # the height of the legend handles.
               　　 #   图例句柄的高度
    handletextpad    # the pad between the legend handle and text.
               　　   #   图例句柄和文本之间的间距
    borderaxespad    # the pad between the axes and legend border.
               　　   #  轴与图例边框之间的距离
    columnspacing    # the spacing between columns.
               　　   #  列间距
    title    # the legend title.
             #  图例标题
    bbox_to_anchor    # the bbox that the legend will be anchored.
                　　　 #  指定图例在轴的位置
    bbox_transform)    # the transform for the bbox.
                　　　 # transAxes if None.
```
# 二.坐标轴粗细的设置
@https://blog.csdn.net/weixin_38244609/article/details/83591601
句法：
```
ax.spines[‘dd’].set_linewidth(lw);
```
dd：对应哪个轴，lw：坐标轴的线宽
例子：
```
ax=plt.gca();#获得坐标轴的句柄
ax.spines['bottom'].set_linewidth(2);###设置底部坐标轴的粗细
ax.spines['left'].set_linewidth(2);####设置左边坐标轴的粗细
ax.spines['right'].set_linewidth(2);###设置右边坐标轴的粗细
ax.spines['top'].set_linewidth(2);####设置上部坐标轴的粗细
```
# 三.python设置坐标轴刻度值字体大小，刻度值范围，标签大小
@https://blog.csdn.net/qq_41181787/article/details/105264825
## 1.刻度设置
```
#刻度设置及刻度值字体大小（分别设置x轴和y轴）
y_tick = np.linspace(0,20,5)
plt.yticks(y_tick,fontsize=20,color='#000000')
plt.xticks([])  #不显示x轴刻度值

#刻度值字体大小设置（x轴和y轴同时设置）
plt.tick_params(labelsize=11)

#x轴刻度旋转
ax.set_xticklabels(ax.get_xticklabels(),rotation=90)

#刻度值字体设置
labels = ax.get_xticklabels()+ ax.get_yticklabels()
[label.set_fontname('Verdana') for label in labels]
```
## 2.子图相关
```
#对plt.plot而言，如果直接创建plt.figure(figsize=(3,3)),并用plt.plot(x,y)作图，此时不能用上面的方法设置刻度值字体，可用下面的方法
#子图字体设置
fig,ax = plt.subplots(figsize=(3,3))
plt.plot(x,y)
labels = ax.get_xticklabels()+ax.get_yticklabels()
[label.set_fontname('Verdana') for label in labels]
```
## 3.设置子图之间的间距
```
plt.subplots_adjust(left=None, bottom=None, right=None, top=None,
                wspace=None, hspace=None)
```
## 4.标签设置
```
#标签设置字体大小设置
plt.xlabel('x',fontsize=11)
plt.ylabel('y',fontsize=11)

#标签字体设置
font1 = {'family':'Verdana','weight':'normal','size':23,'color':'#000000'}
plt.ylabel('ccc',font1)

#不显示标签
plt.xlabel('')
plt.ylabel('')
```
## 5.删除右边框和上边框
```
sns.despine()
```
