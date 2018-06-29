## KyBot Quick Start
### How does KyBot work
![](images/Picture1.png)

### How to register and login KyBot
KyBot can be accessed through [KyBot Official Website](https://kybot.io), and users can register Kyligence Account following the instructions on the page.

### How to obfuscate sensitive information
Related configuration shall be modified in `$KYLIN_HOME/kybot/kybot-client.properties`

> *Tips:* Configurations on KyBot Client work for all Diagnostic Packages generated online or through script.

- There are two levels of obfuscation, namely, `OBF` equals to obfuscation while `RAW` equals to non-obfuscation.
- Mail Account is obfuscated by default.
- Cardinality is not obfuscated by default, and users can enable obfuscation function by setting parameter `kybot.obf.cardinality` as `OBF`
 - Cardinality Obfuscation Range
 	+ `tiny`： <20 
 	+ `small`： <100 
 	+ `medium`： <1000 
 	+ `high`： <10,000 
 	+ `very high`： <100,000 
 	+ `ultra high`： >=100,000
- Host Name is not obfuscated by default, and users can enable obfuscation function by setting parameter `kybot.obf.hostname` as `OBF`. Besides, the pattern of the hostname also need to be specified by parameter `kybot.obf.hostname.pattern`, for example, `kybot.obf.hostname.pattern=\*.kybot.io`

### How to generate Diagnostic Packages
- Generate Diagnostic Package online

Since v2.3, Kyligence Enterprise enables uploading Diagnostic Packages online with a single click, and instructions are as followings.

> *Tips:* If users need proxy to visit extranet, following configurations in `$KYLIN_HOME/conf/kylin.properties` are required,
> 
> 
```
kap.external.http.proxy.host // http proxy address
kap.external.http.proxy.port // http proxy port
```
Restart Kyligence Enterprise is a must to make modified configurations work.

1.Login Kyligence Enterprise WEB UI, click the `Diagnosis` button on `System` page to generate System Diagnostic Packages; click the `...` to unfold the options and click `Diagnosis` button to generate Job Diagnostic Packages.

> *Tips:* Username and Password of Kyligence Account is needed at first use.

2.Click `Generate and sync package to KyBot` button.
> *Tips:* If your Kyligence Enterprise cannot access the extranet, please click `Only Generate` button to download the package to local and upload to KyBot manually.

More information about how to generate System Diagnostic Package and Job Diagnostic Package, please refer to [System Diagnosis and Job Diagnosis](../troubleshooting/diag.en.md).

- Generate Diagnostic Package through script

Users can execute `$KYLIN_HOME/kybot/kybot.sh` to generate System Diagnostic Packages; execute `$KYLIN_HOME/kybot/kybot.sh -jobId <job_id>` to generate System Diagnostic Packages.

> *Tips:*
> 
> 1. the default saving path of generated Diagnostic Packages is `$KYLIN_HOME/kybot_dump/`, and users can specify the path by modifying the  `destDir="$KYLIN_HOME/kybot_dump/"` to `destDir="${Your_directory}"` in `$KYLIN_HOME/kybot/kybot.sh`.
> 
> 2. Since v2.5.5, Kyligence Enterprise generates System Diagnosis without useless information, such as Hive temporary table, and users with older versions can append a parameter when executing the script `-includeGarbage false`.
> 
> 3. If *Invalid option* is prompted, please visit [KyBot Official Website](https://kybot.io) to download the latest version of KyBot Client.

### How to upload Diagnostic Packages
Login KyBot website, click the `Upload` button, drag or click the `browse` button to upload Diagnostic Packages. After successfully being uploaded, the Diagnostic Package will be analyzed, and users can view the analyzation process in the uploading page.

![](images/Picture4.png)
After Diagnostic Packages being successfully analyzed, users can visually view the basic condition of Kyligence Enterprise performance and optimize the system based on the analysis.



### Function Introduction
- Dashboard

	Visually presenting the health condition of Kyligence Enterprise clusters

	- Cube usage statistics

	![](images/Picture5.png)

	- Query execution statistics

	![](images/Picture6.png)

- Tuning
	Helping users to optimize Cube and query and find out system bottleneck, proving optimization tips

	- Cube details and utilization analysis

	![](images/Picture7.png)

	- SQL parsing and statistical analysis 

	![](images/Picture8.png)

- Incidents

	Providing effective incident solution based on Knowledge Base and log analysis

	- Exception statistics

	![](images/Picture9.png)


-  Help Center
	
	Users can get technical support by going through Knowledge Base and submitting ticket to Kyligence Support.

	- Knowledge Base: Users can search the Knowledge Base with keywords, finding out the solution of some known issues.

	- My Tickets: Enterprise users can submit tickets with question description and uploaded Diagnostic Package, and Kyligence Technical Support will help to locate the root cause and offer a solution.
 ![](images/Picture11.png)
