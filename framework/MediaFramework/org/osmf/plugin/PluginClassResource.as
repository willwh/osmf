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
	 * PluginClassResource implements IMediaResource for static 
	 * plugins. A static plugin is a plugin that is compiled within the application that uses it,
	 * in contrast to a dynamic plugin, which is loaded at runtime.
	 * 
	 * @see IPluginInfo
	 */
	public class PluginClassResource implements IMediaResource
	{
		
		/**
		 * Constructor. 
		 * <p>The default constructor must be able to instantiate the class
		 * referenced by <code>pluginInfoRef</code>.</p>
		 * @param pluginInfoRef Reference to a Class that implements IPluginInfo.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function PluginClassResource(pluginInfoRef:Class)
		{
			_pluginInfoRef = pluginInfoRef;			
		}
			
		/**
		 * Reference to the Class that implements <code>IPluginInfo</code> for this static plugin.
		 * This class must have a default constructor with no parameters
		 * This class is required to enable the successful loading of the static plugin.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get pluginInfoRef():Class
		{
			return _pluginInfoRef;	
		}
		
		/**
		 *  inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
		private var _pluginInfoRef:Class;
		
	}
}