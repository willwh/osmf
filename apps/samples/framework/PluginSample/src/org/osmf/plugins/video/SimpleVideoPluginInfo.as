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
package org.osmf.plugins.video
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.video.VideoElement;
	
	public class SimpleVideoPluginInfo extends PluginInfo
	{
		public function SimpleVideoPluginInfo()
		{
			var netLoader:NetLoader = new NetLoader();
			var item:MediaFactoryItem = new MediaFactoryItem("org.osmf.video.SimpleVideoPlugin", netLoader.canHandleResource, createVideoElement);
			var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
			items.push(item);
			
			super(items);
		}
		
		private function createVideoElement():MediaElement
		{
			return new VideoElement();
		}
	}
}