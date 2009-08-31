Sample Application: ReferenceSample

A. Overview

This sample application demonstrates the use of an overlay SWF to control the main video.  The overlay
SWF's MediaElement implements the IMediaReferrer interface to gain a reference to the main VideoElement.
Vid  

B. Installation Instructions (Flex Builder)

1. Unzip/copy the ReferenceSample project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "ReferenceSample", and click "Finish".  This will import the project.
7. Build the project.
8. Launch the application from the Run menu.

Note that to replicate a real runtime environment, the ReferenceSample should be launched from the 
network rather than the file system.  Here's how to do so.

1. Build the project.
2. Copy the ReferenceSample.swf file from the bin (or bin-debug) folder to your web server.
3. In Flex Builder, go to the Run menu and select "Run Configurations" (or "Debug Configurations").
4. Create a new configuration for the ReferenceSample project.
5. Under "URL or path to launch", uncheck the "Use defaults" checkbox.
6. In the "Run" (or "Debug") text box, enter the URL of the ReferenceSample.swf file on your web server.
7. Click the "Run" (or "Debug") button.  

C. Usage Instructions

Click the Play button to play the video.  When you click on the SWF in the lower left corner (the orange
rectangle), the video will pause.  This is a simple example of how one MediaElement can reference
another MediaElement, either to listen or to control.  In a real-world scenario, the SWF (as represented
by org.openvideoplayer.model.ReferenceSWFElement) would be loaded from a plugin.
