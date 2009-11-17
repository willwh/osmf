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
	import org.osmf.media.MediaInfo;
	
	/**
	 * IPluginInfo is the encapsulation of the set of MediaInfo objects
	 * that will be available to the application after the plugin has been
	 * successfully loaded.
	 * Every Open Source Media Framework plugin must implement this interface
	 * to provide the application with the information it needs
	 * to create and load the plugin's MediaElement.
	 * <p>
	 * From the point of view of the Open Source Media Framework,
	 * the plugin's purpose is to expose the MediaInfo
	 * objects that represent the media that the plugin handles.
	 * These MediaInfo objects could describe standard media types such as
	 * video, audio, or image that can be represented by the built-in Open Source Media Framework
	 * MediaElements: VideoElement, AudioElement, or ImageElement.
	 * More likely, a plugin provides some type of specialized processing,
	 * such as a custom loader or special-purpose media element with
	 * customized traits. 
	 * For example, a plugin that provides tracking might implement
	 * a TrackingCompositeElement that includes a customized loader and customized
	 * IPlayable and IPausable trait implementations that start and stop tracking
	 * as well as the video.
	 * </p>
	 * <p>An IPluginInfo also gives the plugin an opportunity to accept or reject a specific
	 * Open Source Media Framework version through its <code>isFrameworkVersionSupported()</code> method.</p>
	 * <p>A dynamic plugin is loaded at runtime from a SWF or SWC.
	 * A static plugin is compiled as part of the Open Source Media Framework application.
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
	 * 		public function getMediaInfoAt(index:int):MediaInfo
	 * 		{
	 * 			var netLoader:NetLoader = new NetLoader();
	 * 			return new MediaInfo("org.osmf.video.Video", netLoader,
	 * 				 createVideoElement);
	 * 		}
	 * 
	 * 		// Return if the plugin supports the specified version of the framework.
	 * 		public function isFrameworkVersionSupported(version:String):Boolean
	 * 		{
	 * 			return true;
	 * 		}
	 * 
	 * 		private function createVideoElement():MediaElement
	 * 		{
	 * 			return new VideoElement(new NetLoader());
	 * 		}
	 * }
	 * </listing>
	 * @see PluginClassResource
	 * @see PluginFactory
	 * @see org.osmf.media.MediaInfo
	 */
	public interface IPluginInfo
	{
		/**
		 * Returns the number of MediaInfo objects that the plugin
		 * exposes to the loading application.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get numMediaInfos():int;

		/**
		 * Used by the application to get the MediaInfo object at the specified index.
		 * <p>If the index is out of range, the implementation should throw a
		 * RangeError.</p>
		 * <p>	
		 * The following code shows how an application that uses plugins
		 * could request the MediaInfo objects for the plugins' media.
		 * </p>
		 * <listing>
		 * for (var i:int = 0; i &lt; pluginInfo.numMediaInfos; i++)
		 * {
		 * 	  var mediaInfo:MediaInfo = pluginInfo.getMediaInfoAt(i);
		 * 
		 * 	  //process the MediaInfo 
		 * }
		 * </listing>
		 * @param index Zero-based index position of the requested MediaInfo.
		 * @return A MediaInfo object representing media to be loaded.
		 * @see RangeError
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function getMediaInfoAt(index:int):MediaInfo;
		
		/**
		 * Returns <code>true</code> if the plugin supports the specified version
		 * of the framework, in which case the loading application loads the plugin.
		 * Returns <code>false</code> if the plugin does not support the specified version
		 * of the framework, in which case the loading application does not load the plugin.
		 * @param version Version string of the Open Source Media Framework version.
		 * @return Returns <code>true</code> if the version is supported.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function isFrameworkVersionSupported(version:String):Boolean;
	}
}