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
	import org.openvideoplayer.media.IMediaInfo;
	
	/**
	 * IPluginInfo is the encapsulation of the set of IMediaInfo objects
	 * that will be available to the application after the plugin has been
	 * successfully loaded.
	 * Every Strobe plugin must implement this interface
	 * to provide the application with the information it needs
	 * to create and load the plugin's MediaElement.
	 * <p>
	 * From the point of view of the Strobe media framework,
	 * the plugin's purpose is to expose the IMediaInfo
	 * objects that represent the media that the plugin handles.
	 * These MediaInfo objects could describe standard media types such as
	 * video, audio, or image that can be represented by the built-in Strobe
	 * MediaElements: VideoElement, AudioElement, or ImageElement.
	 * More likely, a plugin provides some type of specialized processing,
	 * such as a custom loader or special-purpose media element with
	 * customized traits. 
	 * For example, a plugin that provides tracking might implement
	 * a TrackingCompositeElement that includes a customized loader and customized
	 * IPlayable and IPausible trait implementations that start and stop tracking
	 * as well as the video.
	 * </p>
	 * <p>An IPluginInfo also gives the plugin an opportunity to accept or reject a specific
	 * Strobe version through its <code>isFrameworkVersionSupported()</code> method.</p>
	 * <p>A dynamic plugin is loaded at runtime from a SWF or SWC.
	 * A static plugin is compiled as part of the Strobe application.
	 * An application attempting to load a dynamic plugin accesses the class
	 * that implements IPluginInfo through
	 * the <code>pluginInfo</code> property on the root of the plugin SWF.
	 * If this class is not found,
	 * the plugin is not loaded.
	 * An application attempting to load a static plugin instantiates a class
	 * from the class reference
	 * of its PluginClassResource class
	 * and casts the instance to a PluginInfo. </p>
	 * <p>The following code ilustrates a very simple IPluginInfo implementation:</p>
	 * <listing>
	 * public class SimpleVideoPluginInfo implements IPluginInfo
	 * {
	 * 		public function SimpleVideoPluginInfo()
	 * 		{
	 * 		}
	 * 
	 * 		// Returns the number of MediaInfo objects the plugin exposes.
	 * 		public function get numMediaInfos():int
	 * 		{
	 * 			return 1;
	 * 		}
	 * 
	 * 		// Returns the MediaInfo object at the specified index position.
	 * 		public function getMediaInfoAt(index:int):IMediaInfo
	 * 		{
	 * 			var netLoader:NetLoader = new NetLoader();
	 * 			return new MediaInfo("org.openvideoplayer.video.Video", netLoader,
	 * 				 VideoElement, new Array(netLoader));
	 * 		}
	 * 
	 * 		// Return if the plugin supports the specified version of the framework.
	 * 		public function isFrameworkVersionSupported(version:String):Boolean
	 * 		{
	 * 			return true;
	 * 		}
	 * }
	 * </listing>
	 * @see PluginClassResource
	 * @see PluginFactory
	 * @see org.openvideoplayer.media.IMediaInfo
	 */
	public interface IPluginInfo
	{
		/**
		 * Returns the number of IMediaInfo objects that the plugin
		 * exposes to the loading application.
		 */
		function get numMediaInfos():int;

		/**
		 * Used by the application to get the IMediaInfo object at the specified index.
		 * <p>If the index is out of range, the implementation should throw a
		 * RangeError.</p>
		 * <p>	
		 * The following code shows how an application that uses plugins
		 * could request the IMediaInfo objects for the plugins' media.
		 * </p>
		 * <listing>
		 * for (var i:int = 0; i &lt; pluginInfo.numMediaInfos; i++)
		 * {
		 * 	var mediaInfo:IMediaInfo = pluginInfo.getMediaInfoAt(i);
		 * 
		 * 	//process the IMediaInfo 
		 * }
		 * </listing>
		 * @param index Zero-based index position of the requested IMediaInfo.
		 * @return An IMediaInfo object representing media to be loaded.
		 * @see RangeError
		 */
		function getMediaInfoAt(index:int):IMediaInfo;
		
		/**
		 * Returns <code>true</code> if the plugin supports the specified version
		 * of the framework, in which case the loading application loads the plugin.
		 * Returns <code>false</code> if the plugin does not support the specified version
		 * of the framework, in which case the loading application does not load the plugin.
		 * @param version Version string of the Strobe framework version.
		 * @return Returns <code>true</code> if the version is supported.
		 */
		function isFrameworkVersionSupported(version:String):Boolean;
	}
}