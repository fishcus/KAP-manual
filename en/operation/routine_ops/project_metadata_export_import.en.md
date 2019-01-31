## Project Metadata Export and Import

Starting with version 3.1.0 of Kyligence Enterprise, project level metadata import and export via GUI and Rest API is supported, which is convenient for users to migrate models and cubes in different environments.

### Prerequisite

- Check that users need **System ADMIN** or **Project ADMIN** permission;
- Check that the exported project must contain a Cube;
- Check the imported project. If the cube contains a Segment, it needs to be purged first.

### Metadata Export 

**Step 1**: Log in to the product web UI, click the item list at the top of the page to expand the icon.

**Step 2**: On the project management page, select the specific project, click on the rightmost operation column, and select the export function.

**Step 3**: In the pop-up window, the user can select the Cube to be exported for export, and the dependencies model and source data table will be exported.

The name of the exported tarball is: project_project_name_export_time.zip

> Note: The Safari browser may automatically decompress zip files, and users can change browser-related settings to disable automatic decompression.
>

All metadata is downloaded to a local directory as a file

| Directory Name     | Introduction                                                 |
| :----------------- | :----------------------------------------------------------- |
| project            | Contains basic information about the project, and statements about other metadata types included in the project |
| model_desc         | Contains definitions that describe the basic information and structure of the data model |
| cube_desc          | Contains definitions that describe the basic information and structure of the Cube model |
| cube               | Contains basic information about a Cube instance             |
| table              | Contains basic information about the table                   |
| table_exd          | Contains extended information about the table, such as dimensions |
| raw_table_desc     | Contains the basic information and structure definition of the table index |
| raw_table_instance | Contains basic information about a table index instance      |

### Metadata Import

**Step 1**: Log in to the product web UI, click the item list at the top of the page to expand the icon.

**Step 2**: On the project management page, select the specific project, click the rightmost **operation** column, select the **import** function.

**Step 3**: In the pop-up window, select the metadata package to be imported, and click on the **upload and analysis** button.

**Step 4**: After parsing the file package, the system will automatically display the preview information, and the preview will inform the user what resources are included in the project metadata file.

**Step 5**: The user clicks the import to start the import metadata operation (while importing, it detects whether the imported resource conflicts with the current environment, and if there is a conflict, the imported metadata is used as the standard).