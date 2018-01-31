## KyBot Quick Start

### How does KyBot work?

![](images/Picture1.png)

### How to use KyBot?

#### 1. Register and login

Default access address of KyBot: [https://kybot.io](https://kybot.io). Please complete the registration according to the prompt.

#### 2. How to obscure sensitive information

- OBF=obfuscate RAW=none obfuscate
- Mail account is obfuscated by default while cardinality is not (If cardinality OBF set, obfuscated range: tiny: <20; small: <100; medium: <1000; high: <10,000; very high: <100,000; ultra high: >=100,000).
- If hostname defaults to be OBF, then the mode of hostname needs to be defined: such as kybot.obf.hostname.pattern=\*.kybot.io

#### 3. Generate diagnostic package

**KAP Users**

If you are using KAP 2.3 or subsequent versions, which supports one-click uploading to KyBot. For current version, check on following steps:

1.Login to KAP Web UI, click "Diagnosis" on System page.
![](images/Picture12.png)

2.Set your KyBot username and password in the popup when first use this function:

![](images/Picture13.png)

If your KAP server needs proxy server to access the Internet, following configurations in kylin.properties are required:

```
kap.external.http.proxy.host // http proxy server
kap.external.http.proxy.port // http proxy port
```

3.Click "One click to sync diagnostic package to KyBot". If your KAP does not have access to Internet, you can also download the diagnostic package to local with clicking "Download diagnostic package" and manually upload to KyBot. (Check following steps for uploading)

```
If the generation of diagnostic packages is too long, you may use the following commands:
#generate system diagnostic package
$KYLIN_HOME/kybot/kybot.sh

#generate system diagnostic package without temporary data, such as temporary Hive table. This configuration is used by default since KAP 2.5.5. 
$KYLIN_HOME/kybot/kybot.sh -includeGarbage false

#generate job diagnostic package
$KYLIN_HOME/kybot/kybot.sh -jobId <job_id>
```

> - Notes：if there is a warning named *Invalid option*, please go to [KyBot](https://kybot.io) and download the lastest KyBot Client.

4.Until uploading succeeds, you can navigate to [KyBot](https://kybot.io) to see the results.

5.If you have multiple KAP nodes, you need to upload diagnostics packages for each nodes.

**Kylin Users**

1. Download KyBot Client (support Apache Kylin1.5.0 and following version as well as all KAP versions) in advance, download path：Log on [KyBot official website](https://kybot.io), click "upload" on the first page then click "packing tool": KyBot Client" is available for download.
2. Extract to $KYLIN\_HOME/kybot directory of each Kylin node. 
3. Run $KYLIN_HOME/kybot/kybot.sh on each Kylin node to generate a diagnostic package.

![](images/Picture3.png)

#### 4. Upload diagnose package

Log on KyBot website, click the "Upload" button at the top of the page to access upload page, then Drag and drop or click "browse" button, to upload a desired KyBot diagnostic package. If the diagnose package get uploaded, it will join analysis queue soon. Users could check the analyzing speed on the upload page, and use further functions after analysis completed.

![](images/Picture4.png)

### Dashboard function introduction

#### 1. Dashboard

Get tp know the health status of KAP (or Apache Kylin) clusters

- Cube usage statistics

![](images/Picture5.png)

- Query execution statistics

![](images/Picture6.png)

#### 2. Optimization

Optimize Cube and query, find out system bottleneck, provide tuning recommendation

- ##### Cube details and utilize analysis

![](images/Picture7.png)

- #### SQL query parsing and statistical analysis 

![](images/Picture8.png)

#### 3. Troubleshooting

Founded on knowledge base and log analysis, provide effective incident solution

- #### Exception statistics

![](images/Picture9.png)

- #### Error tracing

![](images/Picture10.png)

#### 4. Technical support

Kyligence is capable to provide support from the original Apache Kylin team, so users can submit ticket throught KyBot to get technical support from Kyligence.

 ![](images/Picture11.png)
