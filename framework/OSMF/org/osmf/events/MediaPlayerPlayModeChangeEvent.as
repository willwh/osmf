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
	 * A MediaPlayer dispatches this event when its playMode  
	 * has changed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */		
	public class MediaPlayerPlayModeChangeEvent extends Event
	{
		/**
		 * The MediaPlayerPlayModeChangeEvent.MEDIA_PLAYER_STATE_CHANGE constant defines the value
		 * of the type property of the event object for a mediaPlayerPlayModeChange
		 * event.
		 * 
		 * @eventType MEDIA_PLAYER_STATE_CHANGE
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public static const MEDIA_PLAYER_PLAY_MODE_CHANGE:String = "mediaPlayerPlayModeChange";

 		/**
		 * Constructor.
		 * 
		 * @param type Event type.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param playMode New MediaPlayerPlayMode of the MediaPlayer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
        public function MediaPlayerPlayModeChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, playMode:String=null)
        {
        	super(type, bubbles, cancelable);
        	
            _playMode = playMode;
        }
        
		/**
		 * New MediaPlayerPlayMode of the MediaPlayer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
        public function get playMode():String
        {
        	return _playMode;
        }
        
        /**
         * @private
         */
        override public function clone():Event
        {
        	return new MediaPlayerPlayModeChangeEvent(type, bubbles, cancelable, _playMode);
        }

		private var _playMode:String;
	}
}