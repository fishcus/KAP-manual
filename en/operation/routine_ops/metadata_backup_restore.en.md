## System Metadata Backup and Restore

Kyligence Enterprise instances are stateless services, and all state information is stored in metadata. Therefore, backing up and restoring metadata is a crucial part of operation and maintenance. It can cause an entire instance or a Cube exception due to misoperation. Quickly recover Kyligence Enterprise from backup.

Metadata is divided into system level, project level, and cube level. The directory structure of this section is as follows:

- [Metadata Structure](#metadata_structure)
- [Metadata Backup](#metadata_backup)
- [Metadata Restore](#metadata_restore)


### Metadata Structure		{#metadata_structure}

| Metadata             | Description                                               | System-level | Project-level | Cube-level |
| ------------------ | -------------------------------------------------- | -------- | -------- | --------- |
| UUID               | Metadata identifier                      | √        | √        | √         |
| acl                | Access control list    | √        | √        |           |
| bad_query          | Bad query                                | √        | √        |           |
| cube               | Cube instance                               | √        | √        | √         |
| cube_desc          | Cube description                             | √        | √        | √         |
| cube_statistics    | Cube statistics                            | √        | √        |           |
| cube_stats_info    | Cube information                    | √        | √        |           |
| dict               | Dictionary                    | √        | √        |           |
| execute            | Building job information | √        | √        |           |
| execute_output     | Steps of building job information | √        | √        |           |
| history            | History information | √        | √        |           |
| kafka              | Kafka table                      | √        | √        |           |
| model_desc         | Model description                         | √        | √        | √         |
| model_stats        | Model statistics                           | √        | √        |           |
| project            | Project information | √        | √        | √         |
| query              | Saved query                                  | √        |          |           |
| raw_table_desc     | Table index description                    | √        | √        |           |
| raw_table_instance | Table index instance                        | √        | √        |           |
| scheduler          | Scheduler                                    | √        | √        |           |
| streaming          | Streaming table                          | √        | √        |           |
| table              | Table                                       | √        | √        | √         |
| table_exd          | Table extension information | √        | √        | √         |
| table_snapshot     | Lookup table snapshot                  | √        | √        |           |
| user               | User information                     | √        | √        |           |
| user_group         | User group information                 | √        | √        |           |




### Metadata Backup	{#metadata_backup}

In general, it is a good practice to back up metadata before each failure recovery or system upgrade. This can guarantee the possibility of rollback after the operation fails, and still maintain the stability of the system in the worst case. .

In addition, metadata backup is also a tool for fault finding. When the system fails, the front end frequently reports errors. By downloading and viewing metadata, it is often helpful to determine whether there is a problem with the metadata.

Metadata can be backed up via the command line or the user interface, as follows:

- Metadata backup via ** command line**

  Kyligence Enterprise provides a command line tool for backing up metadata, using the following methods:

  - Backup ** system level ** metadata

     ```sh
     $KYLIN_HOME/bin/metastore.sh backup
     ```

  - Backup ** project level ** metadata

     ```sh
     $KYLIN_HOME/bin/metastore.sh backup-project PROJECT_NAME PATH_TO_LOCAL_META_DIR
     ```

     Parameter Description:

     1. `ROJECT_NAME` - required, the name of the project to be backed up, such as learn_kylin
     2. `PATH_TO_LOCAL_META_DIR` - required, indicating the metadata save path of the backup

  - Backup **Cube level** metadata

     ```sh
     $KYLIN_HOME/bin/metastore.sh backup-cube CUBE_NAME PATH_TO_LOCAL_META_DIR
     ```

     Among them, `CUBE_NAME` is the name of the cube that needs to be backed up, such as kylin_sales_cube; `PATH_TO_LOCAL_META_DIR` indicates the metadata save path of the backup.

- Metadata backup via **user interface**

  > Tip: After the backup is successful, the interface will pop up a box to remind you of the metadata storage address.

  - Backup ** system level ** metadata
     On the **System** page, click the **Backup** button.
  - Backup ** project level ** metadata
     Select the item you want to back up and click the **Action** --> **Backup** button.
  - Backup **Cube level** metadata
     On the **Modeling**--> **Cube** page, select the cube you want to back up, and click **Action**-->**Backup**.


### Metadata Restore    {#metadata_restore}

Metadata recovery is required in Kyligence Enterprise with the **command line**.

**Note: **Recovery operations will overwrite the remote metadata with local metadata, so please confirm that Kyligence Enterprise is down or inactive (including build tasks) from backup to recovery, otherwise from backup to recovery Other metadata changes between them will be lost as a result. If you want the Kyligence Enterprise service to be unaffected, use **project level** or **Cube level** metadata recovery.

- Restore **system level ** metadata

  ```sh
  $KYLIN_HOME/bin/metastore.sh restore /path_to_backup
  ```

- Restore **project level ** metadata 

   ```sh
   $KYLIN_HOME/bin/metastore.sh restore-project project_name /path_to_backup
   ```

- Restore metadata for **Cube level**

   ```sh
   $KYLIN_HOME/bin/metastore.sh restore-cube project_name /path_to_backup
   ```

   Where `project_name` represents the project name and `/path_to_backup` represents the recovery path.