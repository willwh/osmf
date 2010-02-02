package org.osmf.plugin
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.NetLoader;
	import org.osmf.video.VideoElement;
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