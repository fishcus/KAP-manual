## Query REST API

> **Tip**
>
> Before using API, please make sure that you have read the Access and Authentication in advance and know how to add verification information. 
>

If users access dataset built by KAP, mainly there are two API, one is querying data from Cube, another one is listing all available tables.

* Query
   * [Query Cube](#query-data-from-cube)
   * [List queryable tables](#list-queryable-tables)

## Query Data from Cube
`Request Mode POST`

`Access Path http://host:port/kylin/api/query`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Body
* sql - `required` `string` 

  Sql query sentences.

* offset - `optional` `int` 

  Query defaults to send results back from the first line, which could be changed to return from any line desired.

* limit - `optional` `int` 

  If limit parameter is chosen, query results would turn with corresponding lines from offset; if actual lines are less than limit set, then results would be just as actual lines.

* acceptPartial - `optional` `bool` 
  Mandatory is "true". If let it be true, then query results turned would be one billion lines at most; if users need more than one billion lines, then this parameter should be set as "false".

* project - `optional` `string` 
  Mandatory setting is "DEFAULT". In practice, if the query project is not "DEFAULT", then users need to set it as the project desired.


#### Detailed Information

The number, types and properties of a `ResultSet` object's columns are provided by the `ResultSetMetaData` object returned by the `ResultSet.getXXX` method.	

Reference: <https://docs.oracle.com/javase/7/docs/api/java/sql/ResultSet.html#getMetaData()>         <https://docs.oracle.com/javase/7/docs/api/java/sql/ResultSetMetaData.html>

#### Request Example

```sh
{  
   "sql":"select * from TEST_KYLIN_FACT",
   "offset":0,
   "limit":50000,
   "acceptPartial":false,
   "project":"DEFAULT"
}
```

#### Response Information
* columnMetas - metadata information for each column.
* results - turned result set.
* cube - the Cube corresponding to query.
* affectedRowCount -  the total number of rows related to this query. 
* isException - whether the query result is exceptional.
* exceptionMessage - turned corresponding exception information.
* totalScanCount - total counts.
* totalScanBytes - total bytes.
* hitExceptionCache - whether from the result cache which executes failed.
* storageCacheUsed - whether from the result cache which executes successfully.
* duration - query consumed time.
* partial - whether query results are partial return depends on acceptPartial is true or false.
* pushDown - whether enable the action of push down.

#### Response Example
```sh
{
    "code":"000",
    "data":{
        "columnMetas":[
            {
                "isNullable":1,
                "displaySize":19,
                "label":"TRANS_ID",
                "name":"TRANS_ID",
                "schemaName":"DEFAULT",
                "catelogName":null,
                "tableName":"TEST_KYLIN_FACT",
                "precision":19,
                "scale":0,
                "columnType":-5,
                "columnTypeName":"BIGINT",
                "readOnly":true,
                "signed":true,
                "writable":false,
                "autoIncrement":false,
                "caseSensitive":true,
                "searchable":false,
                "currency":false,
                "definitelyWritable":false
            }
        ],
        "results":[
            [
                "0",
                "27",
                "2012-01-01",
                "ABIN",
                "223",
                "0",
                "12",
                "10000843",
                "TEST322"
            ]
        ],
        "cube":"CUBE[name=mp_cube1]",
        "affectedRowCount":0,
        "isException":false,
        "exceptionMessage":null,
        "duration":1046,
        "totalScanCount":2014,
        "totalScanBytes":30210,
        "hitExceptionCache":false,
        "storageCacheUsed":false,
        "traceUrl": null,
        "timeout": false,
        "lateDecodeEnabled": false,
        "sparderEnabled": true,
        "partial":false,
        "pushDown":false
    },
    "msg":""
}
```

#### Curl Access Example
```
curl -X POST -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "sql":"select count(*) from TEST_KYLIN_FACT", "project":"learn_kylin" }' http://host:port/kylin/api/query
```


## List Queryable Tables
`Request Mode GET`

`Access Path http://host:port/kylin/api/tables_and_columns`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Parameter
* project - `required` `string`, indicates desired tables are from which project.

#### Request Example

`Request Path: http://host:port/kylin/api/tables_and_columns?project=your_project`

#### Detailed Information

* The structure of kylin table is returned by interface DatabaseMetadate, which is based on the specification of  JDBC API DatabaseMetaData.getColumns() method. 

  Reference:<https://docs.oracle.com/javase/7/docs/api/java/sql/DatabaseMetaData.html#getColumns(java.lang.String,%20java.lang.String,%20java.lang.String,%20java.lang.String)> 

* The definition of column
  1. TABLE_CAT String => table catalog (may be null)
  2. TABLE_SCHEM String => table schema (may be null)
  3. TABLE_NAME String => table name
  4. COLUMN_NAME String => column name
  5. DATA_TYPE int => SQL type from java.sql.Types
  6. TYPE_NAME String => Data source dependent type name, for a UDT the type name is fully qualified
  7. COLUMN_SIZE int => column size.
  8. BUFFER_LENGTH is not used.
  9. DECIMAL_DIGITS int => the number of fractional digits. Null is returned for data types where DECIMAL_DIGITS is not applicable.
  10. NUM_PREC_RADIX int => Radix (typically either 10 or 2)
  11. NULLABLE int => is NULL allowed.
      - columnNoNulls - might not allow NULL values
      - columnNullable - definitely allows NULL values
      - columnNullableUnknown - nullability unknown
  12. REMARKS String => comment describing column (may be null)
  13. COLUMN_DEF String => default value for the column, which should be interpreted as a string when the value is enclosed in single quotes (may be null)
  14. SQL_DATA_TYPE int => unused
  15. SQL_DATETIME_SUB int => unused
  16. CHAR_OCTET_LENGTH int => for char types the maximum number of bytes in the column
  17. ORDINAL_POSITION int => index of column in table (starting at 1)
  18. IS_NULLABLE String => ISO rules are used to determine the nullability for a column.
      - YES --- if the column can include NULLs
      - NO --- if the column cannot include NULLs
      - empty string --- if the nullability for the column is unknown
  19. SCOPE_CATALOG String => catalog of table that is the scope of a reference attribute (null if DATA_TYPE isn't REF)
  20. SCOPE_SCHEMA String => schema of table that is the scope of a reference attribute (null if the DATA_TYPE isn't REF)
  21. SCOPE_TABLE String => table name that this the scope of a reference attribute (null if the DATA_TYPE isn't REF)
  22. SOURCE_DATA_TYPE short => source type of a distinct type or user-generated Ref type, SQL type from java.sql.Types (null if DATA_TYPE isn't DISTINCT or user-generated REF)
  23. IS_AUTOINCREMENT String => Indicates whether this column is auto incremented
      - YES --- if the column is auto incremented
      - NO --- if the column is not auto incremented
      - empty string --- if it cannot be determined whether the column is auto incremented
  24. IS_GENERATEDCOLUMN String => Indicates whether this is a generated column
      - YES --- if this a generated column
      - NO --- if this not a generated column
      - empty string --- if it cannot be determined whether this is a generated column

#### Response Example
```sh
{
    "code": "000",
    "data": [
        {
            "columns": [
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "MINUTE_START",
                    "data_TYPE": 93,
                    "column_SIZE": 0,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": 0,
                    "ordinal_POSITION": 1,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "STREAMING_TABLE",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "TIMESTAMP(0)"
                },
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "HOUR_START",
                    "data_TYPE": 93,
                    "column_SIZE": 0,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": 0,
                    "ordinal_POSITION": 2,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "STREAMING_TABLE",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "TIMESTAMP(0)"
                },
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "DAY_START",
                    "data_TYPE": 91,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 3,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "STREAMING_TABLE",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "DATE"
                },
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "ITM",
                    "data_TYPE": 12,
                    "column_SIZE": 256,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": 256,
                    "ordinal_POSITION": 4,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "STREAMING_TABLE",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "VARCHAR(256) CHARACTER SET \"UTF-16LE\" COLLATE \"UTF-16LE$en_US$primary\""
                },
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "SITE",
                    "data_TYPE": 12,
                    "column_SIZE": 256,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": 256,
                    "ordinal_POSITION": 5,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "STREAMING_TABLE",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "VARCHAR(256) CHARACTER SET \"UTF-16LE\" COLLATE \"UTF-16LE$en_US$primary\""
                },
                {
                    "type": [
                        "MEASURE"
                    ],
                    "column_NAME": "GMV",
                    "data_TYPE": 3,
                    "column_SIZE": 19,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 6,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": 19,
                    "ordinal_POSITION": 6,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "STREAMING_TABLE",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "DECIMAL(19, 6)"
                },
                {
                    "type": [
                        "MEASURE"
                    ],
                    "column_NAME": "ITEM_COUNT",
                    "data_TYPE": -5,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 7,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "STREAMING_TABLE",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "BIGINT"
                }
            ],
            "type": [
                "FACT"
            ],
            "table_NAME": "STREAMING_TABLE",
            "table_SCHEM": "DEFAULT",
            "table_CAT": "defaultCatalog",
            "table_TYPE": "TABLE",
            "remarks": null,
            "type_CAT": null,
            "type_SCHEM": null,
            "type_NAME": null,
            "self_REFERENCING_COL_NAME": null,
            "ref_GENERATION": null
        },
        {
            "columns": [
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "TRANS_ID",
                    "data_TYPE": -5,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 1,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "BIGINT"
                },
                {
                    "type": [
                        "DIMENSION",
                        "FK"
                    ],
                    "column_NAME": "ORDER_ID",
                    "data_TYPE": -5,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 2,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "BIGINT"
                },
                {
                    "type": [
                        "DIMENSION",
                        "FK"
                    ],
                    "column_NAME": "CAL_DT",
                    "data_TYPE": 91,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 3,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "DATE"
                },
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "LSTG_FORMAT_NAME",
                    "data_TYPE": 12,
                    "column_SIZE": 256,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": 256,
                    "ordinal_POSITION": 4,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "VARCHAR(256) CHARACTER SET \"UTF-16LE\" COLLATE \"UTF-16LE$en_US$primary\""
                },
                {
                    "type": [
                        "DIMENSION",
                        "FK"
                    ],
                    "column_NAME": "LEAF_CATEG_ID",
                    "data_TYPE": -5,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 5,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "BIGINT"
                },
                {
                    "type": [
                        "DIMENSION",
                        "FK"
                    ],
                    "column_NAME": "LSTG_SITE_ID",
                    "data_TYPE": 4,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 6,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "INTEGER"
                },
                {
                    "type": [
                        "DIMENSION",
                        "FK"
                    ],
                    "column_NAME": "SLR_SEGMENT_CD",
                    "data_TYPE": 5,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 7,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "SMALLINT"
                },
                {
                    "type": [
                        "DIMENSION",
                        "FK"
                    ],
                    "column_NAME": "SELLER_ID",
                    "data_TYPE": 4,
                    "column_SIZE": -1,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": -1,
                    "ordinal_POSITION": 8,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "INTEGER"
                },
                {
                    "type": [
                        "DIMENSION"
                    ],
                    "column_NAME": "TEST_COUNT_DISTINCT_BITMAP",
                    "data_TYPE": 12,
                    "column_SIZE": 256,
                    "buffer_LENGTH": -1,
                    "decimal_DIGITS": 0,
                    "num_PREC_RADIX": 10,
                    "nullable": 1,
                    "column_DEF": null,
                    "sql_DATA_TYPE": -1,
                    "sql_DATETIME_SUB": -1,
                    "char_OCTET_LENGTH": 256,
                    "ordinal_POSITION": 9,
                    "is_NULLABLE": "YES",
                    "scope_CATLOG": null,
                    "scope_SCHEMA": null,
                    "scope_TABLE": null,
                    "source_DATA_TYPE": -1,
                    "is_AUTOINCREMENT": "",
                    "table_NAME": "TEST_KYLIN_FACT",
                    "table_SCHEM": "DEFAULT",
                    "table_CAT": "defaultCatalog",
                    "remarks": null,
                    "type_NAME": "VARCHAR(256) CHARACTER SET \"UTF-16LE\" COLLATE \"UTF-16LE$en_US$primary\""
                }
            ],
            "type": [
                "FACT"
            ],
            "table_NAME": "TEST_KYLIN_FACT",
            "table_SCHEM": "DEFAULT",
            "table_CAT": "defaultCatalog",
            "table_TYPE": "TABLE",
            "remarks": null,
            "type_CAT": null,
            "type_SCHEM": null,
            "type_NAME": null,
            "self_REFERENCING_COL_NAME": null,
            "ref_GENERATION": null
        }
    ],
    "msg": ""
}
```

#### Curl Example

```
curl -X GET -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/tables_and_columns?project=your_project
```
