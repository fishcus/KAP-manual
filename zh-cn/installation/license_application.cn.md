## 许可证申请及更新

许可证是使用 KAP 的必要条件。在安装和部署完 KAP 之后，需要申请许可证，才能使用 KAP。在 KAP 产品中，许可证分为 KAP 许可证、KAP Plus 许可证和 KyBot 许可证。KAP 及 KAP Plus 的许可证有试用许可证（试用期限均为两个月）和正式许可证。KyBot 在线服务分基础版、标准版和专业版三种，标准版是免费的，专业版提供更多的服务和 SLA 支持。KAP 与 KAP Plus 的许可证不同，因此申请流程也稍有差别。下面将详细介绍 KAP 及 KAP Plus 许可证的申请流程及具体操作。

### 申请流程

许可证申请流程及具体操作如下：

- 使用帐号信息登录 [Kyligence Account Center](http://account.kyligence.io/)。如果未申请过帐号，需要先注册。如果已经注册，使用注册的帐号信息登录。

![Kyligence Account Center](images/license_1.cn.png)

- 登录后，选择要申请的许可证 **KAP Plus** 。如果要申请 KAP Plus 试用许可证，需要先填写一张表，申请通过后，您会收到一封包含许可证的通知邮件。

![试用许可证申请](images/license_2.cn.png)

- 如果需要购买 KAP Plus 的正式许可证，需要提供**许可证申请文件**。您可以在 KAP Plus中，点击**帮助 -> 关于KAP**。

![正式许可证申请](images/license_3.cn.png)

然后点击**生成许可申请文件**，获取该文件。

![许可证申请文件](images/license_4.cn.png)

### 加载及更新许可证
在收到许可证文件（试用许可证或正式许可证）并安装完 KAP Plus 之后，需要加载该文件，才能使用KAP Plus。具体操作步骤如下：

在 KAP 登录页面点击**帮助 -> 更新许可证**，将显示**更新许可证**窗口（见下），点击 **Browse** 找到保存 LICENSE 文件的位置，依次点击**打开 -> 提交** ，即可将它上传到 KAP；也可将许可证文件直接拷贝到该窗口中。

![上传许可证文件](images/license_5.cn.png)

除此之外，也可将 LICENSE 文件拷贝到 KAP 的安装目录下。假设您将许可证文件下载到 Downloads 文件夹下，KAP 安装在 ${KYLIN_HOME} 目录：

```
scp Downloads/LICENSE root@sandbox:/${KYLIN_HOME}
```

如果需要更新许可证，可以通过上述两种方法进行更新。需要注意的是如果通过拷贝许可证方法进行更新，需要重新启动KAP才可生效。