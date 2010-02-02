/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.utils.URL;
	import org.osmf.video.VideoElement;

	/**
	 * Implementation of PluginInfo for a plugin that exposes a MediaFactoryItem
	 * which can only handle input resources that have a specific piece of
	 * metadata.
	 **/ 
	public class MetadataVideoPluginInfo extends PluginInfo
	{
		public function MetadataVideoPluginInfo()
		{		
			var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
			
			// Here is the function that checks for the presence of the piece of
			// metadata.  By passing it into the MediaFactoryItem, we ensure
			// that when this plugin is loaded into a player app, and the player
			// app attempts to dynamically instantiate a MediaElement, then this
			// plugin will create the MediaElement if the input resource has the
			// specific piece of metadata.
			var checkForMetadataFunction:Function = canHandleResource;
			
			var item:MediaFactoryItem = new MediaFactoryItem("my.example", checkForMetadataFunction, createVideoElement);
			items.push(item);
			
			super(items);
		}
		
		private function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var canHandle:Boolean = false;
			
			// Use a NetLoader to make sure we can handle the resource.
			var netLoader:NetLoader = new NetLoader();
			if (netLoader.canHandleResource(resource))
			{
				// Now check for the metadata.  We only want to handle the
				// resource if it has a specific piece of metadata.
				var kvFacet:KeyValueFacet = resource.metadata.getFacet(CUSTOM_NS) as KeyValueFacet;
				if (kvFacet != null)
				{
					// We could check that a specific key on the facet exists,
					// and that that key has a specific value.  But to keep
					// it simple, we return true based solely on the facet's
					// existence.
					canHandle = true; 
				}
			}
			
			return canHandle;
		}

		private function createVideoElement():MediaElement
		{
			return new VideoElement();
		}
		
		private static const CUSTOM_NS:URL = new URL("http://example.com/myCustomNS");
	}
}