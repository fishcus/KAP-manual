## Type Function

| Function Syntax     | Description                        | Example                                  | Result           |
| ------------------- | --------------------------------- | ---------------------------------------- | ---------------- |
| CAST(value AS type) | Converts a value to a given type. | ```select cast(CURRENT_DATE as varchar )``` | ```2017-08-10``` |

> **Caution**: These functions cannot be applied to **Computed Column**. For details about computed column, please refer to [Computed Column](../../model/computed_column/README.en.md) in the chapter of **Modeling**.
