Sample Application: DRM Sample

A. Overview

This sample application demonstrates the use of the IContentProtectableTrait.   This is a feature of flash player 10.1.   10.1 is required
to be able to use the DRMManager, and the DRM API's.  The IContentProtectable trait is being used by the VideoElement.  The VideoElement makes
use of both the old NetStream based DRM as well as the newer DRMManager API.  The sample includes 4 examples, two anonymous and two credential based.
Each example started via a button on the main screen.   There are also two ways of using DRM, one is to use the DRM metadata outside of the File. 
The other is to use DRM metadata embedded within the media.   Included are examples of each type of authentication.   

B. Installation Instructions (Flex Builder)

1. Unzip/copy the ExamplePlayer project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "DRMSample", and click "Finish".  This will import the project.
7. Make sure to use a 10.1 compatible SDK (See the flash player page for more info).
8. Build the project.
9. Launch the application from the Run menu.

C. Usage Instructions

The DRMSample will load up a simple video player, with four buttons at the top.  the four buttons load the four different types of Protected video. 
 The controls at the bottom allow the video to be scrubbed, paused, rewound, etc..  The credentials dialog may appeat, in which the user is required
 to provide a username and password.    