Sample Application: GGTrackingSample

A. Overview

This sample application demonstrates the use of a proxy plugin to do non-invasive tracking of another 
MediaElement using GlanceGuide's tracking service.  The important aspect of this example is that neither
the player application nor the tracking plugin need to be explicitly aware of each other.  The player
application simply loads the plugin, and the plugin simply declares what type of plugin it is (a proxy).
The framework is responsible for binding the player's video and the plugin's tracking code together.

IMPORTANT DISCLAIMER:  This sample application is primarily a CODE application rather than a useful
application.  The sample uses GlanceGuide's API to demonstrate how to post events within the context of
an OSMF proxy plugin.  We've made no attempt to actually perform the integration, nor validate that the
events actually get posted.  (In fact, they probably don't, since we're using dummy data for the most
part).

B. Installation Instructions (Flex Builder)

1. Unzip/copy the GGTrackingSample project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "GGTrackingSample", and click "Finish".  This will import the project.
7. Build the project.
8. Copy the GGTrackingSample.swf file from the bin (or bin-debug) folder to your web server.
9. In Flex Builder, go to the Run menu and select "Run Configurations" (or "Debug Configurations").
10. Create a new configuration for the GGTrackingSample project.
11. Under "URL or path to launch", uncheck the "Use defaults" checkbox.
12. In the "Run" (or "Debug") text box, enter the URL of the OverlaySample.swf file on your web server.
13. Click the "Run" (or "Debug") button.  

C. Usage Instructions

Upon launch, the application will load the GGTrackingPlugin, and then create a VideoElement from the
MediaFactory.  Because the plugin has been loaded, the VideoElement will be wrapped up by a custom
ProxyElement which listens for events from the VideoElement.  For example, if you click the Play button,
the custom ProxyElement (GGVideoProxyElement in the GGTrackingPlugin project) will receive a
PlayingChangeEvent.  To see this, you can place a breakpoint in the onPlayingChange or onPausedChange
methods of GGVideoProxyElement (or watch for the trace statements in these methods). 
