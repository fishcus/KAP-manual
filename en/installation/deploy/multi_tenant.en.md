## Multi-tenancy Deployment

Kyligence Enterprise supports the multi-tenancy deployment mode to achieve data and resource isolation between various business units. This mode can ensure the different department applications will not be influenced by other department. 

For different departments, you can use different projects for each of them and divide them into different tenants in your system architecture, which can achieve complete isolation of resources.

### How to Achieve

In a multi-tenancy mode, tenants are managed as KyligenceEnterprise physical resource units and can be managed at the project level. Each tenant has an independent build and query node. The requests are distributed to the corresponding tenant instance through the load balancer. 

All the instances need to share the metadata and cluster computing resources. For the end user, there is no difference between using a single tenancy or multi-tenancy architecture. Through the isolation mechanism, the data of each tenant is independent of each other.

**Storage Resource Isolation**

The HDFS directory is stored according to the project directory, and the build data of each project is stored separately. Moreover, the access permission is guaranteed by the Linux/Hadoop account.

**Computing Resource Isolation**

Project-level YARN queue configuration is provided for the isolation. The different projects can be configured with different queues. At the same time, a separate Spark clusters is used in each tenant. When some tenants encounter services problems, it will not affect by each other.

### **How to Use**

This deployment mode is an advanced feature, please contact [Kyligence sales](https://kyligence.io/) for more details.