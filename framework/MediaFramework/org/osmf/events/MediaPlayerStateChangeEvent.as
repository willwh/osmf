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
	
	import org.osmf.media.MediaPlayerState;

	/**
	 * A MediaPlayer dispatches this event when its state  
	 * has changed.
	 */		
	public class MediaPlayerStateChangeEvent extends Event
	{
		/**
		 * The MediaPlayerChangeEvent.MEDIA_PLAYER_STATE_CHANGE constant defines the value
		 * of the type property of the event object for a mediaPlayerStateChange
		 * event.
		 * 
		 * @eventType MEDIA_PLAYER_STATE_CHANGE
		 **/		
		public static const MEDIA_PLAYER_STATE_CHANGE:String = "mediaPlayerStateChange";

        /**
         *   Creates a new MediaPlayerStateChange event, capturing the new and old states.
         * 	@param newState New media player state.
         * 	@param oldState	Previous media player state.
        **/          
        public function MediaPlayerStateChangeEvent(newState:MediaPlayerState, oldState:MediaPlayerState)
        {
        	super(MEDIA_PLAYER_STATE_CHANGE);
            _newState = newState;
            _oldState = oldState;
        }
		/**
		 * New MediaPlayerState resulting from this change.
		 */		
        public function get newState():MediaPlayerState
        {
        	return _newState;
        }
		/**
		 * Old MediaPlayerState before it was changed.
		*/		           
        public function get oldState():MediaPlayerState
        {
        	return _oldState;
        }
           
        override public function clone():Event
        {
        	return new MediaPlayerStateChangeEvent(_newState, _oldState);
        }

		private var _newState:MediaPlayerState;
		private var _oldState:MediaPlayerState;
	}
}