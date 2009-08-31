Sample Application: ChromelessFlexPlayer

A. Overview

This application is a Flex-based SWF that represents a chromeless SWF video player.  It is used by the
ExamplePlayer aplication to demonstrate how a SWF that exposes its own API can be loaded and controlled
by wrapping the API-specific calls in a subclass of SWFElement.

The compiled SWF has also been posted publicly, and the URL of that SWF is referenced within the
ExamplePlayer application, so there's no need to compile and run this application (unless you want
to modify the chromeless SWF to look or behave differently).

B. Installation Instructions (Flex Builder)

Note: These instructions are only necessary if you want to modify the SWF used in the ExamplePlayer
application.

1. Unzip/copy the ChromelessFlexPlayer project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "ChromelessFlexPlayer", and click "Finish".  This will import the project.
7. Build the project.
8. Copy the ChromelessFlexPlayer.swf file from the bin (or bin-debug) folder to your web server.
9. In the ExamplePlayer application, modify the CHROMELESS_SWF_FLEX URL in AllExamples.as to point to
   the location of the SWF on your web server.
10. Follow the instructions in ExamplePlayer's readme file to run the ExamplePlayer application.
 
C. Usage Instructions

See ExamplePlayer's readme file for usage instructions.
