##自定义增量构建 Java 类开发指南

本文将介绍如何开发一个自定义增量构建 Java 类，实现自定义增量 Cube 构建。

假设样例数据中含有 *MONTH_ID* 和 *BATCH_ID* 两列，*MONTH_ID* 为 6 位整数，对应着数据更新的月份，如201201、201202。*BATCH_ID* 为 4 位整数，对应了每一月内数据更新的批次，如 1、2、3。*MONTH_ID* 与 BATCH_ID 一起构成 10  位整数，形成 Segment 区间。比如：

- [2012010001, 2012010002) 指 2012 年 1 月的第 1 批数据（不含2）。

- [2014020001, 2014020004) 指 2014 年 2 月的第 1-3 批数据（不含4）。

  > **注意：** "[" 为闭口区间，")" 为开口区间。

每次 Cube 构建时我们希望将 Segment 区间对应的数据加载进入 Cube，以下我们将基于此样例需求讲解自定义增量构建 Java 类的实现，说明如何将上面的 Segment 区间转换成数据加载过滤条件。

### 搭建开发环境

拷贝 *$KYLIN_HOME/customize/customized-incremental-build.tar.gz*，解压后目录为一个完整的样例程序。其中有 pom.xml，定义了maven 工程，将其整个导入到您的 Java IDE 中。

开发工程对 Kyligence Enterprise 有类库依赖，在工程的 lib 目录中加入 *$KYLIN_HOME/lib/kylin-job-kap-[*version*].jar* ，并将其添加到 classpath 中。

###实现自定义增量构建 Java 类

自定义增量构建 Java 类必须继承 *PartitionDesc.IPartitionConditionBuilder* 接口，并实现

*buildDateRangeCondition* 方法。在该方法中实现了输入参数 *segmentRange* 至数据筛选条件（SQL Where 语句）的映射，从而在每次构建时加入该筛选条件完成增量数据的选择与加载。

下面自定义增量构建 Java 类的模板：

```java
import org.apache.kylin.metadata.model.ISegment;
import org.apache.kylin.metadata.model.PartitionDesc;
import org.apache.kylin.metadata.model.SegmentRange;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class SampleConditionBuilder implements PartitionDesc.IPartitionConditionBuilder {

    public SampleConditionBuilder() {}

    @Override
    public String buildDateRangeCondition(PartitionDesc partitionDesc, ISegment segment, SegmentRange segmentRange) {
		...
    }
}
```

*segmentRange* 参数包含了数据范围的起始值 *start* 和截止值 *end*，其类型均为 *Long*，在具体实现自定义增量构建 Java 类之前，我们首先需要决定 start 和 end 值如何映射至源数据的列值。

在本例中，我们就可以定义 *start* 和 *end* 值在提交构建任务时必须为 10 位整数，前六位包含 *MONTH_ID*，后四位包含 *BATCH_ID*，以下是提交构建任务时的 segmentRange 的样例：

- 构建 2012 年 1 月，第 1 批次的数据

  构建任务提交的 segmentRange: [2012010001, 2012010002)

  buildDateRangeCondition 方法返回：MONTH_ID=201201 AND BATCH_ID>=1 AND BATCH_ID<2

- 构建 2012 年 2 月，第 2 批次至第 9 批次的数据

  构建任务提交的 segmentRange: [2012020002, 2012020010)

  buildDateRangeCondition 方法返回：MONTH_ID=201202 AND BATCH_ID>=2 AND BATCH_ID<10

  > **注意：** 任务提交时 segmentRange 的 *end* 值必需做开区间处理，避免连续批次间的数据重叠。

根据本文需求示例，自定义增量构建 Java 类的实现如下：

