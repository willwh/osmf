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
	import org.osmf.media.LoadableMediaElement;
	
	/**
	 * PluginElement is a MediaElement used for integrating
	 * external modules (plugins) into a Open Source Media Framework application to provide enhanced functionality.
	 * <p>A PluginElement can represent a dynamic plugin, which is loaded at runtime from a SWF or SWC,
	 * or a static plugin, which is compiled as part of the application.</p>
	 * <p>PluginElement extends <code>LoadableMediaElement</code> and has only 
	 * the <code>ILoadable</code> trait.</p>
	 * 
	 */
	internal class PluginElement extends LoadableMediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param resource Resource for the plugin code. For static plugins, 
		 * this is a PluginClassResource. 
		 * For dynamic plugins it is a IURLResource.
		 * @see PluginClassResource
		 * @see org.osmf.media.IURLResource
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function PluginElement(loader:PluginLoader, resource:IMediaResource=null)
		{
			super(loader, resource);			
		}
	}
}