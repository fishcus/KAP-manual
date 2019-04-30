## Import Data from Files

Kyligence Enterprise 3.1.0 starts to support data import directly from Hive data files. Together with upstream ETL, it can achieve near real-time data import and allow query of changes in the last few minutes.

This feature is still in **Beta** state. It requires users to have a good understanding of Kyligence Enterprise and Hive database. Please read and understand this guide thoroughly before putting it into real use.



### Background

Traditionally, the Hive data import is scheduled by a fixed period (e.g., daily). It requires a whole day's data be ready in Hive before the import can start, which causes a one-day delay before new data can serve queries. Hence, it cannot satisfy many near real-time analytics scenarios.

To allow for near real-time analysis, we come up with a new way of import directly using Hive data files. It is summarized as below.

- Upstream ETL sends new data to Kyligence Enterprise in the form of data files, typically several to a dozen of files per hour.
- The new file(s) kicks off data import immediately, and the new data is ready for query as soon as the data import job is completed.
- The system tolerates late coming data files, for example, the last file of the first hour can come later than the first file of the second hour. The late coming of data is common in streaming ETL.

This method of data import can reduce data latency to a few minutes. It enables near real-time analytics scenarios with a minor change of the import process, which is described as below.



### How It Works

Technically, this feature is a variant of the normal Hive data import. First, user creates model and cube based on Hive tables as usual. The new data files that upstream sends over must match the Hive table schema defined by the fact table in the model. During the data import process, the system will clone a new temporary table from the fact table in the model, and mount the new data files under it. The temporary Hive table is then used in place of the fact table in the model for the rest of data loading. Throughout the whole process, the data in the fact table is ignored. The purpose of the fact table is to define the data schema for new data files.

Another key point is that user is responsible for mapping data files to the **Segment Timeline** and continuously merge small segments by calling rest APIs provided by the system. Like normal Hive data import, every segment needs a clear start time and end time, which is its **Segment Range**. Multiple segment ranges connect together and form a timeline. The same concept applies to file-based data import. The only difference is that the system will rely on the users to specify the segment range of new data files.

For instance, a typical mapping of segment timeline is called "YYYYMMDD+Hour+BatchNum", which is a segment range format made up of 13 digits. Like the samples below, the first 10 digits represent year, month, day and hour. The last 3 digits represent the batch number within the hour.

- Assume A is the 1st file in *6 am 2018-11-12*, it maps to range [2018111206000, 2018111206001)
- Assume B is the 2nd file in *6 am 2018-11-12*, it maps to range [2018111206001, 2018111206002)
- Assume C is the 1st file in *7 am 2018-11-12*, it maps to range [2018111207000, 2018111207001)
- Assume D is the 3rd file in *6 am 2018-11-12* (late coming), it maps to range [2018111206002, 2018111207003)

Then, to merge all segments in the 6 am, that is A, B, and D, we need to specify the merge range of [2018111206000, 2018111207000). Similarly, to merge all segments of date 2018-11-12, we just specify the merge range of [2018111200000, 2018111300000).



### How To

1. Prepare Data Files

    - Create a new fact table in Hive. It is only for the description of data schema. Any data inside the fact table will be ignored.

     > **Note:** Please don't use partition column on this fact table, or it will cause problems to later data import.

    - Prepare a few data files that can be loaded into the Hive fact table.

    - As a test, try to copy the data files to the storage location of the Hive table, then query from Hive command line. The query result should contain the records from the data files.

2. Create Model and Cube

   - With the above Hive fact table, create a model as usual. Please refer to [Model Design Basics](../model/model_design/data_modeling.en.md) for more information.

> **Note:** Please don't use lookup table in the model yet. It is not supported at the moment.

   - Create a cube based on the model above. Please refer to [Cube Design Basics](../model/cube_design/create_cube.en.md) for more information.

   - To enable data import by files on the cube, add the following to the cube's advanced settings.

     ```properties
     kap.source.hive.file-incremental-mount-script=/{KE-install-dir}/bin/file-incr-load-prepare-hive.sh
     ```

     > **Note:** Please replace the `{KE-install-dir}` in the above example with the install location of Kyligence Enterprise. The `file-incr-load-prepare-hive.sh` will be called at the beginning of data import. In this script, a new temporary Hive table will be cloned from the model fact table and under which the given data files will be mounted.

3. Import Data

   - For cubes with file data import enabled, a new Rest API must be used to trigger build jobs. No data import is allowed from web GUI at the moment. Please refer to [Cube Build API](../rest/cube_api/cube_build_api.en.md).
   - Similarly, segment merge is also triggered via Rest API, please see the [Segment Manage API](../rest/segment_manage_api.en.md).
