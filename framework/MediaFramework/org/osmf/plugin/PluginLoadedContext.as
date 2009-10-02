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
	import flash.display.Loader;
	
	import org.osmf.traits.ILoadedContext;
	
	/**
	 * This class represents the loaded context resulting from loading a plugin
	 */	
	internal class PluginLoadedContext implements ILoadedContext
	{
		public function PluginLoadedContext(_pluginInfo:IPluginInfo, _loader:Loader)
		{
			this._pluginInfo = _pluginInfo;
			this._loader = _loader;
		}
		
		/**
		 * Returns the <code>IPluginInfo</code> reference
		 */
		public function get pluginInfo():IPluginInfo
		{
			return _pluginInfo;
		}
	
		/**
		 * Returns the <code>Loader</code> used to load the plugin
		 */
		public function get loader():Loader
		{
			return _loader;
		}

		private var _pluginInfo:IPluginInfo;
		private var _loader:Loader;
	}
}