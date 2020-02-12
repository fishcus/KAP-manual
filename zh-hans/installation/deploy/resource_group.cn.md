## 资源组部署

通过多租户部署模式，实现了应用程序资源的完全隔离。但是在保障资源的隔离同时，这种模式下可能会带来一定的资源浪费。因此为了提高资源利用率，Kyligence 可以在指定的租户内实现资源组部署模式，允许租户的项目根据工作负载类型设置不同的资源组。



### 资源组类型

资源组主要分为如下三种类型：

- **默认资源组**：为了保障租户内的稳定可用，每个租户将必须拥有一个默认资源组。当其他资源组的实例不可用时，该资源组将作为其备份，响应对应请求。因此为了保证默认资源组能够响应所有的请求，请您确保默认资源组下最少有一个 All 角色或一个 Query 及 Job 角色的实例。
- **构建资源组**：该资源组将仅用于响应构建请求，因此请您确保构建资源组下最少有一个 All 角色或一个 Job 角色的实例。
- **查询资源组**：该资源组将仅用于响应查询请求，因此请您确保查询资源组下最少有一个 All 角色或一个 Query 角色的实例。同时，为了满足企业级用户更细粒度的管控，查询资源组还可以细分为如下三种
  - 一般查询：当定义该资源组时，系统将仅响应 Cube 查询
  - 下压查询：当定义该资源组时，系统将仅响应下压查询
  - 异步查询：当定义该资源组时，系统将仅响应异步查询



### **如何使用**

该部署模式为产品高级功能，如您需要使用请咨询[销售](https://kyligence.io/zh/)获取详情。