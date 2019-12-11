## 为查询指定 Cube 优先级

当一个项目中有多个就绪的 Cube 时，系统会自动为每个查询选择最合适的 Cube。当存在多个 Cube 都能满足一个查询，系统会自动适配一个执行成本最低的 Cube。通常来说，维度和度量越少的 Cube 执行成本越低。

但有时，用户希望直接指定查询要击中的 Cube，而不是由系统自动判断。这时就可以使用 CubePriority 注释选项。

> **提示**：系统允许在 SQL 中嵌入特定的注释来影响查询的执行过程，称为“注释选项”。

### CubePriority 注释选项

从 Kyligence Enterprise v3.4.2 开始，系统支持 CubePriority 注释选项，用于指定 Cube 匹配查询时的优先次序。使用举例如下。

```sql
-- CubePriority(CubeAlpha,CubeBeta)
select count(*) from KYLIN_SALES;
```

注释中关键字 CubePriority 后的括弧内包含一串由 `,` 分割的 Cube 名字，它们的优先级从高到低排列。以上例，假如 CubeAlpha 和 CubeBeta 都能满足查询，那么系统将优先使用 CubeAlpha。未在 CubePriority 中出现的其他 Cube 被视为最低优先级，将在高优先级的 Cube 都无法匹配时，由系统自动匹配。

### 注意事项

- CubePriority 关键字大小写敏感，且其后的括号前后内不能有多余的空格。不准确的拼写将导致系统无法识别该注释选项。
- 如果 SQL 中包含多条 CubePriority 注释选项，则只有第一条会生效，其他的会被忽略。
- CubePriority 也影响 Cube 相关的表索引的优先级，而所有的表索引的优先级又低于所有的 Cube。以上例中的 `CubePriority(CubeAlpha,CubeBeta)` 来说，产生的优先级次序如下：
  1. CubeAlpha
  2. CubeBeta
  3. 项目中的其他 Cube
  4. CubeAlpha 相关的表索引
  5. CubeBeta 相关的表索引
  6. 项目中的其他 Cube 相关的表索引

