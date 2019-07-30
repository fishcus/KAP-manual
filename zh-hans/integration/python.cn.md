## 与 Python 集成

本产品与 Python 集成由 kylinpy 提供支持。Kylinpy 提供了 SQLAlchemy Dialect 实现，本章节将介绍如何通过 SQLAlchemy 和 Pandas 访问 Kyligence Enterprise 中的数据。

### 使用条件

1. Python 2.7+ 或者 Python 3.5+
2. 已经安装 pip 包管理软件
3. 已经通过 pip 安装 SQLAlchemy
4. 已经通过 pip 安装 Pandas (可选)

### 如何获取 Kylinpy

```sh
pip install --upgrade kylinpy
```

如果需要离线安装 kylinpy , 可以通过如下网址下载压缩包后安装
https://pypi.org/project/kylinpy/#files

```sh
pip install kylinpy-<version>.tar.gz
```

### 如何配置连接 URI 和连接选项

- 配置连接 URI

  通过如下 URI 模板创建 SQLAlchemy 连接字符串 Kylin。
  
  ```
  kylin://<username>:<password>@<hostname>:<port>/<project>
  ```
  
  |配置项|配置说明|默认值|备注|
  |------------|------|------|------|
  |username|Kylin 帐名|||
  |password|Kylin 密码|||
  |hostname|Kylin 主机名或者 IP 地址||注意这里不要附加 http 或者 https|
  |port|Kylin 主机端口|7070||
  |project|Kylin 项目|||

- 配置连接选项

  SQLAlchemy **create_engine** 方法还可以接收一个 **connect_args** 参数作为**连接选项**，如下为连接可选项

  |配置项|配置说明|默认值|备注|
  |------------|------|------|------|
  |is_ssl|是否通过 ssl 连接|False||
  |unverified|允许不校验 ssl 证书|True||
  |prefix|Kylin api 前缀|kylin/api||
  |timeout|访问 Kylin 实例超时时间(单位: 秒)|30||
  |version|使用 Kylin api 版本|v1|可选值为 v2 和 v1|
  |is_pushdown|Kylin 实例是否开启 pushdown 选项|False|如果设为 True 可以查询到未经构建的原表|


### 通过 SQLAlchemy 访问

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

### 通过 Pandas 访问

```python
$ python
 >>> import sqlalchemy as sa
 >>> import pandas as pd
 >>> kylin_engine = sa.create_engine('kylin://ADMIN:KYLIN@sandbox/learn_kylin', connect_args={'is_ssl': True, 'timeout': 60})
 >>> sql = 'select * from kylin_sales limit 10'
 >>> dataframe = pd.read_sql(sql, kylin_engine)
 >>> print(dataframe)
```
