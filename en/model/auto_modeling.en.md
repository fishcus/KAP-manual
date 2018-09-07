## Model Advisor

Model design is a key part to use Kyligence Enterprise. Because the initial version of model design requires modelers to have business acumen and deep understanding of query requirements. To lower the learning curve of modeling, enable business professionals to generate models directly from SQL statements. We featured the model advisor to meet this demand: all you need to do is just drag one table into the model designer and set it as fact table, then the SQL statements you entered will complete the rest part of the model design.

### Apply SQL to Generate a Desired Model

Step 1, synchronize target tables to the project. 

![sync table](images/auto modeling/auto_sync_table.png)

Step 2, drag one table, which will be the fact table, to the model designer and set it as *fact*. Click ***SQL*** button to pop up a dialog to collect your SQL statements. 

> Note: only fact tables will have this button and SQL queries here you typed in should be the SQL you would query later.
>

![set fact table](images/auto modeling/fact_table.png)

![collect SQL](images/auto modeling/sql_window.png)

Step 3, enter the SQL statements that would cross this model. You should ***check***  these SQL statements to make sure which could be used to generate model, because only correctly recognized ones could work. If all SQL statements are right to the model advisor, the dialog would look the same as the following picture.

![valid SQLs](images/auto modeling/valid_SQL.png)

Step 4, ***submit*** checked SQL statements and you will get a initial model from your SQLs as below. Please do modify, check and re-submit SQLs via ***model advisor***.  When you are all set, save it.

![model advisor complete once](images/auto modeling/auto_modeling.png)