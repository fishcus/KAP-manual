## Arithmetic Functions

| Syntax               | Description                                                | Example                  |
| ------------------------------ | ------------------------------------------------------------ | ---------------------------- |
| POWER(numeric1, numeric2)      | Returns *numeric1* raised to the power of *numeric2* | `POWER(5,2)`<br /> = 25.0 |
| ABS(numeric)                   | Returns the absolute value of *numeric* | `ABS(-2)`<br /> = 2  |
| MOD(numeric1, numeric2)        | Returns the remainder (modulus) of *numeric1* divided by *numeric2*. The result is negative only if *numeric1* is negative | `MOD(-3, 2)`<br /> = -1 |
| SQRT(numeric)                  | Returns the square root of *numeric* | `SQRT(16)`<br /> = 4.0 |
| LN(numeric)                    | Returns the natural logarithm (base *e*) of *numeric* | ` LN(2)`<br /> = 0.6931471805599453 |
| LOG10(numeric)                 | Returns the base 10 logarithm of *numeric* | ` LOG10(100)`<br /> = 2.0 |
| EXP(numeric)                   | Returns *e* raised to the power of *numeric* | ` EXP(1)`<br /> = 2.718281828459045 |
| CEIL(numeric)                  | Rounds *numeric* up, returning the smallest integer that is greater than or equal to *numeric* | ` CEIL(-2.2)`<br /> = -2 |
| FLOOR(numeric)                 | Rounds *numeric* down, returning the largest integer that is less than or equal to *numeric* | ` FLOOR(-2.2)`<br /> = -3 |
| RAND([seed])                   | Generates a random double between 0 and 1 inclusive, optionally initializing the random number generator with *seed* | ` RAND(15)`<br /> = 0.45951471073476047 |
| RAND_INTEGER([seed, ] numeric) | Generates a random integer between 0 and *numeric* - 1 inclusive, optionally initializing the random number generator with *seed* | ` RAND_INTEGER(15,50)`<br /> = 22 |
| ACOS(numeric)                  | Returns the arc cosine of *numeric* | ` ACOS(0.8)`<br /> = 0.6435011087932843 |
| ASIN(numeric)                  | Returns the arc sine of *numeric* | ` ASIN(0.8)`<br /> = 0.9272952180016123 |
| ATAN(numeric)                  | Returns the arc tangent of *numeric* | ` ATAN(0.8)`<br /> = 0.6747409422235527 |
| ATAN2(numeric1, numeric2)      | Returns the arc tangent of the *numeric*coordinates | ` ATAN2(0.2, 0.8)`<br /> = 0.24497866312686414 |
| COS(numeric)                   | Returns the cosine of *numeric*     | ` COS(5)` <br /> = 0.28366218546322625 |
| COT(numeric)                   | Returns the cotangent of *numeric*  | ` COT(5)`<br /> = -0.2958129155327455 |
| DEGREES(numeric)               | Converts *numeric* from radians to degrees | ` DEGREES(5)`<br /> = 286.4788975654116 |
| PI()                           | Returns a value that is closer than any other value to *pi* |           ` PI()`<br /> = 3.141592653589793           |
| RADIANS(numeric)               | Converts *numeric* from degrees to radians | ` RADIANS(90)`<br />= 1.5707963267948966 |
| ROUND(numeric1, numeric2)      | Rounds *numeric1* to optionally *numeric2* (if not specified 0) places right to the decimal point | ` ROUND(5.55555,2)`<br /> = 5.56 |
| SIGN(numeric)                  | Returns the signum of *numeric*     | ` SIGN(-5)`<br /> = -1 |
| SIN(numeric)                   | Returns the sine of *numeric*       | ` SIN(5)`<br />= -0.9589242746631385 |
| TAN(numeric)                   | Returns the tangent of *numeric*    | ` TAN(5)`<br /> = -3.380515006246586 |
| TRUNCATE(numeric1, numeric2)   | Truncates *numeric1* to optionally *numeric2*(if not specified 0) places right to the decimal point | ` TRUNCATE(5.55555,2)`<br />= 5.5 |
