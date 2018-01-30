## KyBot介绍及快速入门


### KyBot是如何工作的？

![](images/Picture1.png)



### 如何使用KyBot？

#### 1. 登录注册

KyBot默认访问地址：[https://kybot.io](https://kybot.io)，根据提示完成注册。

#### 2. 如何混淆敏感信息

- OBF=混淆 RAW=不混淆
- 邮箱账号等隐私信息默认是混淆的，而Cardinality默认不混淆（若启用混淆，Cardinality 混淆范围：tiny: <20 small: <100 medium: <1000 high: <10,000 very high: <100,000 ultra high: >=100,000）
- 如hostname设置为OBF，需要定义hostname的模式，如kybot.obf.hostname.pattern=\*.kybot.io

#### 3. 生成诊断包

**KAP用户**

如果您使用的是KAP 2.3及以上版本，支持一键上传诊断包到KyBot，当前版本下的操作步骤是：

1.登录KAP WEB UI，单击系统页面的"诊断"按钮，弹出以下提示框
![](images/Picture12.png)

2.第一次使用该功能需要输入登录KyBot的用户名和密码：

![](images/Picture13.png)

如果您的KAP服务器需要通过代理才可访问外网，还需在kylin.properties中添加一下配置项：

```
kap.external.http.proxy.host // http代理服务器地址
kap.external.http.proxy.port // http代理服务器端口
```

3.单击“生成诊断包并上传至KyBot”；如果您的KAP节点无法访问外网，也可以单击“下载诊断包”将诊断包下载到本地，然后手动上传到KyBot。（上传步骤见下文）

```
如生成诊断包时间过长，可通过如下命令行操作：
#生成系统诊断包
$KYLIN_HOME/kybot/kybot.sh
#生成任务诊断包
$KYLIN_HOME/kybot/kybot.sh -jobId <job_id>
```

   >* 提示：如您遇到**Invalid option**提示，请您尝试前往[KyBot官网](https://kybot.io)，下载最新的KyBot Client。

4.稍等片刻，待诊断包上传成功，访问[KyBot网站](https://kybot.io)即可查看 

5.如果您的KAP是集群部署方式，需要对每个KAP节点分别上传诊断包

**Kylin 用户**

1.下载KyBot Client (支持Apache Kylin1.5.0以上及KAP全部版本)下载路径：登录[KyBot官网](https://kybot.io)，在首页点击上传，然后点击"打包工具: KyBot Client"即可下载。

2.解压到每个Kylin节点的$KYLIN\_HOME/kybot目录

3.在每个Kylin节点运行$KYLIN\_HOME/kybot/kybot.sh来生成诊断包

![](images/Picture3.png)

#### 4.诊断包上传

登录KyBot网站，单击页面顶部的"上传"按钮，即打开上传页面，拖拽或单击"上传"按钮上传诊断包，上传成功后即加入分析队列，用户可以在上传页面查看分析进度，分析好之后就可使用全部功能。

![](images/Picture4.png)



### 页面功能介绍

#### 1. 仪表盘

洞悉KAP（Apache Kylin）集群的健康情况

- ##### Cube使用情况统计

![](images/Picture5.png)

- ##### Query执行情况统计

![](images/Picture6.png)

#### 2. 调优

优化Cube和查询, 找到系统瓶颈，给予优化建议

- ##### Cube 详情及使用分析

![](images/Picture7.png)

- ##### SQL查询解析及统计分析

![](images/Picture8.png)

#### 3. 故障排查

基于知识库和日志分析，提供有效的故障解决方案

- ##### 异常统计

![](images/Picture9.png)

- ##### 故障追踪

![](images/Picture10.png)

#### 4. 提交工单获取技术支持

Kyligence提供的Apache Kylin原厂支持，用户可以通过KyBot提交工单获取Kyligence的技术支持。 ![](images/Picture11.png)
