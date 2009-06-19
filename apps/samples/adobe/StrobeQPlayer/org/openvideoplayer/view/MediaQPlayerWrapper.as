package org.openvideoplayer.view
{
	import com.adobe.strobe.players.MediaPlayerWrapper;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.openvideoplayer.composition.*;
	import org.openvideoplayer.events.BufferTimeChangeEvent;
	import org.openvideoplayer.events.BufferingChangeEvent;
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.video.VideoElement;
	
	public class MediaQPlayerWrapper extends MediaPlayerWrapper
	{
	
		
		[Bindable]
		public var videoHeight:Number;
		
		[Bindable]
		public var videoWidth:Number;
		
		
		
		public function MediaQPlayerWrapper()
		{
			super();		
		}
												
	
		
		protected function onLoadState(event:LoadableStateChangeEvent):void
		{
			if(event.newState == LoadState.LOADED)
			{
				trace("media Loaded");
			}			
		}
		
	
		protected function onBufferTimeChange(event:BufferTimeChangeEvent):void
		{
			trace("bufferTime change" + event.newTime.toString());
			if(bufferTime!= event.newTime)
			{
				bufferTime = event.newTime;
			}
		}



		public function traverseElement(compElement:MediaElement):void
		{	
			if(compElement is ParallelElement)
			{ 
				trace("this is parallelElement");
				var parallelElement:ParallelElement = compElement as ParallelElement;
				traverseParallelElement(parallelElement);
			}
			else if(compElement is SerialElement)
			{
				trace("this is SerialElement");
				var serialElement:SerialElement = compElement as SerialElement;
				for(var z:uint= 0; z < serialElement.numChildren; z++)
				{
					if(serialElement.getChildAt(z) is ParallelElement)
					{
						trace("parallel in serial");
						traverseParallelElement(serialElement.getChildAt(z));
					}
				}
			
			}	
		}
		
		private function traverseParallelElement(mediaElement:MediaElement):void
		{
			var parallelElement:ParallelElement = mediaElement as ParallelElement;
			var view1:DisplayObject;
			var view2:DisplayObject;
			var temp:MediaElement;
			var z:uint = 0;
			
			for(z=0; z < parallelElement.numChildren; z++)
			{
				temp = parallelElement.getChildAt(z);
				if(temp is VideoElement)
				{						
					var videoElement:VideoElement = temp as VideoElement;
					if(videoElement.hasTrait(MediaTraitType.VIEWABLE))
					{										
						if(view1 == null)
						{
							view1 =  IViewable(videoElement.getTrait(MediaTraitType.VIEWABLE)).view;
							view1.width = unscaledWidth/2;
							view1.height = unscaledHeight/2;	
	
							addChild(view1);	
						}
						else if(view2 == null)
						{
							view2 =  IViewable(videoElement.getTrait(MediaTraitType.VIEWABLE)).view;
							view2.width = unscaledWidth/2;
							view2.height = unscaledHeight/2;
							view2.x = unscaledWidth/2;	
	
							addChild(view2);	
						}
					}	
				}
			}
			
		}
		
	}
}