```java
import org.apache.kylin.metadata.model.ISegment;
import org.apache.kylin.metadata.model.PartitionDesc;
import org.apache.kylin.metadata.model.SegmentRange;

public class SampleConditionBuilder implements PartitionDesc.IPartitionConditionBuilder {
    
    String monthColumn;
    String batchColumn;

    // default constructor, called when no arguments is configured on the type of customized incremental build
    public SampleConditionBuilder() {
        // default column names
        this(new String[] { "MONTH_ID", "BATCH_ID" });
    }

    // called when arguments is configured
    public SampleConditionBuilder(String[] args) {
        this.monthColumn = args[0];
        this.batchColumn = args[1];
    }

    /**
     * Build filter condition on data source for a new segment.
     * 
     * @param partitionDesc     Model partition descriptor
     * @param segment           The segment object
     * @param segmentRange      The data range of the segment
     * @return a SQL where clause used to filter source records
     */
    @Override
    public String buildDateRangeCondition(PartitionDesc partitionDesc, ISegment segment, SegmentRange segmentRange) {
        // get segment range
        long startInclusive = (Long) segmentRange.start.v;
        long endExclusive = (Long) segmentRange.end.v;
        // check segmentRange validity
        if (startInclusive > endExclusive) {
            throw new IllegalArgumentException("endOffset should be greater than startOffset!");
        }

        String startStr = String.valueOf(startInclusive);
        String endStr = String.valueOf(endExclusive);

        int startMonth = Integer.parseInt(startStr.substring(0, 6));
        int startBatch = Integer.parseInt(startStr.substring(6));
        int endMonth = Integer.parseInt(endStr.substring(0, 6));
        int endBatch = Integer.parseInt(endStr.substring(6));

        // build filter condition from segment start and end
        StringBuilder builder = new StringBuilder();
        if (startMonth == endMonth) {
            builder.append(monthColumn + "=" + startMonth)
                    .append(" AND ")
                    .append(batchColumn + ">=" + startBatch)
                    .append(" AND ")
                    .append(batchColumn + "<" + endBatch);
            
        } else if (startMonth < endMonth) {
            builder.append("(")
                    .append(monthColumn + "=" + startMonth)
                    .append(" AND ")
                    .append(batchColumn + ">=" + startBatch)
                    .append(")");
            
            builder.append(" OR ");
            
            builder.append("(")
                    .append(monthColumn + "=" + endMonth)
                    .append(" AND ")
                    .append(batchColumn + "<" + endBatch)
                    .append(")");
            
            builder.append(" OR ");
            
            builder.append("(")
                    .append(monthColumn + ">" + startMonth)
                    .append(" AND ")
                    .append(monthColumn + "<" + endMonth)
                    .append(")");
    
        } else {
            throw new IllegalStateException();
        }

        // return filter condition
        return builder.toString();
    }
}
```

### 自定义增量构建 Java 类的单元测试
请参考项目中 src/test/java/SampleConditionBuilderTest.java 做单元测试。


### 自定义增量构建 Java 类的打包、部署与使用
- Maven 生成 JAR 包
  ```sh
  mvn package -DskipTests
  ```

  将在项目 target 目录下生成 customized-incremental-build-1.0-SNAPSHOT.jar 包。

- 部署自定义增量构建 JAR 包
  将上面的 JAR 放入路径 `$KYLIN_HOME/ext`，并重启 Kyligence Enterprise 生效。
  ```sh
  cp customized-incremental-build-1.0-SNAPSHOT.jar $KYLIN_HOME/ext
  $KYLIN_HOME/bin/kylin.sh stop
  $KYLIN_HOME/bin/kylin.sh start
  ```

- 创建模型和 Cube，定义自定义增量构建

  - 创建模型时，增量构建选择自定义，自定义增量构建 Java 类填写 `SampleConditionBuilder`，Java 类初始化参数空缺，保存模型即可。
  - 基于上述模型，进一步创建 Cube。
    - 特别留意：建议关闭自动 Segment 合并功能，或者根据自定义 Segment 区间的值域，谨慎地设置自动合并的区间范围。

- 自定义增量构建必需使用 Rest API 触发，例如：
  ```sh
  curl -X PUT \
    http://localhost:8080/kylin/api/cubes/cube_cus/segments/build_customized \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache' \
    -d '{
      "sourceOffsetStart": 2012020002,
      "sourceOffsetEnd": 2012020010,
      "buildType": "BUILD",
  }'
  ```

