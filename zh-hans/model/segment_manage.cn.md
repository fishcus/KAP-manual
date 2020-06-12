## Cube 与 Segment 管理

### Cube 管理

- **访问 Cube 管理页面**

  用户可按如下步骤进入 Cube 管理界面

  1. 登录本产品 Web UI，切换进入具体项目
  2. 点击左侧导航栏的**建模**，再点击右侧**概览**-> **Cube** 标签页，查看 **Cube** 列表（如下图所示）

  ![Cube 管理页面](images/cube_segment_manage/draft_action.png)

- **Cube 状态与操作类型**

  构建的 Cube 包含4种， 可在 Cube 列表的 **状态** 列进行查看， 以及最右侧 **操作** 进行 Cube 操作管理

  - **DRAFT（草稿）**：尚未正式保存的 Cube，可以继续编辑及删除。
  
  - **DISABLED（禁用）**：已经设计好但是仍无法查询的 Cube。当 Cube 经过构建将自动转成 READY 状态后，才能查询。除了查看 Cube 描述信息之外，该状态支持的其他操作如下：
  
    - 编辑：进入 Cube 设计界面
  
    - 构建：根据分区列等条件构建对应的 Segment。
  
    - 删除：删除 Cube 及其包含的 Segment 信息。
  
    - 启用：将 Cube 转化为 READY 状态。
    
      > **注意**：如果cube不包含任何 READY 状态的segment，启用后导致部分查询结果为空，为避免影响线上生产系统，建议仅在开发阶段中使用。
  
    - 清除数据：清空 Cube 下所有 Segment 信息，清除操作将仅删除元数据信息，对应的数据文件需要通过[日常运维工具](../operation/routine_ops/routine_tool.cn.md)进行清理
  
    - 克隆：根据已有的 Cube 克隆出新的 Cube，包括维度设置，度量设置等。
  
      > **注意**：克隆仅复制 Cube 的元数据信息，该操作不包含对应的数据文件。

> **注意**：在mapr环境使用in memory构建方式构建空的segment时，此时可能出现数据大小为1Kb但是数据条目数为0的情况，这是因为mapr环境下构建的_SUCCESS文件占了1KB的大小，此时该segment应该是空的。
  
    - 验证 SQL：通过输入 SQL 语句验证，该查询是否能够被当前 Cube 回答。
  
    - 备份/导出：备份或导出 Cube 元数据至浏览器客户端或者指定的 HDFS 目录。
  
  - **READY（启用）**：设计完成且经过构建的 Cube，此时 Cube 包含的 Segment 可以用于查询。除查看 Cube 描述信息外，该状态支持的其他操作如下：
  
    - 构建：根据分区列及时间区间等条件构建对应的 Segment。
  
    - 禁用：将 READY 的 Cube 转化为 DISABLED 状态。
  
      > **注意**：当 Cube 启用后再次禁用时，可以编辑维度描述、度量描述、刷新设置及高级设置。为了保证构建后的数据一致性，当前状态无法增减维度和度量。如果您需要修改如上信息，请先清除对应的 Segment 信息再重新设计。
  
    - 克隆：根据已有的 Cube 克隆出新的 Cube，包括维度设置，度量设置等。
  
      > 注意：克隆仅复制 Cube 的元数据信息，该操作不包含对应的数据文件。
      
    - 刷新维表快照：刷新已有 Cube 下所有 Segment 的维度表快照数据。

      > 注意：仅支持 SCD 1 类型的维表刷新。
  
    - 验证 SQL：通过输入 SQL 语句验证，该查询是否能够被当前 Cube 回答。
  
    - 导出 TDS ：导出的TDS文件可以直接导入至 Tableau中，并使用已经设计好的模型和 Cube。
    
    - 备份/导出：备份或导出 Cube 元数据至浏览器客户端或者指定的 HDFS 目录。
    
  - **DESCBROKEN**（损坏）：Cube 元数据被破坏，处于异常状态。
  
    - 编辑：您可以修复处于 DESCBROKEN 状态的 Cube。不含 Segment 可以直接修复，含 Segments 请删除所有 Segments 后编辑修复。
    
    - 删除：删除 Cube 及其包含的 Segment 信息。
    
    - 备份/导出：备份或导出 Cube 元数据至浏览器客户端或者指定的 HDFS 目录。
  

### Segment 管理

Cube 数据由一个或多个 Segment 组成。因此当 Cube 构建后，会生成 Segment 数据块。Segment 的生成是以分区列（Partition Column）为依据的。

用户可通过如下步骤进入 Segment 管理界面：

1. 打开 Cube 列表， 点击 Cube 名称左侧的 **>** 箭头
2. 选择 **Segments** 标签页

![Cube Segment](images/cube_segment_manage/build_segment.png)



Segments 管理页面上，支持如下操作：

- **刷新**：重新构建该 Segment以刷新数据。

- **合并**：将多个 Segment 合并为一个新的 Segment。

  > **注意：** 
  >
  > 1. 当 Segment 不连续时也可以进行合并，合并任务会自动补全缺失部分。
  > 2. 合并 Segment 时，若被合并的 Segment 对应的维度表快照不同，将会弹出警告提示。当用户选择继续合并，可能会产生缓慢变化维处理的不一致，并会影响查询结果。关于更多缓慢变化维的信息，请参考 [缓慢变化维度](model_design/slowly_changing_dimension.cn.md)。
  > 3. 为了避免 Cube 中 Segment 过多，导致查询性能下降。我们建议在 Cube 设计时，在**刷新设置**步骤中按周或月对数据进行自动合并。
  > 4. 自动合并功能仅支持按日期/时间增量构建的 Cube，对于其他增量构建类型的 Cube，请根据您的业务情况进行自行调用 [Segment Rest API](../rest/segment_manage_api.cn.md) 进行持续的 Segment 合并。
- **删除**：删除当前 Segment。删除操作将仅删除 Segment 元数据信息，对应的数据文件需要通过[日常运维工具](../operation/routine_ops/routine_tool.cn.md)进行清理。

- **导入**：将 HDFS上的 Segment 数据文件导入至当前 Cube。
  
  > **注意**：
  >
  > 1. 若当前 Cube 与导入的 Segment 数据中包含的 Cube 元数据不一致或者数据区间存在冲突时，将无法导入。
  > 2. 导入的 Segment 数据暂时不支持进行进行合并操作。
  
- **详情**：查看当前 Segment 详情，包括存储路径，存储空间等信息。

- **导出**：可以将指定 Segment 及相关存储数据（包含 Segment 数据，字典文件，快照文件和对应的 Cube 元数据）导出至指定的 HDFS 目录。

点击正在被构建、刷新、合并的 Segment ID，可以跳转至**监控**页面，查看关联任务。

