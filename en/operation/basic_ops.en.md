## Basic Operations
Every day, KAP server accepts multiple Cube building jobs submitted by different customers. Cube building jobs could cost an unacceptable long time or even fail because of improper design or abnormal cluster environment, thus needs more attention from operation personnel. Additionally, after KAP service running for a period, some data on the HBase or HDFS would become useless, regular cleaning for these storage garbage is required.

## Operation Tasks

As KAP operation and maintenance personnel, the routine work includes:
* Ensure KAP service runs normally

* Ensure KAP uses cluster resources properly

* Ensure Cube building job goes normally

* Disaster backup and recovery

* So on and forth


As the saying goes "to do good work, one must first sharpen his tools", operation personnel needs to get familiar with tools mentioned in this chapter, in order to monitor KAP daily service as well as handle unforeseen situation quickly. For instance, to ensure KAP service running normally, operation personnel should keep an eye on KAP logs; to ensure KAP utilizing cluster resources properly, operation personnel should check their YARN queue and HBase storage utilization (such as number HTable and Region, etc.) frequently; to ensure Cube building job going normally, operation personnel needs to monitor jobs using email notification or the monitor page of Web GUI.