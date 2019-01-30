# YouHaveATree

YouHaveATree is a visual aid for text snipped organization and nesting.

It is specifically developed for Choose Your Own Adventure and Interactive Fiction _drafting_.

* Planned Features:
* Return button goes back up to the previous tree.
* A list of all trees in the current project. By folder/name.
* Tooltips. Maybe.
* Allow the undoing of node Deletion.

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
