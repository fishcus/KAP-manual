## Slowly Changing Dimension

In most multi-dimensional OLAP scenarios, lookup table might change unpredictably, rather than according to a regular schedule. For example product category of one specific product might get changed in product table, or segmentation of some customers might be changed in customer table. As product category or customer segmentation are modeled as dimensions in a cube, they are so called **Slowly Changing Dimension**, or SCD in short.

Dealing with this issue involves SCD management methodologies referred to as Type 0 through 6. But the most commonly seen are **Type 1** and **Type 2**:

- Type 1: overwrite. This methodology overwrites old with new data, and therefore does not track historical data. This is also called "latest status".
- Type 2: add new row. This method tracks historical data by creating multiple records for a given natural key in the dimensional tables with separate surrogate keys and/or different version numbers. Unlimited history is preserved for each insert. This is also called "historical truth".

In Kyligence Enterprise, **SCD Type 2 is the default**, no matter it's normal dimension or derived dimension. During query time, we always get the historical truth of all dimensions when they were built into cube. Below screen-shot illustrates the basics:

![Kyligence SCD Type 2](./images/model_SCD2_en.png)

For normal dimensions, Kyligence Enterprise will add it into the rowkey and built into cube segment; For derived dimension, we will create snapshot tables to store dimension values and these snapshots are linked with the corresponding segments. During query execution, Kyligence Enterprise will join all necessary segments with their related snapshot tables to get the result.



### Enable SCD Type 1

After enabling snapshot for a lookup table, Kyligence Enterprise supports defining derived dimensions based on this lookup table. For derived dimension, Kyligence Enterprise will create snapshot table to store its values, instead of directly building it into cube segment. 

Kyligence Enterprise supports defining SCD Types for only derived dimensions based on snapshot enabled lookup tables. You can switch to **SCD Type 1** in column **SCD Type for Derived Dimensions** when you edit a model as shown below:

![Set SCD Type](./images/model_SCD_setting_en.png)



For a lookup table with snapshot enabled and **SCD Type 1** selected，Kyligence Enterprise will preserve **only the latest version** of that lookup table snapshot. All segments will point to this snapshot for latest values of all derived dimensions defined on this lookup table. During building a cube segment, snapshot will be updated with only "insert" and "update" operations, so that this snapshot will have all dimension values. For queries on derived dimension of that lookup table, Kyligence Enterprise will join all necessary segments with the latest snapshot for getting the result. 

![Kyligence SCD Type 1](./images/model_SCD1_en.png)



### Assumption and Limitation of SCD Type 1

- SCD Type 1 is only effective on **leaf lookup table** and on **derived dimensions**.

  Leaf lookup tables are the leaf nodes in a join tree rooted from fact table. For example:

  ```sql
  F inner join A on F.aid=A.id      --      F --- A -- B
    inner join B on A.bid=B.id      --         |- C
    inner join C on F.cid=C.id
  ```

  Here, table B and C are leaf lookup tables, while table A is not leaf, as it sitting between F and B.

  Non-leaf lookup tables are not easy to change because they have contributed to join pre-calculation that happened during cube build. The cube segment data, which is the contributed result, can only be updated by refreshing cube segment.

  For similar reason, normal dimensions are stored in segment data as well, thus must be updated by refreshing cube segment.

- The primary key (PK) of SCD Type 1 lookup table **must be incremental only**.

  The stability of PK is key to the correctness of join result. Kyligence Enterprise assumes PK of SCD Type table can only increase, and no PK will ever be removed from the table.

  If a PK is removed from a SCD Type 1 lookup table, the whole join must be re-calculated and that can only be done through refreshing cube segment. Updating only the lookup table snapshot without refreshing old segment will lead to unexpected query result.