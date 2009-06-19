/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.plugin
{
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.LoadableMediaElement;
	
	/**
	 * PluginElement is a MediaElement used for integrating
	 * external modules (plugins) into a Strobe application to provide enhanced functionality.
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
		 * @param resource Resource for the plugin code. For static plugins, 
		 * this is a PluginClassResource. 
		 * For dynamic plugins it is a IURLResource.
		 * @see PluginClassResource
		 * @see org.openvideoplayer.media.IURLResource
		 */
		public function PluginElement(loader:PluginLoader = null, resource:IMediaResource = null)
		{
			super(loader, resource);			
		}
		

	}
}