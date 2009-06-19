package org.openvideoplayer.plugin.video.media
{
	import flash.display.DisplayObject;
	import flash.display.BlendMode;
	
	import org.openvideoplayer.net.*;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.video.VideoElement;
	
	public class CustomVideoElement extends VideoElement
	{
		public function CustomVideoElement()
		{
		}
		
		override protected function processLoadedState():void
		{
			super.processLoadedState();
	
			customView =  IViewable(this.getTrait(MediaTraitType.VIEWABLE)).view;
			customView.alpha = 0.2;
			customView.blendMode = BlendMode.LAYER;
			trace("CustomVideoElement has processed loaded state");	
		}
		
		override protected function processUnloadingState():void
		{
			super.processUnloadingState();
			trace("CustomVideoElement has processed unloaded state");
		}
		
		private function onMetaData(info:Object):void 
    	{			
			trace("video dimesions : " + info.width + " : " + info.height);
			trace("video duration : " + info.duration); 	 	
     	}
		
     		 
	 	// Traits	
	 		private var customView:DisplayObject; 	
	 	//private var customVideoView:DisplayObject;

	}
}