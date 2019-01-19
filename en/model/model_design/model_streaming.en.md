## Model Design Based on Streaming Data

Kyligence Enterprise supports importing Kafka streaming data as data source. You can import a Kafka topic as a table and based on this table, data model and cube can be created. 

Designing a data model based on streaming data is almost the same as designing a normal data model, except one restriction:

- For a data model based on streaming data, it doesn't support joining with lookup tables. So when you define the data model, only select "DEFAULT.KAFKA_TABLE_1 " as the fact table, no lookup tables.

