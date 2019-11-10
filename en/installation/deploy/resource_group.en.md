## Resource Group Deployment

Resources isolation is achieved through a multi-tenant deployment. However, to ensure the isolation of resources, this deployment mode may bring some waste of resources. Therefore, Kyligence support resource group deployment mode to improve resource utilization, which allows to deploy different resource groups according to different workload types.

### Resource Group Type

The resource groups are mainly divided into the following three types:

- **Default Resource Group**: To ensure the availability, each tenant is required to have a default resource group. If an instance in another resource group is unavailable, the resource group will serve as its backup and respond to the  request. Therefore, please meet at least one of the following requirements:
  - One All node
  - One Query node and one Job node
- **Build Resource Group**: This resource group will only be used for build requests, so please ensure there is at least one All node or one  Job node in this group.
- **Query Resource Group**: This resource group will only be used for query requests, so please ensure there is at least one All node or one Query node in this group. At the same time, the query resource group can also be divided into the following three types.
  - Basic Query: When defining this resource group, it will only respond to the Cube query.
  - Pushdown Query: When defining this resource group, it will only respond to the pushdown query.
  - Async Query: When defining this resource group, it will only respond to the async query.

### **How to Deploy**

This deployment mode needs to be deployed through Kyligence Manager. For more information, please refer to [Kyligence Manager Manual](https://docs.kyligence.io/books/manager/v1.0/en/index.html).