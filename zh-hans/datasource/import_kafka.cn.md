## 导入 Kafka 数据源

本节将介绍如何导入 Kafka 数据源，以及如何将 Kafka 消息流解析为表。

### 前提条件

请联系您的 Hadoop 管理员，确保您的环境中已安装 **Kafka v2.10-0.10.1.0**及以上版本。

### 部署 Kafka Broker

以下步骤将介绍如何将 Kafka Broker 部署到 Kyligence Enterprise 启动节点，已经安装过 Kafka Broker 的用户可以跳过该步骤。

> **提示：**
> 1. Kafka Broker 无需与 Kyligence Enterprise 部署在同一个节点上。
> 2. 如果部署 Kyligence Enterprise 的节点上没有部署 Kafka Broker，建议拷贝其他已部署 Kafka 节点的相同版本的 Kafka 二进制包并解压在本产品启动节点上的任意路径（如`/usr/local/kafka_2.10-0.10.1.0`），并设置 `KAFKA_HOME` 指向该路径。确保 `$KAFKA_HOME/libs/` 目录下有 Kafka 的客户端有关的 Jar 包。

1. 下载 Kafka 安装包并解压。
   ```sh
   curl -s https://archive.apache.org/dist/kafka/0.10.1.0/kafka_2.10-0.10.1.0.tgz | tar -xz -C /usr/local/
   ```
2. 指定 `KAFKA_HOME` 环境变量。
   ```sh
   export KAFKA_HOME=/usr/local/kafka_2.10-0.10.1.0
   ```
3. 启动 Kafka Broker。
   ```sh
   $KAFKA_HOME/bin/kafka-server-start.sh config/server.properties &
   ```


### 创建 Kafka Topic 并模拟流数据

以下步骤将介绍如何创建 Kafka Topic 并模拟流数据，如果已经有了 Kafka Topic 的用户可以跳过这个步骤。

假设 Kafka Broker 运行在 127.0.0.1:9092，ZooKeeper 运行在 127.0.0.1:2181。

1. 创建一个名为 `kylindemo` 的 Kafka Topic。
   ```sh
   $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper 127.0.0.1:2181 --replication-factor 1 --partitions 3 --topic kylindemo
   ```

2. 启动 Kafka Producer。
   本产品提供了一个简单的 Producer 工具用于产生消息流，持续往 Kafka Topic 中导入数据。

   ```sh
   $KYLIN_HOME/bin/kylin.sh org.apache.kylin.source.kafka.util.KafkaSampleProducer --topic kylindemo --broker 127.0.0.1:9092
   ```
   > **提示：**
   > 1. 这个工具每秒会向 Kafka 中发送 100 条消息。
   > 2. 在模拟流数据时，请保持本程序持续运行。

3. 同时，您可以使用 Kafka 自带的 Consumer 来检查消息是否成功导入。
   ```sh
   $KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic kylindemo --from-beginning
   ```

### 从流式数据中解析并定义数据表

本产品支持将 Kafka 消息流抽象为数据表，并通过构建数据实现对消息流的近实时处理。

1. 在 WEB UI 界面新建一个项目用于导入流式数据。
2. 在**建模**-->**数据源**页面，点击数据源选择数据源为 Kafka，点击**下一步**。
   ![选择数据源](images/kafka_import.cn.png)
3. 在**设置 Kafka 主题**页面中输入 Broker 集群信息，包括主机的实际 IP 地址和端口号，确认后点击  √。
   ![输入 Broker 集群信息](images/kafka_setting.png)
4. 点击 **获取该集群信息** -> **{Kafka Topic 名称}**（如：`kylindemo`），消息流的采样数据会出现在右边文本框中，点击 **Convert**。
   ![获取 Broker 集群信息](images/kafka_info.png)
5. 为流式数据源定义一个表名，这张数据表将作为后续创建模型和查询的事实表。本例将表命名为 *KAFKA_TABLE_1*。
   ![为流式数据源定义表名](images/kafka_name.png)
6. 检查表结构中的列和对应的列类型是否正确。
  **注意：** 
  1. 确保至少有一列的列类型被选择为 **timestamp**。
  2. 本产品会自动生成 7 个不同粒度的时间列，包括 *year_start*、*quarter_start*、*month_start*、*week_start*、*day_start*、*hour_start*、*minute_start*，**请务必保证 minute_start 的勾选**，保证后续模型设计、Cube 构建等过程的顺利进行，其他维度可以根据您实际业务场景需要进行勾选。
  ![至少一列为 timestamp](images/kafka_check_timestamp.png)
7. 设置解析器
   ![设置解析器](images/kafka_parser.png)
   - 解析器名称：默认为 `org.apache.kylin.source.kafka.TimedJsonStreamParser`，支持自定义解析器；
   - 时间戳字段名称：必须指定一列时间字段用于解析，本例选择了 *order_time*。
   - 解析器属性：为解析器定义更多属性，请参照输入框中提示的属性格式指定 **tsParser** 和 **tsPattern**。
     - tsParser：指时间戳解析器，将 `tsColName` 的数值解析成时间戳。
       本产品提供有两种内置解析器：
       - 默认的 `org.apache.kylin.source.kafka.DefaultTimeParser`，将 Long 型的 Unix 时间解析为时间戳。默认的解析器将 Unix 时间解析为时间区间为 GMT+0 的时间，如 1549008564973 将被解析为 2019-02-01 08:09。
       - `org.apache.kylin.source.kafka.DateTimeParser`，将根据给定的 `tsPattern`，将 String 类型的时间表达式解析成时间戳；如果没有指定 `tsPattern`，默认使用 `yyyy-MM-dd HH:mm:ss`。
   - tsPattern：指时间戳样式，供 tsParser 使用。
8. 点击**提交**。至此，您完成了将 Kafka 输出的消息流定义为数据表。
