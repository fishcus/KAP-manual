## Customized Build

In addition to Full Build, Build by date/time, Build by file, and streaming build, users may need more flexible ways to build cube. This product provides a customized incremental build from version 3.2. Users can customize the way the cubes are built in the system to meet production needs.



### Set build type in model

1. Choose Build Type

   If we set the incremental data load type to **Customize** when saving the model, the build type of the Cube designed in that model corresponds to **Customize**.

   ![Save model](images/customize_build_save_model.png)

2. Java Class for Customized Incremental Build and Class Initialization Parameter

   User needs to enter the class name of the Java class used to implement the custom incremental build. The Java class should be put under path $KYLIN_HOME/ext. After putting it under the right path,  the user should restart the system to enable this Java class.

   User passes the corresponding parameters according to the above Java class to implement a custom incremental build. Multiple parameters are separated by commas.

3. Set Cube Partition

   The cube will be built incrementally based on the specific column if the cube partition is enabled.

   ![Cube partition](images/customize_build_save_model_partition.png)

4. After click the **Submit** button, the model is all set.

   > **Note:** Cube build, segments refresh and merge can only be conducted in REST API. See [Cube API](../../rest/cube_api.en.md) for details.

5. After the build API is sent, you can see the corresponding job running in the Monitor page. The segment will be listed under the cube after the build job is finished. 

