## Permission Settings for Result Exporting


Kyligence Enterprise admin can control the permission of exporting query results by setting the parameters of `kap.web.export.allow.admin` and `kap.web.export.allow.other` in `conf/kylin.properties`, respectively for ADMIN and non-ADMIN users of Kyligence Enterprise.

1. After setting `kap.web.export.allow.admin` to `false`, the button for exporting query results will not be shown in the Insight page for ADMIN users. ADMIN users will not be allowed to call the restful api for exporting query result, either.

2. After setting `kap.web.export.allow.other` to `false`, the button for exporting query results will not be shown in the Insight page for non-ADMIN users. Non-ADMIN users will not be allowed to call the restful api for exporting query result, either.
