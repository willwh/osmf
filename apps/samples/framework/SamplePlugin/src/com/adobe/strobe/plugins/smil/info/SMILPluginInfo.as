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
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.plugin.PluginInfo;
	
	public class SMILPluginInfo extends PluginInfo
	{
		/**
		 * Constructor
		 */
		public function SMILPluginInfo()
		{
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			
			var smilLoader:SMILLoader = new SMILLoader();
			var mediaInfo:MediaInfo = new MediaInfo("com.adobe.smil.SMIL", smilLoader, createSMILElement);

			mediaInfos.push(mediaInfo);
			
			super(mediaInfos, "0.9.0");
		}
		
		private function createSMILElement():MediaElement
		{
			return new SMILElement(new SMILLoader());
		}
	}
}