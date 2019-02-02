# YouHaveATree

YouHaveATree is a visual aid for text snipped organization and nesting.

It is specifically developed for Choose Your Own Adventure and Interactive Fiction _drafting_.

* Planned Features:
* Return button goes back up to the previous tree.
* A list of all trees in the current project. By folder/name.
* Tooltips. Maybe.
* Allow the undoing of node Deletion.
* Saving of .tree files in a human readable, and easily editable, format. (Port them to a real writing tool!)

Usage:

* In the initial File dialoge. Select where you project will be stored. Or open an existing project by selecting the folder with its root.tree file.
* Use Shift + click and CTRL + click to place nodes.
* The bar in the top right indicates autosave status. The active tree is saved after one second of inactivity, and when closing the application (the normal way).
* WindowNodes (spawned with CTRL + click) point to other trees. When you click them the first time, select a .tree file in your project to link the node to. (If the file does not exist, this will create it.) TODO: Remove the "are you sure popup".
* You can rearranged nodes in the Tree by dragging their header.
* You can create connections by dragging from an outgoing (right) slot, to an ingoing (left) slot. Do the same in reverse to remove connections.

Sample Images:

![Alt text](/Demo%20Tree%20and%20Images/2.png?raw=true "Title")

![Alt text](/Demo%20Tree%20and%20Images/1.png?raw=true "Title")

![Alt text](/Demo%20Tree%20and%20Images/0.png?raw=true "Title")

# .tree File Specifications

Each .tree file represents one tree in your project. It is stored in plain text, using the below format:

```
YouHaveATree .tree file.

###META###
camera_pos = [128, 0]

###CONNECTIONS###
[node_a, node_b]

###NODES###
node_name = node_a
node_type = 0
node_pos = (0, 0)
some text

node_name = node_b
node_type = 0
node_pos = (256, 0)
some text


```

```
Header
empty_line
META Header
property'space'='space'value # variable
... repeat above for each meta property
empty_line
CONNECTIONS Header
from_node_name,'space'to_node_name # string, string
... repeat above for each connection
empty_line
NODES Header
node_name'space'='space'node_name # string
node_type'space'='space'node_type # integer
node_position'space'='space'node_position # [x_integer, y_integer]
multiline_string_representing_node_data
empty_line
... repeat above for each node
empty_line #end of file.
```