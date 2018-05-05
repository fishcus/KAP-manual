## 任务报警

在KAP中，构建一个Cube往往至少需要花费几十分钟的时间。因此，当一个Cube构建任务完成或失败时，运维人员常常希望可以在第一时间得到通知，便于进行下一步的增量构建或故障排查。KAP中提供了一个邮件通知的功能，可以在Cube状态发生改变时，向Cube管理员发送电子邮件。

想要通过电子邮件实现任务报警，需要先在配置文件kylin.properties中进行设置：mail.enabled 设置该项为true，即可启动邮件通知功能mail.host 设置该项为邮件的SMTP服务器地址mail.username 设置为邮件的SMTP登录用户名mail.password 设置为邮件的SMTP登录密码mail.sender 设置为邮件的发送邮箱地址设置完毕后，重新启动KAP服务，这些配置即可奏效。接下来，需要对Cube进行配置。首先设置Cube的邮件联系人，作为邮件通知的收件人。如下图所示：![](images/alerting/job_alert_cn_1.png)

然后，选择一些状态作为邮件通知的触发条件。即当Cube构建任务切换到这些状态时，就给用户发送邮件通知。![](images/alerting/job_alert_cn_2.png)