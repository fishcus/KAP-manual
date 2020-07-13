## Cluster Deployment and Load Balancing
Kyligence Enterprise instance is stateless as all state information is stored in HBase or JDBC database. So running Kyligence Enterprise on multiple node in a cluster is a good practice for better load balance and higher availability.

![Deployment Architecture](images/cluster.png)

### Kyligence Enterprise Instance Configuration

To organize multiple Kyligence Enterprise nodes in a cluster, please make sure these nodes share the same Hadoop cluster and metadata store.

- In the configuration files `$KYLIN_HOME/conf/kylin.properties` of each Kyligence Enterprise node, set the same `kylin.metadata.url` for all nodes. Make sure all Kyligence Enterprise nodes use the same metadata store.

  > To turn on high availability for job engine, please refer to [Job Engine HA Configuration](ha.en.md).

### Load Balance Configuration

A Load Balancer, such as Apache HTTP Server and Nginx Server, is required to distribute requests in cluster. User sends requests to Load Balancer, then Load Balancer redirects requests to nodes according to some strategy. If the node handling the request fails, Load Balancer will retry to send the request to other node. Users who need to submit query requests can access Kyligence Enterprise through the address of Load Balancer. A good practice in this case is integrating LDAP in user and role management.

For example, in Nginx we can simply create a configuration file for Kyligence Enterprise site (like kylin.conf) with following content:

```shell
upstream kylin {
    server 1.1.1.1:7070; #Kylin Server 1
    server 1.1.1.2:7070; # Kylin Server 2
}
server {
    listen       8080;
    location / {
        proxy_pass http://kylin;
    }
}
```

By default, Nginx dispatches the requests to instances one by one. If one Kyligence Enterprise instance crashed, Nginx will remove it automatically. In this case, requests from one client may reach different instances, where user sessions are not shared by all instances. As a result, some requests will fail due to unauthentication. 

Using ip_hash in Nginx can save this, by dispatching requests to a Kyligence Enterprise instance according to client's IP address.

On the other side, ip_hash could bring workload imbalances to Kyligence Enterprise servers, especially when a few clients visit Kyligence Enterprise frequently, resulting in most requests send to few Kyligence Enterprise severs. To solve this, we can save user sessions to Redis cluster (or MySQL, MemCache), to share sessions among all Kyligence Enterprise instances.

To configure shared sessions in tomcat, do the following **on all query nodes**.

1. Execute the following command to download Redis Session Sharing plugin package

   ```sh
   wget https://github.com/ran-jit/tomcat-cluster-redis-session-manager/releases/download/3.0.4/tomcat-cluster-redis-session-manager.zip
   ```

2. Unzip the downloaded package and copy files.

   - Copy the jar files in lib folder to `$KYLIN_HOME/tomcat/lib/`
   - Copy file `redis-data-cache.properties` to path `$KYLIN_HOME/tomcat/conf/`

3. Specify the Redis host information in `$KYLIN_HOME/tomcat/conf/redis-data-cache.properties`, such as `redis.hosts=127.0.0.1:6379`,`redis.password=123456`.
   
   If you want to encrypt redis password, please configure `kylin.cache.redis.password` in kylin.properties and configure `redis.password=${REDIS_PASSWORD}`
   
   If you are using a Redis cluster, please configure the following properties:

   - `redis.hosts=host1:port,host2:port`

   - `redis.cluster.enabled=true`

   If you need to enable more functions, please refer to [Redis Session Manager introduction](https://github.com/ran-jit/tomcat-cluster-redis-session-manager).

4. Edit `$KYLIN_HOME/tomcat/conf/context.xml`, and add these items:

   ```xml
   <Valve className="tomcat.request.session.redis.SessionHandlerValve" />
   <Manager className="tomcat.request.session.redis.SessionManager" />
   ```

5. Please restart Kyligence Enterprise to take into effect.