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
package org.osmf.events
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
		public static const PAUSABLE_CHANGE:String = "PausableChange";
		
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
		 * Dispatched when a MediaPlayer's ability to switchbetween multiple bitrate
		 * streams changes.
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 * @see flash.display.DisplayObject
		 **/
		public static const SWITCHABLE_CHANGE:String = "switchableChange";
	
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
		 * Dispatched when a MediaPlayer's ability to download data has changed. 
		 * 
		 * @eventType mediaPlayerCapabilityChangeEvent
		 **/
		public static const DOWNLOADABLE_CHANGE:String = "downaloadableChange";

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