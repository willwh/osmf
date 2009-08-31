Sample Application: ReferenceSampleSWF

A. Overview

This application is a SWF that displays an orange rectangle.  It is used by the ReferenceSample
application to demonstrate how one MediaElement can reference another MediaElement.

The compiled SWF has also been posted publicly, and the URL of that SWF is referenced within the
ReferenceSample application, so there's no need to compile and run this application (unless you want
to modify the overlay SWF to look or behave differently).

B. Installation Instructions (Flex Builder)

Note: These instructions are only necessary if you want to modify the SWF used in the ReferenceSample
application.

1. Unzip/copy the ReferenceSampleSWF project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "ReferenceSampleSWF", and click "Finish".  This will import the project.
7. Build the project.
8. Copy the ReferenceSampleSWF.swf file from the bin (or bin-debug) folder to your web server.
9. In the ReferenceSample application, modify the REMOTE_SWF URL in MainWindow.as to point to the location
   of the SWF on your web server.
10. Follow the instructions in ReferenceSample's readme file to run the ReferenceSample application.
 
C. Usage Instructions

See ReferenceSample's readme file for usage instructions.
