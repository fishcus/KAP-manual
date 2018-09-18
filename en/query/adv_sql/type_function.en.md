## Type Function

| Function Syntax     | Description                        | Example                                  | Result           |
| ------------------- | --------------------------------- | ---------------------------------------- | ---------------- |
| CAST(value AS type) | Converts a value to a given type. | ```select cast(CURRENT_DATE as varchar )``` | ```2017-08-10``` |

**Note**: This function is inapplicable to Computed Column. For the information of computed column, please refer to the section [Computed Column](model/computed_column.en.md) in the chapter of **Modeling**.