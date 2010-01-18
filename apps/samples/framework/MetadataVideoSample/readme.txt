Sample Application: MetadataVideoSample

A. Overview

This sample application demonstrates how to use resource-level metadata to ensure that the MediaFactory
creates the MediaElement encapsulated by a plugin rather than a default MediaElement. 

B. Installation Instructions (Flex Builder)

1. Unzip/copy the MetadataVideoSample project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "MetadataVideoSample", and click "Finish".  This will import the project.
7. Build the project.
8. Launch the application from the Run menu.

Note that the sample loads assets from the web, so please make sure to be connected to the
internet when trying them out.

C. Usage Instructions

Run the sample app.  You should get an Alert message that indicates that "No MediaElement could be created
for the input resource".  Uncomment the commented out line in MainWindow.loadMedia(), then run the sample
app again.  This time, the video should load and begin playback.