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
package com.adobe.strobe.plugins.smil.info
{
	import com.adobe.strobe.plugins.smil.loader.SMILLoader;
	import com.adobe.strobe.plugins.smil.media.SMILElement;
	
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.plugin.IPluginInfo;
	
	public class SMILPluginInfo implements IPluginInfo
	{
		/**
		 * Constructor
		 */
		public function SMILPluginInfo()
		{
			logger = Log.getLogger("com.adobe.strobe.plugins.smil.info.SMILPluginInfo");
		}

		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register
		 */
		public function get numMediaInfos():int
		{
			return 1;
		}

		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position
		 */
		public function getMediaInfoAt(index:int):MediaInfo
		{
			if (logger != null && logger.debugEnabled)
			{
				logger.debug("MediaInfo with ID {0} has been created.", "com.adobe.smil.SMIL");
			}
			
			var smilLoader:SMILLoader = new SMILLoader();
			return new MediaInfo("com.adobe.smil.SMIL", smilLoader, createSMILElement);
		}
		
		/**
		 * Returns if the given version of the framework is supported by the plugin. If the 
		 * return value is <code>true</code>, the framework proceeds with loading the plugin. 
		 * If the value is <code>false</code>, the framework does not load the plugin.
		 */
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			if (logger != null && logger.debugEnabled)
			{
				logger.debug("OSMF version is: " + version);
			}
			
			return true;
		}
		
		private function createSMILElement():MediaElement
		{
			return new SMILElement(new SMILLoader());
		}
		
		// internal
		
		private var logger:ILogger;
	}
}