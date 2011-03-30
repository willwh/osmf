package org.osmf.net
{
	/**
	 * @private
	 * 
	 * MediaItem represents a part of a piece of media
	 * inside a StreamingURLResource.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.6
	 */	
	public class MediaItem
	{
		/**
		 * Default constructor
		 * 
		 * @param streamName The stream name that will be used when switching to alternate audio track.
		 * @param streamDescription The stream description contain user friendly description of the 
		 * 							stream ( for ex: the language of the stream )
		 * @param bitrate The stream's encoded bitrate in kbps.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function MediaItem(type:String, stream:String, bitrate:Number = 0, description:String = null, language:String = null  )
		{
			_type = type;
			_stream = stream;
			_bitrate = bitrate;
			_label = description;
			_language = language;
		}

		/**
		 * The stream type.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.6
		 */			
		public function get type():String
		{
			return _type;	
		}

		/**
		 * The stream url that will be used when switching to alternate audio track.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.6
		 */			
		public function get stream():String
		{
			return _stream;	
		}
		
		/**
		 * The stream description contain user friendly description of the 
		 * stream ( for ex: the language of the stream )
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.6
		 */			
		public function get label():String
		{
			return _label;	
		}
		
		/**
		 * The stream description contain language code of the stream
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.6
		 */			
		public function get language():String
		{
			return _language;	
		}

		/**
		 * The stream's bitrate, specified in kilobits per second (kbps).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get bitrate():Number
		{
			return _bitrate;
		}
		
		// Internals
		private var _type:String = null;
		private var _stream:String = null;
		private var _bitrate:Number;
		private var _label:String = null;
		private var _language:String = null;
	}
}