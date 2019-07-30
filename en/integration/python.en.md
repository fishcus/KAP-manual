## Integrate with Python

This product is integrated with Python and is supported by **kylinpy**. Kylinpy provides the SQLAlchemy Dialect implementation, this section describes how to access data in Kyligence Enterprise by SQLAlchemy and Pandas.

### Prerequisites

1. Python 2.7+ or Python 3.5+
2. installed pip
3. installed SQLAlchemy
4. installed Pandas (options)

### How to get Kylinpy

```sh
pip install --upgrade kylinpy
```

If you need to install kylinpy without the Internet, you can download the package and install by pip command.
https://pypi.org/project/kylinpy/#files

```sh
pip install kylinpy-<version>.tar.gz
```

### How to config connect URI and connect arguments

- Config connect URI

  Create a SQLAlchemy connection string with the following URI template Kylin.
  
  ```
  kylin://<username>:<password>@<hostname>:<port>/<project>
  ```
  
  |Configuration|Description|Default|Comment|
  |------------|------|------|------|
  |username|Kylin username|||
  |password|Kylin password|||
  |hostname|Kylin host name or IP address||Note that do not to append http or https with host name.|
  |port|Kylin port|7070||
  |project|project of Kylin|||

- Config connect options

  SQLAlchemy **create_engine** takes an argument **connect_args** which is an additional dictionary that will be passed to connect().  
  
  |Configuration|Description|Default|Comment|
  |------------|------|------|------|
  |is_ssl|Whether by ssl|False||
  |unverified|Do not verify ssl certificate|True||
  |prefix|Kylin api prefix|kylin/api||
  |timeout|access Kylin timeout(unit: seconds)|30||
  |version|Kylin api version|v1| v2 or v1|
  |is_pushdown|Whether to enable the pushdown option|False|If set to True, you can query the source table of Kylin.|

### Access via SQLAlchemy

```python
$ python
>>> import sqlalchemy as sa
>>> kylin_engine = sa.create_engine('kylin://ADMIN:KYLIN@sandbox/learn_kylin', connect_args={'timeout': 60})
>>> results = kylin_engine.execute('SELECT count(*) FROM KYLIN_SALES')
>>> [e for e in results]
[(4953,)]
>>> kylin_engine.table_names()
[u'KYLIN_ACCOUNT',
 u'KYLIN_CAL_DT',
 u'KYLIN_CATEGORY_GROUPINGS',
 u'KYLIN_COUNTRY',
 u'KYLIN_SALES',
 u'KYLIN_STREAMING_TABLE']
```

### Access via Pandas

```python
$ python
 >>> import sqlalchemy as sa
 >>> import pandas as pd
 >>> kylin_engine = sa.create_engine('kylin://ADMIN:KYLIN@sandbox/learn_kylin', connect_args={'is_ssl': True, 'timeout': 60})
 >>> sql = 'select * from kylin_sales limit 10'
 >>> dataframe = pd.read_sql(sql, kylin_engine)
 >>> print(dataframe)
```

