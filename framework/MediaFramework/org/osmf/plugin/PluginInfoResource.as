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
package org.osmf.plugin
{
	import org.osmf.media.IMediaResource;
	import org.osmf.metadata.Metadata;
	
	/**
	 * PluginInfoResource implements IMediaResource for static 
	 * plugins. A static plugin is a plugin that is compiled within the application that uses it,
	 * in contrast to a dynamic plugin, which is loaded at runtime.
	 * 
	 * @see PluginInfo
	 */
	public class PluginInfoResource implements IMediaResource
	{
		
		/**
		 * Constructor. 
		 * <p>The default constructor must be able to instantiate the class
		 * referenced by <code>pluginInfoRef</code>.</p>
		 * @param pluginInfoRef Reference to an instance of PluginInfo.
		 * @param parameters the list of initialization paramerers
		 *  to pass to the IPlugin info once loaded
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function PluginInfoResource(pluginInfoRef:PluginInfo)
		{
			_pluginInfoRef = pluginInfoRef;		
		}
			
		/**
		 * Reference to the <code>PluginInfo</code> for this static plugin.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get pluginInfoRef():PluginInfo
		{
			return _pluginInfoRef;	
		}
	
			
		/**
		 *  @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get metadata():Metadata
		{
			if(!_metadata)
			{
				_metadata = new Metadata();
			}
			return _metadata;
		}

		private var _metadata:Metadata;	
		private var _pluginInfoRef:PluginInfo;
		
	}
}