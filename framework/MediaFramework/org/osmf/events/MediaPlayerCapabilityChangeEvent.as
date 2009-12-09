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
		 * The MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE constant defines
		 * the value of the type property of the event object for a playableChange
		 * event.
		 * 
		 * @eventType playableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const PLAYABLE_CHANGE:String = "playableChange";

		/**
		 * The MediaPlayerCapabilityChangeEvent.PAUSABLE_CHANGE constant defines
		 * the value of the type property of the event object for a pausableChange
		 * event.
		 * 
		 * @eventType pausableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const PAUSABLE_CHANGE:String = "pausableChange";
		
		/**
		 * The MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE constant defines
		 * the value of the type property of the event object for a seekableChange
		 * event.
		 * 
		 * @eventType seekableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const SEEKABLE_CHANGE:String = "seekableChange";
	
		/**
		 * The MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE constant defines
		 * the value of the type property of the event object for a temporalChange
		 * event.
		 * 
		 * @eventType temporalChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const TEMPORAL_CHANGE:String = "temporalChange";
	
		/**
		 * The MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE constant defines
		 * the value of the type property of the event object for a audibleChange
		 * event.
		 * 
		 * @eventType audibleChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const AUDIBLE_CHANGE:String = "audibleChange";
	
		/**
		 * The MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE constant defines
		 * the value of the type property of the event object for a viewableChange
		 * event.
		 * 
		 * @eventType viewableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const VIEWABLE_CHANGE:String = "viewableChange";
	
		/**
		 * The MediaPlayerCapabilityChangeEvent.SWITCHABLE_CHANGE constant defines
		 * the value of the type property of the event object for a switchableChange
		 * event.
		 * 
		 * @eventType switchableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const SWITCHABLE_CHANGE:String = "switchableChange";
	
		/**
		 * The MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE constant defines
		 * the value of the type property of the event object for a spatialChange
		 * event.
		 * 
		 * @eventType spatialChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const SPATIAL_CHANGE:String = "spatialChange";
		
		/**
		 * The MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE constant defines
		 * the value of the type property of the event object for a loadableChange
		 * event.
		 * 
		 * @eventType loadableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const LOADABLE_CHANGE:String = "loadableChange";
		
		/**
		 * The MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE constant defines
		 * the value of the type property of the event object for a bufferableChange
		 * event.
		 * 
		 * @eventType bufferableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const BUFFERABLE_CHANGE:String = "bufferableChange";
						
		/**
		 * The MediaPlayerCapabilityChangeEvent.DOWNLOADABLE_CHANGE constant defines
		 * the value of the type property of the event object for a downloadableChange
		 * event.
		 * 
		 * @eventType downloadableChange 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const DOWNLOADABLE_CHANGE:String = "downloadableChange";

		/**
		 * Constructor.
		 * 
		 * @param type Event type.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param enabled Indicates whether the MediaPlayer has a particular capability
		 * as a result of the change described in the <code>type</code> parameter.
		 * Value of <code>true</code> means the player has the capability as a
		 * result of the change, <code>false</code> means it does not.
		 **/
		public function MediaPlayerCapabilityChangeEvent
							( type:String
							, bubbles:Boolean=false
							, cancelable:Boolean=false
							, enabled:Boolean=false				  
							)
		{
			super(type, bubbles, cancelable);
			
			_enabled = enabled;
		}
		
		/**
		 * Indicates whether the MediaPlayer has the capability
		 * described by the event.
		 **/
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * @private
		 **/
		override public function clone():Event
		{
			return new MediaPlayerCapabilityChangeEvent(type, bubbles, cancelable, _enabled);
		}
		
		// Internals
		//
		
		private var _enabled:Boolean;
	}
}