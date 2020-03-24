## Query Cache Settings

Kyligence Enterprise enables query cache in each process by default in order to improve query performance. In addition, using Redis clusters as a distributed query cache is also supported, which can be used in a cluster deployment environment.


###Use Default Cache

Kyligence Enterprise enables query cache by default at each node/process level. The detail configurations are described as below. You can change them in `$KYLIN_HOME/conf/kylin.properties` under Kyligence Enterprise installation directory.

> **Caution:** Any change of configurations below requires a restart to take effect. 

| Properties                                      | Description                                                  | Default                  | Options   |
| ----------------------------------------------- | ------------------------------------------------------------ | ------------------------ | --------- |
| kylin.query.cache-enabled                       | Whether to enable query cache. When this property is enabled, the following properties take effect. | true                     | false     |
| kylin.query.pushdown.cache-enabled              | Whether to enable query cache when using pushdown engine.    | true                     | false     |
| kylin.cache.ehcache.max-mb-local-heap           | The heap size used by query cache.                            | 1024, whose unit is MB   |           |
| kylin.cache.ehcache.max-entries-local-heap      | The amount of heap entries uesd by query cache.               | 0, which means unlimited |           |
| kylin.cache.ehcache.memory-store-eviction-polcy | Cache replacement policies.                                   | LRU                      | FIFO，LFU |

### Distributed Cache by Using Redis Cluster (Beta)

The default query cache cannot be shared among different nodes or processes because it is process level. Because of this,  when subsequent and same queries are routed to different Kyligence Enterprise nodes, the cache of the first query result cannot be used in cluster deployment mode. Therefore, you can configure Redis cluster as distributed cache, which can be shared across all Kyligence Enterprise nodes. The detail configurations are described as below:

| Properties                         | Description                                                  | Default        | Options |
| ---------------------------------- | ------------------------------------------------------------ | -------------- | ------- |
| kylin.query.cache-enabled          | Whether to enable query cache. When this property is enabled, the following properties take effect. | true           | false   |
| kylin.cache.redis.enabled          | Whether to enable query cache by using Redis cluster.         | false          | true    |
| kylin.cache.redis.cluster-enabled  | Whether to enable Redis cluster mode.                         | false          | true    |
| kylin.cache.redis.hosts             | Redis host. If you need to connect to a Redis cluster, please use comma to split the hosts, such as, kylin.cache.redis.hosts=localhost:6379,localhost:6380 | localhost:6379 |         |
| kylin.cache.redis.expire-time-unit | Time unit for cache period. EX means seconds and PX means milliseconds. | EX             | PX      |
| kylin.cache.redis.expire-time      | Valid cache period.                                           | 86400          |         |
| kylin.cache.redis.reconnection.enabled | Whether to enable redis reconnection when cache degrades to ehcache | true | false |
| kylin.cache.redis.reconnection.interval | Automatic reconnection interval, in minutes | 60 | |

### Query Cache Criteria
Kyligence Enterprise doesn't cache the query result of all SQL queries by default, because the memory resource might be limited. It only caches those queries which are slow and the result size is appropriate. The criterias are configured by the following parameters.

| Properties                         | Description                                                  | Default        | Options |
| ---------------------------------- | ------------------------------------------------------------ | -------------- | ------- |
| kylin.query.cache-threshold-duration          | Queries whose duration is below this value won't be cached. | 2000, whose unit is millisecond.           |   |
| kylin.query.cache-threshold-scan-count          | Queries whose scan row count is below this value won't be cached. | 10240, unit is row.           |   |
| kylin.query.cache-threshold-scan-bytes          | Queries whose scan bytes is below this value won't be cached. | 1048576, unit is byte.           |   |
| kylin.query.large-query-threshold          | Queries whose result set size is above this value won't be cached. | 1000000, unit is row.           |   |
