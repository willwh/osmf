Sample Library: MediaPlayer

A. Overview

This sample library contains a Flex UIComponent wrapper for MediaPlayerSprite (and by extension,
MediaPlayer).  It is used in a number of sample applications.

B. Installation Instructions (Flex Builder)

Note: These instructions are only necessary if you want to modify the SWF used in the GGTrackingSample
application.

1. Unzip/copy the MediaPlayer project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "MediaPlayer", and click "Finish".  This will import the project.
7. Build the project.
8. Add the project to your own Flex application by selecting the Project menu, "Properties",
   "Flex Build Path", "Library Path", "Add Project", and select "MediaPlayer".
 
C. Usage Instructions

Use MediaPlayerWrapper (which extends UIComponent) in your Flex application.  You can assign a
MediaElement, set the ScaleMode, etc.
