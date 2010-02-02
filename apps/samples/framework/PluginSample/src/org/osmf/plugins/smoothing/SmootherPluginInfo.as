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
package  org.osmf.plugins.smoothing
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.metadata.Metadata;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.utils.URL;

	/**
	 * The plugin info for the smoothing plugin.
	 */ 
	public class SmootherPluginInfo extends PluginInfo
	{
		public function SmootherPluginInfo()
		{
			var item:MediaFactoryItem = new MediaFactoryItem("com.adobe.osmf.example.smoother", new Smoother().canHandleResource, createMediaElement, MediaFactoryItemType.CREATE_ON_LOAD);
			var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
			items.push(item);
			
			super(items)
		}
				
		override public function initializePlugin(metadata:Metadata):void
		{
			if (metadata.getFacet(new URL("http://org.yourcompany/creation_params/")))
			{
				trace('Got resource metadata');
			}
		}
		
		private function createMediaElement():MediaElement
		{
			return new Smoother();
		}
	}
}