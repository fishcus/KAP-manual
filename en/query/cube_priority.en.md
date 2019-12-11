## Specify Cube Priority for Queries

The system automatically choose the most suitable cube for each query, when there are multiple ready cubes in a project. If more than one cube can satisfy a query, the cube with lowest execution cost will be chosen. Usually cube with less dimensions and measures has a lower cost.

However, instead of leaving all controls to the system, sometimes user want to specify the cube a query shall hit. This is when the CubePriority comment option becomes useful.

> **Note**: Specific comments can be embedded in SQL to direct the system how queries should be processed. This mechanism is called *Comment Option*.

### CubePriority Comment Option

Since Kyligence Enterprise v3.4.2, the system supports CubePriority comment option to specify the priority of matching cubes for a query. The usage is like below.


```sql
-- CubePriority(CubeAlpha,CubeBeta)
select count(*) from KYLIN_SALES;
```

In the comment, the keyword `CubePriority` followed by a list of cube names wrapped in round brackets. The priority of the cube list is from high to low. For the example above, if both CubeAlpha and CubeBeta can satisfy the query, then CubeAlpha will be chosen since it has a higher priority. Cubes not mentioned in the cube list will have the lowest priority, and will only be considered by the system when all listed cubes don't match.

### Notice

- The keyword `CubePriority` is case sensitive and no space is allowed before and after the round bracket following it. Incorrect spelling will cause the comment option unrecognized.
- If a SQL contains multiple CubePriority options, only the first one takes effect. The rest are ignored.
- The CubePriority option also affects the table indices related to the cubes. Since all table indices have a lower priority than cubes, the `CubePriority(CubeAlpha,CubeBeta)` in the example above leads to a priority list like below:
  1. CubeAlpha
  2. CubeBeta
  3. Other cubes in the project
  4. CubeAlpha related table index
  5. CubeBeta related table index
  6. Other table indices in the project

