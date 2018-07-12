## Collect Table Statistics

This chapter will introduce table's statistics and how to utilize it in Kyligence Enterprise.

### Table Statistics

Kyligence Enterprise uses table's statistics for data source sampling, including column cardinality, sample data and other statistics, which is helpful in Data Model and Cube design.

### Why Table Statistics

Kyligence Enterprise can use it to generate optimal query plans for users.

### How to collect Table Statistics

Step 1. log in Kyligence Enterprise and select the needed project. 

Step 2. click the `Studio` on the navigation bar and select *Data Source*  to see the plan-to-collect tables.

Step 3. Select the sample tables and click `Sampling` on the top right.

![](images/collect_statistics.1.png)



Step 4. adjust sample size; drag the sampling bar to decide the sample size at pop up window; Kyligence Enterprise scans the whole table by default.

![](images/collect_statistics.3.png)

> Notice: Click Data Source and select one or multiple tables to decide sample size if metadata is not loaded.
>
> The sampling range is from 20%-40%-60%-80%-100%. The higher the sampling ratio is, the more accurate the sampling result will be. But it may consume more resources. Users can adjust according to actual resource configuration (see [recommended configuration](../config/recommend_settings.en.md )).

Step 5. click `Submit` and start table sampling.

Step 6. click `Monitor` on the left side, you can view table sampling status.

> Notice: If the data source is Kafka, the job for table sampling will not show in Monitor while KAP will still finish collecting table statistics.

Step 7. once you have done sampling, return to *Data Source* section and select specific tables for details.

Detailed statistical sampling include the following information; you can switch the tab to  view it.

- Column
- Extend Information
- Statistics
- Sample Data

![](images/collect_statistics.6.png)

![](images/collect_statistics.8.png)

![](images/collect_statistics.9.png)

![](images/collect_statistics.10.png)
