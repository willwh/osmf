Sample Application: MetadataSample

A. Overview

The metadata sample application is designed to show how Metadata can be monitored and used in an application.  
The application uses Metadata at both the IMediaResource level as well as the MediaElement level. The 
IMediaResource metadata is used by the MediaFactory to instantiate the correct MediaElement, based off of 
the IMediaResource's metadata.  The MediaElement level Metadata is shown in the Metadata inspector in the 
lower right on the application.  The metadata inspector shows metadata when it is added to a MediaElement.
There is an example Metadata proxy that adds metadata to the VideoElement.  This demonstrates how someone 
can write a proxy to populate various MediaElements in a composition with different metadata from different
sources.   

B. Installation Instructions (Flex Builder)

1. Unzip/copy the MetadataSample project into your Flex Builder workspace folder. 
2. In Flex Builder, go to the File menu and select "Import".
3. Select "General", then "Existing Projects into Workspace", and click "Next".
4. Choose "Select root directory" and "Browse".
5. Browse to your Flex Builder workspace folder.
6. Select the checkbox next to "MetadataSample", and click "Finish".  This will import the project.
7. Build the project.
8. Launch the application from the Run menu.

C. Usage Instructions

The MetadataSample requires the MediaFramework to be imported into you workspace - or to use the precompiled
MediaFramework SWC in your project.   The Metadata sample is a Flex project, and does need the free Flex SDK 
located at opensource.adobe.com.  Once the MetadataSample and MediaFramework have been imported into your 
workspace, it should compile and run.  The application has a URL input box, and a combo box with preset urls 
below it.  The user can give any url for any type of media, but Video is the only type with Metadata, from 
the MetadataProxy class.  The next box is the MediaType, which is required for the MediaFactory to properly 
create the media.  

The three buttons below the MediaType box are for creating MediaElements, serial compositions of three videos,
or a parallel composition of three videos.  Once a MediaElement is created with one of the buttons, it will 
show up in the MediaPlayer area above.  The Metadata, as it appears on the MediaElement will appear on the 
right side.  Editing, adding and removing of facets is possible with the buttons below the Facet list.  The 
Facet inspector also has key/value change functions at the bottom right of the application.  Adding an already 
existing value will replace it.  Adding, Removing, updating will use the text boxes key and value.  For more 
information on the Metadata list, facets, and merging metadata in compositions, see the metadata spec, as well 
as the Metadata ASDocs.

