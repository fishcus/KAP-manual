## String Functions

| Syntax                                                       | Description                                                  | Example                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| CHAR_LENGTH(string)                                          | Returns the number of characters in a character string       | `CHAR_LENGTH('Kyligence')`<br /> = 9                         |
| CHARACTER_LENGTH(string)                                     | As CHAR_LENGTH(*string*)                                     | ` CHARACTER_LENGTH('Kyligence')`<br /> = 9                   |
| UPPER(string)                                                | Returns a character string converted to upper case           | ` UPPER('Kyligence')`<br /> = KYLIGENCE                      |
| LOWER(string)                                                | Returns a character string converted to lower case           | ` LOWER('Kyligence')`<br /> = kyligence                      |
| POSITION(string1 IN string2)                                 | Returns the position of the first occurrence of *string1* in *string2* | ` POSITION('Kyli' IN 'Kyligence')`<br /> = 1                 |
| TRIM( { BOTH \ LEADING\ TRAILING } string1 FROM string2)     | Removes the longest string containing only the characters in *string1* from the start/end/both ends of *string1* | Example1: <br />` TRIM(BOTH '6' FROM '666Kyligence66')`<br /> = Kyligence<br /><br />Example 2: <br />` TRIM(LEADING '6' FROM '666Kyligence66')`<br /> = Kyligence66<br /><br />Example 3: <br />` TRIM(TRAILING '6' FROM '666Kyligence66')`<br /> = 666Kyligence |
| OVERLAY(string1 PLACING string2 FROM integer [ FOR integer2 ]) | Replaces a substring of *string1* with *string2*             | ` OVERLAY('666' placing 'KYLIGENCE' FROM 2 for 2)`<br /> = 6KYLIGENCE |
| SUBSTRING(string FROM integer)                               | Returns a substring of a character string starting at a given point | ` SUBSTRING('Kyligence' FROM 5)`<br /> = gence               |
| SUBSTRING(string FROM integer1 FOR integer2)                 | Returns a substring of a character string starting at a given point with a given length | ` SUBSTRING('Kyligence' from 5 for 2)`<br /> = ge            |
| INITCAP(string)                                              | Returns *string* with the first letter of each word converter to upper case and the rest to lower case. Words are sequences of alphanumeric characters separated by non-alphanumeric characters. | ` INITCAP('kyligence')`<br /> = Kyligence                    |
| REPLACE(string, search, replacement)                         | Returns a string in which all the occurrences of *search* in *string* are replaced with *replacement*; if *replacement* is the empty string, the occurrences of *search* are removed | ` REPLACE('Kyligence','Kyli','Kyliiiiiii')`<br /> = Kyliiiiiiigence |
| ASCII(str)                                                   | Convert the first character of *str* to corresponding ascii code | `ASCII('ab')` = 97                                           |
| CHR(ascii)                                                   | Convert ascii code to corresponding character                | `CHR(97)` = a                                                |
| SPACE(len)                                                   | Generate *len* number of continuous space                    | `'>' + space(2) + '<'` = >  <                                |
| SPLIT_PART(str, separator, index)                            | Split *str* with *separator* and return the *index*-th token. *index* counts from 1. when *index* is negative, tokens are counted starting from the right. | `split_part('a-b-c', '-', 1)` = a,   `split_part('a-b-c', '-', -1)` = c, |

