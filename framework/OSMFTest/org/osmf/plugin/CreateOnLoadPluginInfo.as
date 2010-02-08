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
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.NetLoader;
	import org.osmf.elements.VideoElement;
	import org.osmf.utils.Version;

	public class CreateOnLoadPluginInfo extends PluginInfo
	{
		public function CreateOnLoadPluginInfo()
		{
			var item:MediaFactoryItem = new MediaFactoryItem("org.osmf.plugin.CreateOnLoadPlugin", new NetLoader().canHandleResource, createElement, MediaFactoryItemType.CREATE_ON_LOAD);
			var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
			items.push(item);
			
			super(items);
		}
		
		override public function initializePlugin(metadata:Metadata):void
		{
			_pluginMetadata = metadata;
		}
		
		public function get pluginMetadata():Metadata
		{
			return _pluginMetadata;
		}
		
		public function get createCount():Number
		{
			return _createCount;
		}
		
		private function createElement():MediaElement
		{
			_createCount++;
			return new VideoElement();			
		}
		
		private var _createCount:Number = 0;
		private var _pluginMetadata:Metadata;
	}
}