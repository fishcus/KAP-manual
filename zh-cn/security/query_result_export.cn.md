## 配置用户查询结果的导出权限

 系统管理员可以通过配置 `conf/kylin.properties` 下的 `kap.web.export.allow.admin` 和 `kap.web.export.allow.other` 两个配置项来设置  查询用户的查询结果导出权限。

1. 设置 `kap.web.export.allow.admin` 为 `false` 后，将关闭 ADMIN 用户对查询结果的导出权限。ADMIN 用户登陆后，在 Insight 页面将不显示导出按钮。
2. 设置 `kap.web.export.allow.other` 为 `false` 后，将关闭非 ADMIN 用户对查询结果的导出权限。非 ADMIN 用户登陆后，在 Insight 页面将不显示导出按钮。
