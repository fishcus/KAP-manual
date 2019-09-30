## Model Design on Streaming Data

Kyligence Enterprise supports importing streaming data and defining it as a fact table. Models and cubes can be defined around such streaming table. Hive lookup tables can be defined around such streaming fact table to achieve joint analytics. Normal model centered by Hive fact table and streaming model centered by streaming table can coexist in one project.

Designing a data model based on streaming data is almost the same as designing a normal data model, except the following restrictions:

1. The streaming table must be a fact table. Hive table can only be used as lookup table.
2. Derived time dimension `MINUTE_START` must be set as a dimension in the model design.
