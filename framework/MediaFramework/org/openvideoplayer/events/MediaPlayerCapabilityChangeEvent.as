/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.events
{
	import flash.events.Event;
	
	/**
	 * A MediaPlayer dispatches a MediaPlayerCapabilityChangeEvent when its capabilities have changed.
	 */
	public class MediaPlayerCapabilityChangeEvent extends Event
	{
		/**
		 * The MediaPlayerCapabilityChangeEvent constants define the types of 
		 * changes that occur in a MediaPlayer's capabilities.
		 * 
		 * @eventType mediaStateChange
		 **/
			
			
		/**
		 * Dispatched when a MediaPlayer's ability to play media has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/	
		public static const PLAYABLE_CHANGE:String = "playableChange";

		/**
		 * Dispatched when a MediaPlayer's ability to pause media has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const PAUSIBLE_CHANGE:String = "pausibleChange";
		
		/**
		 * Dispatched when a MediaPlayer's ability to seek has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const SEEKABLE_CHANGE:String = "seekableChange";
	
		/**
		 * Dispatched when a MediaPlayer's ability to support media with
		 * a duration and a position
		 * relative to that duration has changed.
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const TEMPORAL_CHANGE:String = "temporalChange";
	
		/**
		 * Dispatched when a MediaPlayer's ability to support sound has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const AUDIBLE_CHANGE:String = "audibleChange";
	
		/**
		 * Dispatched when a MediaPlayer's ability to expose its media as a DisplayObject
		 * has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 * @see flash.display.DisplayObject
		 **/
		public static const VIEWABLE_CHANGE:String = "viewableChange";
	
		/**
		 * Dispatched when a MediaPlayer's ability to expose the intrinsic dimensions of
		 * its media has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const SPATIAL_CHANGE:String = "spatialChange";
		
		/**
		 * Dispatched when a MediaPlayer's ability to load media has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const LOADABLE_CHANGE:String = "loadableChange";
		
		/**
		 * Dispatched when a MediaPlayer's ability to buffer media has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const BUFFERABLE_CHANGE:String = "bufferableChange";
				
		/**
		 * Constructor.
		 * <p>The following statement creates an event indicating that the MediaPlayer
		 * no longer has the ability to buffer media.</p>
		 * <listing>
		 * event = new (MediaPlayerCapabilityChangeEvent("bufferableChange", false));
		 * </listing>
		 * <p>
		 * The next statement creates an event indicating that
		 * the MediaPlayer has acquired the ability to play media.
		 * </p>
		 * <listing>
		 * event = new (mediaPlayerCapabilityChangeEvent("playableChange", true));
		 * </listing>
		 * @param type Event name representing the capability that has changed.
		 * @param enabled Indicates whether the MediaPlayer has a particular capability
		 * as a result of the change described in the <code>type</code> parameter.
		 * Value of <code>true</code> means the player has the capability as a
		 * result of the change, 
		 * <code>false</code> means it does not.
		 **/
		public function MediaPlayerCapabilityChangeEvent
							( type:String, 
							  enabled:Boolean							  
							)
		{
			super(type);
			_enabled = enabled;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 **/
		override public function clone():Event
		{
			return new MediaPlayerCapabilityChangeEvent(type, _enabled);
		}
		
		/**
		 * Indicates whether the MediaPlayer has the capability
		 * described by the event.
		 **/
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		// Internals
		//
		
		private var _enabled:Boolean;
	}
}