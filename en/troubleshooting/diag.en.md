## System Diagnosis and Job Diagnosis
Kyligence Enterprise users may face with many problems during usage, such as failure in creating a Cube or querying. Kyligence Enterprise provides a `Diagnosis` function on WEB UI to pack related information into a zip package to help devops better analyze the root cause.
Diagnosis function including System Diagnosis and Job Diagnosis.


#### System Diagnosis
System Diagnostic Package includes all diagnostic information of a Kyligence Enterprise instance, and users can generate System Diagnosis Package on Web UI following the following steps,

####1. Click the `Diagnosis` button on `System` Page

####2. Select Time Range
Users can select `last one hour`, `last one day`, `last three days` and `last one month`, or self-defined.

> *Tips:* the selected time range must include the period of incidents.

![](images/diagnosis/sys_diag_timerange.png)

####3. Select Problem Category
![](images/diagnosis/sys_diag_question.png)

####4. Select Server
![](images/diagnosis/sys_diag_server.png)

> *Tips:* if Kyligence Enterprise is deployed on multiple nodes, please locate the specific node on which incident happened, and select the right server name when generating Diagnostic Package, otherwise, the generated System Diagnostic Package may not include useful information about the issue.

####5. Select method of dealing with the packages
Kyligence Enterprise provides two options to dealing with Diagnostic Packages, one is downloading to local, and the other is uploading to KyBot for further analysis.

Click `Only generate` to generate the System Diagnostic Package and download to local.

![](images/diagnosis/sys_diag_download.png)

Click `Generate and sync package with KyBot` to generate the System Diagnostic Package and upload it to KyBot.

![](images/diagnosis/sys_diag_syncwithkybot.png)

> *Tips:* More information about the usage of KyBot, please refer to [KyBot Introduction](../kybot/README.md)

Meanwhile, Kyligence Enterprise supports uploading Diagnostic Packages to KyBot website, users can enable this function by turning on the `KyBot Auto Upload` on the dropdown list of `Help`, which is on the top of the page, and log in with Kyligence Account.

![](images/diagnosis/auto_diag_1.png)

![](images/diagnosis/auto_diag_2.png)

#### Job Diagnosis
Job Diagnostic Package includes all diagnostic information of a specific job, and users can generate Job Diagnosis Package on Web UI following the following steps,

####1. Click a certain job on the `Monitor` Page, unfold `Actions` and click `Diagnosis`.
![](images/diagnosis/job_diag_1.png)

####2. Select Server
![](images/diagnosis/sys_diag_server.png)

####3. Select method of dealing with the packages
Kyligence Enterprise provides two options to dealing with Diagnostic Packages, one is downloading to local, and the other is uploading to KyBot for further analysis.

Click `Only generate` to generate the System Diagnostic Package and download to local.

![](images/diagnosis/sys_diag_download.png)

Click `Generate and sync package with KyBot` to generate the System Diagnostic Package and upload it to KyBot.

![](images/diagnosis/sys_diag_syncwithkybot.png)
