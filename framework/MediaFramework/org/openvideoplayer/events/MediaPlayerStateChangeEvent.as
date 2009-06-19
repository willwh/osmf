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
	
	import org.openvideoplayer.media.MediaPlayerState;

	/**
	 * A MediaPlayer dispatches this event when its state  
	 * has changed.
	 */		
	public class MediaPlayerStateChangeEvent extends Event
	{
		/**
		 * The MediaPlayerChangeEvent.PLAYER_STATE_CHANGE constant defines the value
		 * of the type property of the event object for a mediaPlayerStateChange
		 * event.
		 * 
		 * @eventType PLAYER_STATE_CHANGE
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

		   private var _newState:MediaPlayerState;
		   private var _oldState:MediaPlayerState;
	}
}