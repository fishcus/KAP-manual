## Cube Design on Streaming Data

Cubes on streaming data are very similar with regular cubes except the following points,

1. Time column *MINUTE_START* needs to be defined as a cube dimension.
2. It is not recommended to add timestamp type column (such as *ORDER_TIME*) as a dimension, because the granularity is too small and it will affect cube build and query performance, while usually it wont' be used in a query
3. When setting up Rowkeys, drag dimensions (e.g., *MINUTE_START*), which is commonly used in the query, to the top position.
4. Streaming cubes **DO NOT** support table index for now.
