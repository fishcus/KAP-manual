## Cuboid 剪枝

聚合组以及其他的高级优化功能很好得解决了Cuboid数量爆炸问题，但为了达到优化效果用户需要对数据模型有一定了解，这对于初级用户有一定使用难度。这一章将介绍一种简单的Cuboid剪枝工具——基于最大维度组合数的Cuboid剪枝（MDC）。这个剪枝方法能够避免生成大的Cuboid（包含dimension数目过多的Cuboid），从而减少生成Cube的开销。该剪枝方法适用的场景为大多数查询语句访问的维度不多于N的情况，这里的N是可以配置的MDC参数。

### 查询维度的计算方法 ###

计算cuboid中维度数的方法（产品 V2.4.3版本以上），，我们在Cuboid剪枝中将同在一个联合维度组的维度当做一个整体，即为一个维度；同理一个层级维度组也当做一个维度，而将必要维度在cuboid计算中，不算做维度。如下例所示：

```sql
select count(*) from table group by column_mandatory, column_joint1, column_joint2, column_hierarchy1, column_hierarchy2, column_normal
```

查询涉及到一个必要维度，属于一个联合维度组的两个维度，属于一个层级维度组的两个维度及一个普通维度。根据上述计算cuboid维度的方法，该查询涉及到3个维度的cuboid。

### 自动剪枝原理图 ###

![Cuboid生成图](images/cuboid_mdc.cn.png)

如上图所示，该图为一个维度为7时的Cuboid生成图，为了方便理解剪枝功能，该生成图部分内容进行了省略。

当MDC=4时，包含多于4个维度的Cuboid会被剪裁掉，如：ABCDEF，ABCDEG，ABCDE，ABCDF等。

当MDC=3时，包含多于3个维度的Cuboid会被剪裁掉，如：ABCDEF，ABCDEG，ABCD，ABCE等。

考虑到Cube构建过程中性能问题，Base Cuboid和一些Cuboid不会被剪裁掉即使包含维度大于当前MCD的值，如当MDC=4时，ABCEF可能不会被剪裁掉。同时根据上一节关于查询维度计算方法，当一个Cuboid中含有必要维度，联合维度组和层级维度组时，这两个维度组均算做一个维度，必要维度不算做维度。因此在使用自动剪枝功能时需要考虑到当含有以上维度组或者必要维度时，Cuboid的实际所含维度数。

### 功能开启 ###

这一小节将介绍如何开启该剪枝工具。

该剪枝工具位于Cube维度设计页的维度优化中，如下图所示。默认值为0，意思为关闭MDC剪枝。在输入框中输入一个正整数再点击Apply即可开启MDC剪枝功能。该正整数为一个Cuboid能够包含的最多的维度数。

![](images/cuboid_pruning_1.png)

该例子中维度数目从161下降为141，除了Base Cuboid，包含多余4个维度的Cuboid都被剪裁掉了。

![](images/cuboid_pruning_2.png)



### 注意事项 ###

一方面该剪枝方法能够显著减少Cube中包含的Cuboid数目，另一方面一些需要访问许多维度的复杂查询则会命中较大的Cuboid，造成大量的在线计算，最终导致查询速度变慢。和其他的剪枝方法一样，该方法是一种数据模型的妥协和权衡，要在存储空间和查询速度间进行取舍。当多数查询访问的维度数目不多时，该方法能起到显著的作用。
