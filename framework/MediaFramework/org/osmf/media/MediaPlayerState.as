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
package org.osmf.media
{
	/**
     *  The MediaPlayerState class enumerates public constants that describe the current state of the
     *  Media Player.
     */
    public class MediaPlayerState
    {
		/**
		 * Constructor.
		 * 
		 * @private
		 **/        	
		public function MediaPlayerState(name:String)
		{
			_name = name;
        }
              
		/**
		 * The MediaPlayer has been created but is not ready to be used.
		 * This is the base state for a MediaPlayer.
		 */
		public static const UNINITIALIZED:MediaPlayerState   = new MediaPlayerState('uninitialized');

		/**
		 * The MediaPlayer is loading or connecting.
		 */
		public static const INITIALIZING:MediaPlayerState  = new MediaPlayerState('initializing');

		/**
		 * The MediaPlayer is ready to be used.
		 */
		public static const READY:MediaPlayerState = new MediaPlayerState('ready');

		/**
	     * The MediaPlayer is playing media.
         */
		public static const PLAYING:MediaPlayerState = new MediaPlayerState('playing');

		/**
         * The MediaPlayer is pausing media.
		 */
		public static const PAUSED:MediaPlayerState = new MediaPlayerState('paused');

		/**
		 * The MediaPlayer is buffering.
		 */
		public static const BUFFERING:MediaPlayerState = new MediaPlayerState('buffering');

		/**
		 * The MediaPlayer encountered an error while trying to play media.
		 */
		public static const PLAYBACK_ERROR:MediaPlayerState = new MediaPlayerState('playbackError');
		
		/**
		 * The name value of the state.
		 **/
		public function get name():String
		{
			return _name;
		}
             
		private var _name:String;
	} 
}