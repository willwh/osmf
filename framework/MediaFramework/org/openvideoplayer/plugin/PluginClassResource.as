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
		 */
		public function PluginClassResource(pluginInfoRef:Class)
		{
			_pluginInfoRef = pluginInfoRef;
		}

		/**
		 * Reference to the Class that implements <code>IPluginInfo</code> for this static plugin.
		 * This class must have a default constructor with no parameters
		 * This class is required to enable the successful loading of the static plugin.
		 */
		public function get pluginInfoRef():Class
		{
			return _pluginInfoRef;	
		}

		private var _pluginInfoRef:Class;
	}
}