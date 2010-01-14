/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.smil
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.smil.loader.SMILLoader;
	import org.osmf.smil.media.SMILProxyElement;

	/**
	 * Encapsulation of the SMIL plugin.
	 */
	public class SMILPluginInfo extends PluginInfo
	{
		/**
		 * Constructor.
		 */
		public function SMILPluginInfo()
		{
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			
			var mediaInfo:MediaInfo = new MediaInfo("org.osmf.smil.SMILPluginInfo", new SMILLoader(new DefaultMediaFactory()), 
													createSMILProxyElement);
			mediaInfos.push(mediaInfo);
			
			super(mediaInfos, "0.9.0");
			
		}
		
		private function createSMILProxyElement():MediaElement
		{
			return new SMILProxyElement(new SMILLoader(new DefaultMediaFactory()));
		}
		
		private var mediaInfos:Vector.<MediaInfo>;
	}
}
