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
	import __AS3__.vec.Vector;
	
	import org.osmf.media.MediaInfo;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * PluginInfo is the encapsulation of the set of MediaInfo objects
	 * that will be available to the application after the plugin has been
	 * successfully loaded.
	 * Every Open Source Media Framework plugin must define a subclass of PluginInfo
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
	 * custom implementations of the traits. 
	 * For example, a plugin that provides tracking might implement
	 * a TrackingCompositeElement that includes a customized loader and a customized
	 * PlayTrait implementation that start and stop tracking
	 * as well as the video.
	 * </p>
	 * <p>A PluginInfo also gives the plugin an opportunity to accept or reject a specific
	 * Open Source Media Framework version through its <code>isFrameworkVersionSupported()</code> method.</p>
	 * <p>A dynamic plugin is loaded at runtime from a SWF or SWC.
	 * A static plugin is compiled as part of the Open Source Media Framework application.
	 * An application attempting to load a dynamic plugin accesses the class
	 * that extends PluginInfo through
	 * the <code>pluginInfo</code> property on the root of the plugin SWF.
	 * If this class is not found,
	 * the plugin is not loaded.
	 * An application attempting to load a static plugin accesses the PluginInfo
	 * exposed by the PluginInfoResource object.</p>
	 * <p>The following code illustrates a very simple PluginInfo implementation:</p>
	 * <listing>
	 * public class SimpleVideoPluginInfo extends PluginInfo
	 * {
	 * 		public function SimpleVideoPluginInfo()
	 * 		{
	 * 		}
	 * 
	 * 		private function createVideoElement():MediaElement
	 * 		{
	 * 			return new VideoElement(new NetLoader());
	 * 		}
	 * }
	 * </listing>
	 * @see PluginInfoResource
	 * @see org.osmf.media.MediaInfo
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class PluginInfo
	{
		/**
		 * Constructor.
		 * 
		 * @param mediaInfos Vector of MediaInfo objects that this plugin
		 * exposes.
		 * @param supportedFrameworkVersion The version of the framework
		 * that this plugin supports.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function PluginInfo(mediaInfos:Vector.<MediaInfo>, supportedFrameworkVersion:String)
		{
			super();
			
			this.mediaInfos = mediaInfos;
			this.supportedFrameworkVersion = supportedFrameworkVersion;
		}
		
		/**
		 * Returns the number of MediaInfo objects that the plugin
		 * exposes to the loading application.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get numMediaInfos():int
		{
			return mediaInfos.length;
		}
		
		/**
		 * Returns the version of the framework that this plugin was compiled against.  The
		 * current version can be obtained from org.osmf.utils.Version.version.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get frameworkVersion():String
		{
			return "0.9.0";
		}


		/**
		 * Used by the application to get the MediaInfo object at the specified index.
		 * <p>If the index is out of range, throws a
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
		 * 	  // process the MediaInfo 
		 * }
		 * </listing>
		 * @param index Zero-based index position of the requested MediaInfo.
		 * @return A MediaInfo object representing media to be loaded.
		 * @see RangeError
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function getMediaInfoAt(index:int):MediaInfo
		{
			if (index < 0 || index >= mediaInfos.length)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return mediaInfos[index] as MediaInfo;
		}
		
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
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			if (version == null || version.length == 0)
			{
				return false;
			}

			var inputVersion:Object = parseVersionString(version);
			var pluginVersion:Object = parseVersionString(supportedFrameworkVersion);
			
			return 		inputVersion.major > pluginVersion.major
					||	(	inputVersion.major == pluginVersion.major
						&&	( 	inputVersion.minor > pluginVersion.minor
							||	(	inputVersion.minor == pluginVersion.minor
								&&	inputVersion.subMinor >= pluginVersion.subMinor
								)
							)
						);
		}
		
		/**
		 * Data from the player passed to the plugin to initialize the plugin.
		 * This method is called before getMediaInfoAt or get numMediaInfos.
		 * 
		 * Subclasses can override this method to do custom initialization.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function initializePlugin(metadata:Metadata):void
		{
		}
		
		// Internals
		//
		
		private static function parseVersionString(version:String):Object
		{
			var versionInfo:Array = version.split(".");
			
			var major:int = 0;
			var minor:int = 0;
			var subMinor:int = 0;
			
			if (versionInfo.length >= 1)
			{
				major = parseInt(versionInfo[0]);
			}
			if (versionInfo.length >= 2)
			{
				minor = parseInt(versionInfo[1]);
			}
			if (versionInfo.length >= 3)
			{
				subMinor = parseInt(versionInfo[2]);
			}

			return {major:major, minor:minor, subMinor:subMinor};
		}
		
		private var mediaInfos:Vector.<MediaInfo>;
		private var supportedFrameworkVersion:String;
	}
}