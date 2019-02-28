## Model Design Basics

### Introduction
Data model is a star schema or snowflake schema model based on multi-dimensional OLAP theory. Data model is the basis in Kyligence Enterpries and cubes can be created based on data models.

In this section, we take Kyligence Enterprise built-in dataset as an example. There are 1 fact table and 6 lookup tables in the data model, connected by foreign keys. Not all columns in the tables are required for analysis, so we only include necessary fields into our data model. Then we set these columns as dimensions or measures according to analysis scenarios. 

Typically data model design includes:

- Define a fact table and multiple dimension tables
- Define dimensions and measures
- Define how fact table and dimension tables are joined





### Start Model Design

Open Kyligence Enterprise Web UI, select project *learn_kylin* in project list in upper left corner and click **Studio** in the navigation bar on the left, then select **Model** tab.

![Create model](images/model_design_model_list.png)



### Create a New Model

1. Click **+ Model** button and input the new model name.
2. Click **Submit** and enter model desinger page.

Note a new model can only be saved when
- at least one fact table is selected.
- at least one dimension column is specified.




###Edit a Model

In **Model** tab, click icon **Edit** on one specific model and start to edit a model.



### Design a Data Model

In model designer page, you can define fact table and dimension table via drag and drop from source tables in the left panel.

**Step 1. Define Fact Table**

1. From the source table list in the left, you can directly drag source tables to the canvas of model designer (in the center of page). Here we drag  table *KYLIN_SALES*  to the canvas.
2. Click **Setting** icon on the top right corner of *KYLIN_SALES*, select table type as **Fact Table**.



**Step 2. Define Dimension Table**

1. Drag following lookup tables into the canvas: *KYLIN_CAL_DT*, *KYLIN_CATEGORY_GROUPINGS*, *KYLIN_ACCOUNT*, *KYLIN_COUNTRY*. 

2. Drag *KYLIN_ACCOUNT* twice and change their names to *SELLER_ACCOUNT* and *BUYER_ACCOUNT* respectively, and drag *KYLIN_COUNTRY* twice and change their names to *SELLER_COUNTRY* and *BUYER_COUNTRY* respectively.

   > **Note**: For some scenarios, one source table might be referenced as dimension table multiple times in one single data model. Kyligence support this scenario via renaming the table name in data model.

3. Click **Setting** icon on the top right corner of each table, select table type as **Dimension Table**.

   ![Set fact table and lookup table](images/model_design_tables.png)



**Step 3. Set Dimensions and Measures**

You can specify either one single column or multiple columns as dimensions or measures. Also you can use auto suggestion by the system and make modifications if necessary. 

1. Click **DM** icon on top left of the table, you can open/close editing mode of specifying dimensions and measures.
2. In editing mode, click the icons in the toolbar to specify dimension or measure.
   - **D**: Dimension
   - **M**: Mesure
   - **— **: Disabled
   - **A**: Auto Suggestion
3. In this example, we specify the dimensions and measures suggested by the system. Check checkbox to enable select all in the toolbar and click icon **A**.

![Set dimension and measure](images/model_design_tables_a.png)



**Step 4. Set Table Joins**

Drag one dimension in fact table and drop it to the corresponding lookup table can setup join condition between tables. For instance, to set up a join condition as `KYLIN_SALES Inner Join KYLIN_CAL_DT on KYLIN_SALES.PART_DT = KYLIN_CAL_DT.CAL_DT`, you can drag *PART_DT* from *KYLIN_SALES* to the table *KYLIN_CAL_DT*, then set up the join condition in the pop up shown as below.

![Add join condition](images/model_design_join.png)

Set up the following join conditions:

1. KYLIN_SALES *Inner Join* KYLIN\_CAL\_DT 
Join Condition：

   **DEFAULT.KYLIN\_SALES.PART_DT = DEFAULT.KYLIN\_CAL\_DT.CAL\_DT**

2. KYLIN_SALES **Inner Join** KYLIN\_CATEGORY_GROUPINGS 
Join Condition: 

   *KYLIN_SALES.LEAF_CATEG_ID* = *KYLIN\_CATEGORY\_GROUPINGS.LEAF_CATEG_ID*

   *KYLIN_SALES.LSTG_SITE_ID* = *KYLIN\_CATEGORY\_GROUPINGS.SITE_ID* 

3. KYLIN_SALES **Inner Join** BUYER_ACCOUNT (alias of KYLIN_ACCOUNT)
Join Condition: 

   *KYLIN_SALES.BUYER_ID* = *BUYER_ACCOUNT.ACCOUNT_ID* 

