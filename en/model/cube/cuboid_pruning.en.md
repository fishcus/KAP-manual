## Cuboid Pruning ##

Aggregation group and all its advanced settings help avoid cuboid number explosion. To achieve better Cube design, users need to understand the data model, which is hard for the junior ones. Fortunately, This product provides another simple cuboid pruning tool named *Max Dimension Combination (MDC)*. This tool limits the dimension number in a single cuboid, which means cuboids containing too many dimensions are not built in Cube Building process. It fits well in the situation where most queries only touch no more than N dimensions, N is MDC threshold that is configurable.

### Dimensions Count in Query ###

From V2.4.3, we treat a group of joint dimension or hierarchy dimension as one dimension when counting dimensions in a cuboid, and ignore mandatory dimensions. For example,

```sql
select count(*) from table group by column_mandatory, column_joint1, column_joint2, column_hierarchy1, column_hierarchy2, column_normal
```

There is one mandatory dimension, two dimensions belonging to one joint dimension, two dimensions belonging to one hierarchy dimension and one normal dimension. So we treat them as 3 dimensions in cube pruning.

### Schematic Diagram of Automatic Pruning ###

![sprouting graph](images/cuboid_mdc.en.png)

This is a sprouting graph of cuboid which has 7 dimensions and some details are hiden in order to help users understand.

When MDC = 4, the cuboid which has over 4 dimensions will be pruned, such as ABCDEF, ABCDEG, ABCDE, and ABCDF.

When MDC = 3, the cuboid which has over 4 dimensions will be pruned, such as ABCDEF, ABCDEG, ABCD, and ABCE.

Considering the performance in cube build, the base cuboid and *some cuboid* will not be pruned although their dimensions are greater than MDC. For example, cuboid ABCEF is likely to be left. Meanwhile, a group of joint dimension or hierarchy dimension and mandatory dimensions need to be considered when using the MDC tool.

### Turn it on ###

We'll introduce how to leverage the tool in this section. It locates in Dimension Optimizations section of Cube dimension design, the second step of the whole Cube design process.

![](images/cuboid_pruning_1.png)

As shown in Figure 1, the default value is 0 meaning disable MDC. To enable MDC, enter a positive number. For example, input 4 and click apply. 

![](images/cuboid_pruning_2.png)

The cuboid number is reduced from 161 to 141 in this case. It's because the cuboids containing more than 4 dimensions are ignored except for base cuboid.

### Benefit and Tradeoff ###

On one hand, MDC dimension pruning tool reduces the cuboids number and storage size significantly. On the other hand, some complex queries that cover more dimensions may hit large cuboids, in which case online calculation cannot be avoided. The too much online calculation may make query response slower. 

Like other cube optimization tools, it's a kind of tradeoff. If most queries touch fewer dimensions in your case, MDC deserves a shot.
