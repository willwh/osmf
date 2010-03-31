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
package org.osmf.media
{
	import __AS3__.vec.Vector;
	
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.Version;
	
	/**
	 * PluginInfo is the encapsulation of the set of MediaFactoryItem objects
	 * that will be available to the application after the plugin has been
	 * successfully loaded.
	 * Every Open Source Media Framework plugin must define a subclass of PluginInfo
	 * to provide the application with the information it needs
	 * to create and load the plugin's MediaElement.
	 * <p>
	 * From the point of view of the Open Source Media Framework,
	 * the plugin's purpose is to expose the MediaFactoryItem
	 * objects that represent the media that the plugin handles.
	 * These MediaFactoryItem objects could describe standard media types such as
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
	 * 
	 * @see PluginInfoResource
	 * @see org.osmf.media.MediaFactoryItem
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class PluginInfo
	{
		/**
		 * Metadata namespace URL for a MediaFactory that is passed from player
		 * to plugin.  Client code can set this on the MediaResourceBase that
		 * is passed to MediaFactory.loadPlugin, and it will be exposed to the
		 * on the MediaResourceBase that is passed to PluginInfo.initializePlugin.
		 **/
		public static const PLUGIN_MEDIAFACTORY_NAMESPACE:String = "http://www.osmf.org/plugin/mediaFactory/1.0";

		/**
		 * Constructor.
		 * 
		 * @param mediaFactoryItems Vector of MediaFactoryItem objects that this plugin
		 * exposes.
		 * @param mediaElementCreationNotificationFunction Optional function which,
		 * if specified, is invoked for each MediaElement that is created from the
		 * MediaFactory to which this MediaFactoryItem is added.  If specified,
		 * the function must take one param of type MediaElement, and return void.
		 * This callback function is useful for MediaFactoryItems who want to be
		 * notified when other MediaElement are created (e.g. so as to listen to
		 * or control them).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function PluginInfo(mediaFactoryItems:Vector.<MediaFactoryItem>, mediaElementCreationNotificationFunction:Function=null)
		{
			super();
			
			this.mediaFactoryItems = mediaFactoryItems;
			_mediaElementCreationNotificationFunction = mediaElementCreationNotificationFunction;
		}
		
		/**
		 * Returns the number of MediaFactoryItem objects that the plugin
		 * exposes to the loading application.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get numMediaFactoryItems():int
		{
			return mediaFactoryItems.length;
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
			return Version.version;
		}


		/**
		 * Returns the MediaFactoryItem object at the specified index.
		 * <p>If the index is out of range, throws a
		 * RangeError.</p>
		 * @param index Zero-based index position of the requested MediaFactoryItem.
		 * @return A MediaFactoryItem object representing media to be loaded.
		 * @see RangeError
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function getMediaFactoryItemAt(index:int):MediaFactoryItem
		{
			if (index < 0 || index >= mediaFactoryItems.length)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return mediaFactoryItems[index] as MediaFactoryItem;
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

			var playerFrameworkVersion:Object = parseVersionString(version);
			var pluginFrameworkVersion:Object = parseVersionString(frameworkVersion);
			
			// A plugin supports the specified version if it's higher than or
			// the same as the plugin's version.
			return 		playerFrameworkVersion.major > pluginFrameworkVersion.major
					||	(	playerFrameworkVersion.major == pluginFrameworkVersion.major
						&&	( 	playerFrameworkVersion.minor >= pluginFrameworkVersion.minor
							)
						);
		}
		
		/**
		 * Data from the player passed to the plugin to initialize the plugin.
		 * This method is called before getMediaFactoryItemAt or get numMediaFactoryItems.
		 * 
		 * Subclasses can override this method to do custom initialization.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function initializePlugin(resource:MediaResourceBase):void
		{
		}
		
		/**
		 * Optional function which is invoked for every MediaElement that is
		 * created from the MediaFactory to which this plugin's MediaFactoryItem
		 * objects are added.  The function must take one param of type
		 * MediaElement, and return void. This callback function is useful for
		 * plugins who want to be notified when other MediaElement are created
		 * (e.g. so as to listen to or control them).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get mediaElementCreationNotificationFunction():Function
		{
			return _mediaElementCreationNotificationFunction;
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

			return {major:major, minor:minor};
		}
		
		private var mediaFactoryItems:Vector.<MediaFactoryItem>;
		private var _mediaElementCreationNotificationFunction:Function;
	}
}