## Full Build

If we set the incremental data load type to **Full Build** when saving the model, the build type of the Cube designed in that model corresponds to **Full Build**.

![Set Full Build](images/full_build.png)

User can conduct full build in Web UI or via REST API. See [Cube API](../../rest/cube_api/README.md) for details.

User cannot merge segments in a full-build cube since there should be only one segment. Segment refresh can be conducted in Web UI and REST API.



### Full Build in Web UI

1. Select the cube (here Cube "full_build_cube" for example) designed in the model saved as **Full Build**, right click the **Action** button, and select **Build** in the drop-down menu. A pop-up window will appear as below:

   ![Build Cube](images/full_build_cube.png)

   If you need to set specified YARN queue for build tasks , parameters can be set in the system level or project level: kylin.engine-yarn.queue.in.task.enabled (whether to allow set specified YARN queue for build task, default value is false), kylin.engine-yarn.queue.in.task.available (available YARN queues, separate them with English commas). For example, kylin.engine-yarn.queue.in.task.enabled=true、kylin.engine-yarn.queue.in.task.available=default,test, a pop-up window will appear as below:

   ![Build Cube with specified YARN queue](images/full_build_cube_with_queue.png)

2. Click Continue to run the build job. After build completes, go to cube detail page and check if the cube status now is *Ready*. There should be a segment named FULL_BUILD under the cube.

![FULL_BUILD segment](images/full_build_segment_info.png)



