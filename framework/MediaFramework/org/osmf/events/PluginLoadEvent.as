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
package org.osmf.events
{
	import flash.events.Event;
	
	import org.osmf.media.IMediaResource;

	/**
	 * This class represents the events when a plugin is loaded, unloaded or fail to load. The 
	 * event is dispatched by the PluginManager.
	 */
	public class PluginLoadEvent extends Event
	{
		public static const PLUGIN_LOADED:String		= "pluginLoaded";
		public static const PLUGIN_LOAD_FAILED:String	= "pluginLoadFailed";
		public static const PLUGIN_UNLOADED:String		= "pluginUnloaded";
		
		public function PluginLoadEvent(type:String, resource:IMediaResource=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_resource = resource;
		}
		
		/**
		 * Get the resource that represents the plugin.
		 * 
		 * @return Returns the media resource that represents the plugin.
		 */ 
		public function get resource():IMediaResource
		{
			return _resource;
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new PluginLoadEvent(type, resource, bubbles, cancelable);
		}
		
		// Internals
		//

		private var _resource:IMediaResource;
	}
}