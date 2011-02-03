package org.osmf.media.videoClasses
{
	/**
	 * The VideoSurfaceInfo class specifies the variousstatistics related to a VideoSurface object
	 * and the underlying display. A VideoSurfaceInfo object is returned in response to the 
	 * <code>VideoSurface.info</code> call, which takes a snapshot of the current state
	 * and provides these statistics through the VideoSurfaceInfo properties.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 */
	public final class VideoSurfaceInfo
	{
		/** The available color spaces for displaying the video. */
		public function get colorSpace():String
		{
			return _colorSpace;
		}

		/** Indicates whether the video is being rendered (decoded and displayed) by hardware or software, or not at all */
		public function get renderStatus():String
		{
			return _renderStatus;
		}

		/** Indicates whether stage video is supported on the current device */
		public function get stageVideoAvailability():String
		{
			return _stageVideoAvailability;
		}

		internal var _stageVideoAvailability:String = "unavailable";		
		internal var _renderStatus:String = "unavailable";		
		internal var _colorSpace:String = "";
		
		// TODO: Not sure about this... if this is present we need to have a property 
		// indicating the current status as well as the availability in different display modes (normal, fullscreen).
		// This supports use cases where a video player developer needs to decide upon the use of 
		// fullScreenSourceRect.
		/** Indicates whether stage video is supported in Full Screen mode on the current device */
		//public var stageVideoFullScreenAvailability:String = "available";// StageVideoAvailability.AVAILABLE;
	}
}