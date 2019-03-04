## Logical Operators

| Operator     | Description                               | Syntax                | Example                       |
| ------------ | ---------------------------------------- | --------------------- | ----------------------------- |
| AND          | Whether *boolean1* and *boolean2* are both TRUE | boolean1 AND boolean2 | Name ='frank' AND gender='M'  |
| OR           | Whether *boolean1* is TRUE or *boolean2* is TRUE | boolean1 OR boolean2  | Name='frank' OR Name='Hentry' |
| NOT          | Whether *boolean* is not TRUE; returns UNKNOWN if *boolean* is UNKNOWN | NOT boolean           | NOT (NAME ='frank')           |
| IS FALSE     | Whether *boolean* is FALSE; returns FALSE if *boolean* is UNKNOWN | boolean IS FALSE      | Name ='frank' IS FALSE        |
| IS NOT FALSE | Whether *boolean* is not FALSE; returns TRUE if *boolean* is UNKNOWN | boolean IS NOT FALSE  | Name ='frank' IS NOT FALSE    |
| IS TRUE      | Whether *boolean* is TRUE; returns FALSE if *boolean* is UNKNOWN | boolean IS TRUE       | Name ='frank' IS TRUE         |
| IS NOT TRUE  | Whether *boolean* is not TRUE; returns TRUE if *boolean* is UNKNOWN | boolean IS NOT TRUE   | Name ='frank' IS NOT TRUE     |
