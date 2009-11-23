Sample Application: AkamaiPluginSample

A. Overview

This sample application demonstrates loading the Akamai plugin and the MAST plugin within the OSMF framework. 
Its purpose is to demonstrate loading the plugins dynamically and statically as well as demonstrate the functionality
of the plugins.

The Akamai plugin handles secure streaming for both live and on-demand content over the Akamai network.  
There is a sample stream containing an auth token in the sample.

The MAST plugin loads a MAST document, parses it, and loads it's payload (a VAST document containing a sample ad pre-roll).
You will see an ad pre-roll before each video when this plugin is loaded.  In the "loadMedia" function, you can see
the URL of the MAST document being set as metadata on the media element's resource.

B. Installation Instructions (Flex Builder)

1. Unzip/copy the AkamaiPluginSample project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Browse to your Flex Builder workspace folder.
4. Click "Finish". This will import the project.
5. Build the project.
6. Launch the application from the Run menu.*

C. Usage Instructions

* IMPORTANT NOTE: Due to Flash Player security, you will not be able to load the plugins dynamically unless you 
run the sample app from a Web server or localhost, i.e., "http://localhost/AkamaiPluginSample.html".
