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
package org.osmf.mast
{
	import __AS3__.vec.Vector;
	
	import org.osmf.mast.media.MASTProxyElement;
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginInfo;

	/**
	 * Encapsulation of a MAST plugin.
	 **/
	public class MASTPluginInfo extends PluginInfo
	{	
		/**
		 * Constructor.
		 */	
		public function MASTPluginInfo()
		{		
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			
			var resourceHandler:IMediaResourceHandler = new NetLoader();
			var mediaInfo:MediaInfo = new MediaInfo
				( "org.osmf.mast.MASTPluginInfo"
				, resourceHandler
				, createMASTProxyElement
				, MediaInfoType.PROXY
				);
			mediaInfos.push(mediaInfo);
			
			super(mediaInfos);
		}
		
		private function createMASTProxyElement():MediaElement
		{
			return new MASTProxyElement();
		}
	}
}
