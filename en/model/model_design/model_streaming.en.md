## Model Design on Streaming Data

Kyligence Enterprise supports importing streaming data and defining it as a table. You can use this table as a fact table and design a data model and Cube for later analysis.

Designing a data model based on streaming data is almost the same as designing a normal data model, except the following restrictions:

1. Model on streaming data doesn't support joining with lookup tables. 
2. Derived time dimension `MINUTE_START` must be set as a dimension in the model design.