4. KYLIN_SALES **Inner Join** SELLER_ACCOUNT (alias of KYLIN_ACCOUNT) 
Join Condition: 

   *KYLIN_SALES.SELLER_ID* = *SELLER_ACCOUNT.ACCOUNT_ID* 

5. BUYER_ACCOUNT (alias of KYLIN_ACCOUNT) **Inner Join** BUYER_COUNTRY (alias of KYLIN\_COUNTRY) 
Join Condition: 

   *BUYER_ACCOUNT.ACCOUNT_COUNTRY* = *BUYER_COUNTRY.COUNTRY* 

6. SELLER_ACCOUNT (alias of KYLIN_ACCOUNT) **Inner Join** SELLER_COUNTRY (alias of KYLIN\_COUNTRY)
Join Condition: 

   *SELLER_ACCOUNT.ACCOUNT_COUNTRY* = *SELLER_COUNTRY.COUNTRY*

The result is shown as below. If you click **inner** icon on the connnection lines, it will show you details of the join.

![Connected tables](images/model_design_tables_joined.png)

> **Note**: When you design a data model, you can use computed column to define additional columns calculated based on existing columns. This can acheive more data model flexibility as well as some data wrangling functionalities.  For more details, please refer to [Computed Column](computed_column/README.md).



**Step 5. Save Model**

Click **Save** button, and then a pop-up window appears.

![Save model](images/model_design_save_en.png)

1. Incremental Data Loading

   Incremental data loading defines how the data will be refreshed into cube based on this model. You can set full load to refresh all data in the cube, or you can set following incremental data loading types:

   - By Date/Time
   - By File (Beta)
   - Customize (Beta)
   - Streaming

   > **Note:** For more details about customizing incremental data loading, please refer to [Customize Build](../../model/cube_build/customize_build.en.md).

   In our example,  *KYLIN_SALES* has a column *PART_DT* which records when the data is added. So we can select *By Date/Time* here and set *PART_DT* as time partition column。

   > **Note:** Time partition colunn supports time/date/datetime/integer/tinyint/smallint/bigint/int4/long8 /varchar/string.

2. Cube Partition

   Cube Partition enables much flexibility in cube design and management. You can create only one cube with cube partition enabled, instead of creating several cubes with the same structure, and data can be loaded and queried on specific partion. This is very useful when you need to load data for many regions or organizations. You can load only one region's data into cube when it's ready and make it available for queries, without having to wait for all regions' data are ready

   The supported data types include integer (long / short / int / integer) or string (string / char / varchar).

   ![Save model](images/model_design_save_cube_partition_en.png)

   If the underlying data model is cube partition enabled, you have to specify the cube partition value when building a cube segment.

   ![Set partition value](images/cube_partition.png)

3. Data Filter Condition

   Filter condition is an additional data filter besides time partition and cube partition (if defined) during data loading. E.g. you can filter out these records with null values or specific records according to your business rules.

**Step 5. Save Model**

Finally, click the button **Submit**, and the data model is created.



### Lookup Table Snapshot

When lookup table is less than 300 MB, we suggest you to enable snapshot of lookup table, to simplify cube design and improve overall system efficiency. If the model has already finished data sampling, the size of tables would be estimated according to the sampling statistics. The table whose size is lower than 300 MB would be stored as snapshots.

- **Benefits of Lookup Table Snapshot**
  1. Allows detailed query on lookup tables.
  2. Columns in the dimension table can be set as derived dimentions during cube design.



- **How to Disable Lookup Table Snapshot**

  If your lookup table is too big, like over 300 MB, please turn off the snapshot feature for the lookup table, in order to successfully build the cube.

  To turn on/off snapshot, click **Overview** and then click **Model** tab. The Lookup table and Fact table will appear. In the **Lookup Table** section, you can speficy whether to store the a lookup table as snapshot.

  ![Turn on/off snapshot](images/model_design_update_en_6.png)

  > **Caution**:
  >
  > 1. When a lookup table is larger than 300 MB, we don't recommend you to store it as snapshop. But you can still set parameter `kylin.snapshot.max-mb` in `kylin.properties` to modify this when it's really necessary.
  > 2. When the parameter above is set to be larger than 300 MB, it might cause cube build job fail at step **Build Dimension Dictionary** and hence affect system stability. If you do need to store lookup table as snapshot, please contact [Kyligence Support](../introduction/get_support.en.md) for solution.
  > 3. We cannot successfully store a lookup table as snapshot when there are duplicated keys in dimension table.


### Slow Changing Dimension (SCD)

In most multi-dimensional OLAP scenarios, lookup table might change unpredictably, rather than according to a regular schedule. For snapshot enabled lookup tables, Kyligence Enterprise supports defining SCD types for all derived dimensions on this lookup table.

For more details, please refer to [Slowly Changing Dimension](scd.en.md).

