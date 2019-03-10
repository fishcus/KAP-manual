## Cube and Segment Management

### Cube Management

* **Open Cube Management Page**

  Users can enter Cube Management page with the following steps.

  * Log in to the product web UI and switch to a specific project.

  * Click **Modeling** on the left navigation bar, then click on the **Overview** -> **Cube** tab on the right to view the Cube list (as shown below)

  ![cube draft](images/cube_segment_manage/draft_action_en.png)

* **Cube Status and Operations**

  There are 4 types of Cubes status, which is shown in the **Status** column in the Cube list, and to the rightmost of each cube are actions buttons/menus for Cube operations.
  * **Draft**: A cube that has not been officially saved. You can continue to edit, delete, and view the cube (see the cube description).
  * **Disable**: A cube with Disable status means it cannot be queried. The status will be converted to Ready automatically when it is built. Common executable actions includes:

    * Validate SQL
    * Delete
    * Edit
    * Build 
    * Ready (Convert a cube with a segment to READY)
    * Purge (Empty all segments under a cube)
    * Clone (Copy a cube, without copy a segment)
    * View Cube (View a cube's description)
    * Backup (Backup a cube's metadata), 
    * Edit cube's details (view or edit a cube's json).

  * **Ready**: A cube with Ready status means it has a segment and can be queried, but cannot be deleted or purged directly. Common executable actions includes: 

    * Validate SQL
    * Edit
    * Disable (Convert a READY cube to DISABLED) 
    * Clone (Copy a cube, without copy a segment) 
    * View Cube (View a cube's description) 
    * Backup (Backup a cube's metadata) 
  * **DESCBROKEN**: A cube with Broken status means it is abnormal because its metadata is broken.

  > **Note:**
  >
  > 1. When cubes are disabled after they are enabled, the user cannot modify the definition of dimensions and measures, or add/remove dimensions and measures. If you need to edit dimensions and metrics, you need to redesign and build a new cube.
  > 2. When cubes are disabled after they are enabled,  the user can edit dimension description, measure description, Refresh Setting and Advanced Setting.
  > 3. User can edit dimension description and measure description in a *DESCBROKEN* cube.



### Segment Management

Cube consists of one or more segments. When a cube is built, the segment data will be generated. The segment is divided by the partition columns.

Users can enter the Segment management interface by the following steps:

1. Open cube list page, the **>** arrow to the left of cube name.
2. Select **Segment** tag.

![build cube](images/cube_segment_manage/build_segment_en.png)

On Segment page, you can execute the following actions: 

- **Refresh**: Rebuild the segment.

- **Merge**: Merge several segments into one.

  Discontinuous segments can be merged. If the corresponding snapshots of those segments are different, a warning message will pop up. If continue to merge, the processing for slowly changing dimension (SCD) might be changed and your query result might be affected. For more information about SCD, please refer to [Slowly Changing Dimension](model_design/slowly_changing_dimension.en.md).

  > **Note:** 
  >
  > 1. Too many segments in one cube may degrade query performance. It is recommended to set up auto merge in refresh setting (step 4) when designing cube.
  > 2. Auto merge only applies to cube/model with incremental data loading type *By Date/Time*. For other scenarios, please plan your merge tasks accordingly.

- **Delete**

Clicking the ID of a segment that is being built, refreshed or merged, will lead you to the related job in **Monitor** page.

