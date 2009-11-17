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
		/**
		 * The PluginLoadEvent.PLUGIN_LOADED constant defines the value of the
		 * type property of the event object for a pluginLoaded event.
		 * 
		 * @eventType pluginLoaded
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const PLUGIN_LOADED:String		= "pluginLoaded";
		
		/**
		 * The PluginLoadEvent.PLUGIN_LOAD_FAILED constant defines the value of the
		 * type property of the event object for a pluginLoadFailed event.
		 * 
		 * @eventType pluginLoadFailed
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const PLUGIN_LOAD_FAILED:String	= "pluginLoadFailed";

		/**
		 * The PluginLoadEvent.PLUGIN_UNLOADED constant defines the value of the
		 * type property of the event object for a pluginUnloaded event.
		 * 
		 * @eventType pluginUnloaded
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const PLUGIN_UNLOADED:String		= "pluginUnloaded";
		
		/**
		 * Constructor.
		 * 
		 * @param type The type of the event.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
 		 * @param resource The resource representing the plugin.
		 **/
		public function PluginLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, resource:IMediaResource=null)
		{
			super(type, bubbles, cancelable);
			
			_resource = resource;
		}
		
		/**
		 * The resource representing the plugin.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get resource():IMediaResource
		{
			return _resource;
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new PluginLoadEvent(type, bubbles, cancelable, _resource);
		}
		
		// Internals
		//

		private var _resource:IMediaResource;
	}
}