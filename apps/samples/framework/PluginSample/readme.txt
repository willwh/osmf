Sample Application: PluginSample

A. Overview

This sample application demonstrates the use of the loading of Strobe Plugins using the PluginManager. It also demonstrates the usage of
MediaResourceHandlerResolver to pick a MediaInfo from a list of candidate MediaInfo objects that are capable of handling a resource.

B. Installation Instructions (Flex Builder)

1. Unzip/copy the PluginSample project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "PluginSample", and click "Finish".  This will import the project.
7. Build the project.
8. Launch the application from the Run menu.

Note that to replicate a real runtime environment, the PluginSample should be launched from the 
network rather than the file system.  Here's how to do so.

1. Build the project.
2. Copy the PluginSample.swf file from the bin (or bin-debug) folder to your web server.
3. In Flex Builder, go to the Run menu and select "Run Configurations" (or "Debug Configurations").
4. Create a new configuration for the PluginSample project.
5. Under "URL or path to launch", uncheck the "Use defaults" checkbox.
6. In the "Run" (or "Debug") text box, enter the URL of the PluginSample.swf file on your web server.
7. Click the "Run" (or "Debug") button.  

C. Usage Instructions

There are two entry fields. The first one is the URL to the plugin to be loaded and the second one is the URL to the media resource to be
loaded. Both URLs should point to the network rather than the file system. 

Click the “Load Plugin” button to load the plugin. If the plugin is loaded successfully, the MediaInfo objects that are newly registered
from the plugin will be added to the table below. 

Click the “Load Media Resource” button to load and play the resource. 

Each MediaInfo object is associated with a priority value, which can be modified from the UI. The larger the value is the higher the
priority is. The priorities are used by the AppResourceHandlerResolver (AppResourceHandlerResolver.as) to pick the MediaInfo object used
to handle/load a resource.

D. What's new?

During sprint 7, the IDownloadable trait is introduced. Downloadable trait can be used with UI widgets such as progress bar or text fields to 
report download progress. PluginSample uses two text fields bytesDownloaded and bytesTotal to show downlaod progress. Downloadable
trait is supported by video, audio, image and SWF. However, only progressive audio and video have downloadable trait, streaming video 
and audio don't.