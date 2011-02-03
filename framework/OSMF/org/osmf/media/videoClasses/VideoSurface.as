package org.osmf.media.videoClasses
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	
	CONFIG::PLATFORM import flash.display.Stage;
	CONFIG::MOCK	 import org.osmf.mock.Stage;
	
	CONFIG::LOGGING  import org.osmf.logging.Logger;	

	/**
	 * VideoSurface class wraps the display object where
	 * a video should be displayed.
	 */
	public class VideoSurface extends Sprite 
	{
		/**
		 * Default constructor.
		 */
		public function VideoSurface(useStageVideo:Boolean = true, createVideo:Function = null)
		{	
			if (createVideo != null)
			{
				this.createVideo = createVideo;
			}
			else
			{
				this.createVideo = function():Video{return new Video();};
			}
			
			if (useStageVideo)
			{
				register();
			}
			else
			{
				switchRenderer(this.createVideo());
			}
		}
		
		private function register()
		{
			if (videoSurfaceManager == null)
			{
				videoSurfaceManager = new VideoSurfaceManager();
			}
			videoSurfaceManager.registerVideoSurface(this);
		}
		/**
		 * Returns a VideoSurfaceInfo object whose properties contain statistics 
		 * about the surface state. The object is a snapshot of the current state.
		 */
		public function get info():VideoSurfaceInfo
		{
			return _info;	
		}
		
		/**
		 * Specifies a video stream to be displayed within the boundaries of the Video object in the application.
		 */
		public function attachNetStream(netStream:NetStream):void
		{
			this.netStream = netStream;
			if (currentVideoRenderer)
			{
				currentVideoRenderer.attachNetStream(netStream);
			}
		}
		
		/**
		 * Clears the image currently displayed in the Video object (not the video stream).
		 */ 
		public function clear():void
		{
			if (currentVideoRenderer)
			{
				if (currentVideoRenderer is Video)
				{
					currentVideoRenderer.clear();
				}
				else
				{
					// Flash Player limitation: there is no clear concept for StageVideo.
					// The snippet below is not 
					// currentVideoRenderer.viewPort = new Rectangle(0,0,0,0);

				}
			}
		}

		/**
		 * Indicates the type of filter applied to decoded video as part of post-processing.
		 */	
		public function get deblocking():int
		{
			return _deblocking;				
		}
		
		public function set deblocking(value:int):void
		{
			if (_deblocking != value)
			{
				_deblocking = value;
				if (currentVideoRenderer is Video)
				{
					currentVideoRenderer.deblocking = _deblocking;
				}
			}
		}
		
		/**
		 * Specifies whether the video should be smoothed (interpolated) when it is scaled.
		 */
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			if (_smoothing != value)
			{
				_smoothing = value;
				if (currentVideoRenderer is Video)
				{
					currentVideoRenderer.smoothing = _smoothing;
				}
			}
		}
		
		/**
		 * An integer specifying the height of the video stream, in pixels.
		 */
		public function get videoHeight():int
		{
			return currentVideoRenderer ? currentVideoRenderer.videoHeight : 0;
		}
		
		/**
		 * An integer specifying the width of the video stream, in pixels.
		 */
		public function get videoWidth():int
		{
			return currentVideoRenderer ? currentVideoRenderer.videoWidth : 0;
		}
		
		/// Overrides
		override public function set x(value:Number):void
		{
			super.x = value;
			surfaceRect.x = 0;	
			updateView();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			surfaceRect.y = 0;
			updateView();
		}
		
		override public function get height():Number
		{
			return surfaceRect.height;
		}
		
		override public function set height(value:Number):void
		{
			if (surfaceRect.height != value)
			{
				surfaceRect.height = value;
				updateView();
			}
		}
		
		override public function get width():Number
		{
			return surfaceRect.width;
		}
		
		override public function set width(value:Number):void
		{
			if (surfaceRect.width != value)
			{
				surfaceRect.width = value;
				updateView();
			}
		}
		
		// Internals	
		
		internal function updateView():void
		{
			if (currentVideoRenderer == null)
			{
				return;
			}
			
			if (currentVideoRenderer.hasOwnProperty("viewPort"))
			{
				var viewPort:Rectangle = new Rectangle();
				viewPort.topLeft = localToGlobal(surfaceRect.topLeft);
				viewPort.bottomRight = localToGlobal(surfaceRect.bottomRight);
				currentVideoRenderer["viewPort"] = viewPort;
			}
			else
			{			
				currentVideoRenderer.x = surfaceRect.x;
				currentVideoRenderer.y = surfaceRect.y;
				currentVideoRenderer.height = surfaceRect.height;
				currentVideoRenderer.width = surfaceRect.width;
			}			
		}
		
		internal function switchRenderer(renderer:*):void
		{		
			if (currentVideoRenderer == renderer)
			{
				return;
			}
			//removeChild(currentVideoRenderer);
			if (currentVideoRenderer)
			{				
				currentVideoRenderer.attachNetStream(null);
				if (currentVideoRenderer is DisplayObject)
				{
					removeChild(currentVideoRenderer);
				}
				else
				{
					currentVideoRenderer.viewPort = new Rectangle(0,0,0,0);					
				}
			}
			
			currentVideoRenderer = renderer;
			
			if (currentVideoRenderer)
			{
				currentVideoRenderer.attachNetStream(netStream);
				updateView();
				if (currentVideoRenderer is DisplayObject)
				{				
					addChild(currentVideoRenderer);
				}						
				currentVideoRenderer.addEventListener("renderState", onRenderState);
			}
		}
		
		private function onRenderState(event:Event):void
		{		
			updateView();
			//event.target.removeEventListener("renderState", onRenderState);
			if (event.hasOwnProperty("status"))
			{
				_info._renderStatus = event["status"];
			}
		}
	
		/**
		 * @private
		 * Internal surface used for actual rendering.
		 */
		
		internal static var videoSurfaceManager:VideoSurfaceManager = null;		
	
		internal var createVideo:Function;
		internal var video:Video = null;
		
		/** StageVideo instance used by this VideoSurface. 
		 * 
		 * Do not link to StageVideo, to avoid runtime issues older FP versions, < 10.2. 
		 */ 
		internal var stageVideo:* = null;
		
		
		
		private var currentVideoRenderer:* = null;
		private var _info:VideoSurfaceInfo = new VideoSurfaceInfo();		
		private var netStream:NetStream;
		/**
		 * @private
		 * Internal rect used for representing the actual size.
		 */
		private var surfaceRect:Rectangle = new Rectangle(0,0,0,0);
		
		private var _deblocking:int 	= 0;
		private var _smoothing:Boolean 	= false;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.media.videoClasses.VideoSurface");
		
	}
}