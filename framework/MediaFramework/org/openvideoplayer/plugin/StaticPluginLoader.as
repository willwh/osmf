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
package org.openvideoplayer.plugin
{
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	
	internal class StaticPluginLoader extends PluginLoader
	{
		/**
		 * Constructor
		 */
		public function StaticPluginLoader(mediaFactory:MediaFactory)
		{
			super(mediaFactory);
		}

		/**
		 * Indicates if this loader can handle the given resource.
		 * 
		 * The resource that's passed in needs to be of type <code>ClassResource</code>
		 * for static plugins. If the class reference points to a <code>Class</code>
		 * that can be successfully instantiated and implements IPluginInfo, 
		 */
	    override public function canHandleResource(resource:IMediaResource):Boolean
	    {
	    	return (resource is PluginClassResource);
	    }
	    
		override public function load(loadable:ILoadable):void
		{
			// Check for invalid state.
			validateLoad(loadable);

			updateLoadable(loadable, LoadState.LOADING);

			var classResource:PluginClassResource = loadable.resource as PluginClassResource; 	
			var pluginInfo:IPluginInfo = new classResource.pluginInfoRef();
			
			loadFromPluginInfo(loadable, pluginInfo);
		}
	}
}