Sample Plugin: GGTrackingPlugin

A. Overview

This sample plugin demonstrates (via the GGTrackingSample application) the use of a proxy plugin to do
non-invasive tracking of another MediaElement using GlanceGuide's tracking service.  See the readme for
the GGTrackingSample application for more details.

IMPORTANT DISCLAIMER:  This sample application is primarily a CODE application rather than a useful
application.  The sample uses GlanceGuide's API to demonstrate how to post events within the context of
an OSMF proxy plugin.  We've made no attempt to actually perform the integration, nor validate that the
events actually get posted.  (In fact, they probably don't, since we're using dummy data for the most
part).

The compiled SWF has also been posted publicly, and the URL of that SWF is referenced within the
GGTrackingSample application, so there's no need to compile and run this application.

B. Installation Instructions (Flex Builder)

Note: These instructions are only necessary if you want to modify the SWF used in the GGTrackingSample
application.

1. Unzip/copy the GGTrackingPlugin project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "GGTrackingPlugin", and click "Finish".  This will import the project.
7. Before building the project, you'll need to include the GlanceGuide SWC or source code, and uncomment
   the commented-out line in GGVideoProxyElement.sendEvent.  Please contact GlanceGuide to obtain access
   to their library.  For licensing reasons, we cannot distribute the GlanceGuide SWC or source code with
   this sample.
8. Build the project.
9. Copy the GGTrackingPlugin.swf file from the bin (or bin-debug) folder to your web server.
10. In the GGTrackingSample application, modify the GG_PLUGIN_URL property in MainWindow.as to point to
    the location of the plugin SWF on your web server.
11. Follow the instructions in GGTrackingSample's readme file to run the GGTrackingSample application.
 
C. Usage Instructions

See GGTrackingSample's readme file for usage instructions.
