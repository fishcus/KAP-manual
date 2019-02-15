## Server Status ##

Since Kyligence Enterprise V2.5.5, users can check Kyligence Enterprise cluster server status in **System** page.


### Server Type ###

* Job Node (Leader): The node which is selected as the active job engine.

* Job Node (Follower): If the Leader node fails, the follower nodes will track the Cube build progress and process later build requests.

* Query Node: The node which is assigned as query engine.

### Server Status ###

* Active: The current node is running.
* Available: The current Follower node(s) could be selected as the new active Leader node.

> **Note:** If the nodes are disconnected, they will not be shown in the server list.

