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
package org.openvideoplayer.media
{
	/**
      *  The MediaPlayerState class enumerates public constants that describe the the current state of the
      *  Media Player. 

      */
    public class MediaPlayerState
    {
		/**
		  * Constructor.
		  * @private
		 **/        	
		public function MediaPlayerState(state:String):void
		{
			this.state = state;
        }
              
		/**
		  * The MediaPlayer has been created but is not ready to be used.
		  * This is the base state for a MediaPlayer.
		  */
		public static const CONSTRUCTED:MediaPlayerState   = new MediaPlayerState('constructed');

		/**
		 * The MediaPlayer is loading or connecting.
		 */
		public static const INITIALIZING:MediaPlayerState  = new MediaPlayerState('initializing');

		/**
		  * The MediaPlayer is ready to be used.
		  */
		public static const INITIALIZED:MediaPlayerState = new MediaPlayerState('initialized');

		/**
	     * The MediaPlayer is playing media.
         */
		public static const PLAYING:MediaPlayerState = new MediaPlayerState('playing');

		/**
          * The MediaPlayer is pausing media.
		  */
		public static const PAUSED:MediaPlayerState = new MediaPlayerState('paused');

		/**
		 * The MediaPlayer is seeking.
		 */
		public static const SEEKING:MediaPlayerState = new MediaPlayerState('seeking');

		/**
		 * The MediaPlayer is buffering.
		 */
		public static const BUFFERING:MediaPlayerState = new MediaPlayerState('buffering');

		/**
		  * The MediaPlayer encountered an error while trying to play media.
		  */
		public static const PLAYBACK_ERROR:MediaPlayerState = new MediaPlayerState('playbackError');
             
		private var state:String;
	} 
}