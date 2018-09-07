## Basic Operations
Every day, Kyligence Enterprise server accepts multiple Cube building jobs submitted by different customers. Cube building jobs could cost an unacceptable long time or even fail because of improper design or abnormal cluster environment, thus needs more attention from operation personnel. Additionally, after Kyligence Enterprise service running for a period, some data on the HBase or HDFS would become useless, regular cleaning for these storage garbage is required.

## Operation Tasks

As Kyligence Enterprise operation and maintenance personnel, the routine work includes:
* Ensure Kyligence Enterprise service runs normally

* Ensure Kyligence Enterprise uses cluster resources properly

* Ensure Cube building job goes normally

* Disaster recovery and backup

* So on and forth


As the saying goes "to do good work, one must first sharpen his tools", operation team needs to get familiar with tools mentioned in this chapter, in order to monitor Kyligence Enterprise daily service as well as handle unforeseen situation quickly. For instance, to ensure Kyligence Enterprise service running normally, operation personnel should keep an eye on logs of Kyligence Enterprise; to ensure Kyligence Enterprise can consume cluster resources properly, operation personnel should check their YARN queue and HBase storage utilization (such as number HTable and Region, etc.) frequently/periodically; to ensure Cube building job going normally, operation personnel needs to monitor jobs using email notification or the monitor page of Web GUI.
