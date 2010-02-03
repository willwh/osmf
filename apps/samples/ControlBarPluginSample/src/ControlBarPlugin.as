/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package
{
	import __AS3__.vec.Vector;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.utils.URL;

	public class ControlBarPlugin extends Sprite
	{
		/**
		 * Constructor
		 */
		public function ControlBarPlugin()
		{
			// Allow any SWF that loads this SWF to access objects and
			// variables in this SWF.
			Security.allowDomain("*");
			
			super();	
		}
		
		/**
		 * Gives the player the PluginInfo.
		 */
		public function get pluginInfo():PluginInfo
		{
			if (_pluginInfo == null)
			{
				var item:MediaFactoryItem
					= new MediaFactoryItem
						( ID
						, canHandleResourceCallback
						, mediaElementCreationCallback
						);
						
				var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
				items.push(item);
				
				_pluginInfo = new PluginInfo(items);	
			}
			
			return _pluginInfo;
		}
		
		// Internals
		//
		
		public static const ID:String = "org.osmf.samples.controlbar";
		public static const NS_CONTROL_BAR_SETTINGS:URL = new URL("http://www.osmf.org/samples/controlbar/settings");
		public static const NS_CONTROL_BAR_TARGET:URL = new URL("http://www.osmf.org/samples/controlbar/target");
		
		private var _pluginInfo:PluginInfo;
		
		private function canHandleResourceCallback(resource:MediaResourceBase):Boolean
		{
			var result:Boolean;
			
			if (resource != null)
			{
				var settings:KeyValueFacet
					= resource.metadata.getFacet(NS_CONTROL_BAR_SETTINGS)
					as KeyValueFacet;
					
				result = settings != null;
			}
			
			return result;	
		}
		
		private function mediaElementCreationCallback():MediaElement
		{
			return new ControlBarElement();
		}			
	}
}
