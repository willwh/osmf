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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.PlayingChangeEvent;

	/**
	 * Dispatched when the trait's <code>playing</code> property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.PausedChangeEvent.PLAYING_CHANGE
	 */
	[Event(name="playingChange",type="org.openvideoplayer.events.PlayingChangeEvent")]

	/**
	 * The PlayableTraitBase class provides a base IPlayable implementation.
	 * It can be used as the base class for a more specific playable trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 */	

	public class PlayableTrait extends MediaTraitBase implements IPlayable
	{
		// Public Interface
		//
		
		/**
		 * Resets the <code>playing</code> property of the trait.
		 * Changes <code>playing</code> from <code>true</code> to 
		 * <code>false</code>.
		 * <p>Used after a call to <code>canProcessPlayingChange(true)</code> returns
		 * <code>true</code>.</p>
		 * 
		 * @see #canProcessPlayingChange()
		 * @see #processPlayingChange()
		 * @see #postProcessPlayingChange()
		 */		
		final public function resetPlaying():void
		{
			if (_playing == true && canProcessPlayingChange(false))
			{
				processPlayingChange(false);
					
				_playing = false;
					
				postProcessPlayingChange(true);
			}
		}
		
		// IPlayable
		//
		
		/**
		 * @inheritDoc
		 */
		public function get playing():Boolean
		{
			return _playing;
		}
		
		/**
		 * @inheritDoc
		 */
		final public function play():void
		{
			if (_playing == false)
			{
				if (canProcessPlayingChange(true))
				{
					processPlayingChange(true);
					
					_playing = true;
					
					postProcessPlayingChange(false);
				}
			}
		}
		
		// Internals
		//
		
		private var _playing:Boolean;
		
		/**
		 * Called before the <code>playing</code> property value
		 * is changed.
		 *
		 * @param newPlaying Proposed new <code>playing</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override this method
		 * can return <code>false</code> to abort the change. 
		 * 
		 */		
		protected function canProcessPlayingChange(newPlaying:Boolean):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>playing</code> property value is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p> 
		 *
		 * 
		 */
		protected function processPlayingChange(newPlaying:Boolean):void
		{
		}
		
		/**
		 * Called just after the <code>playing</code> property value
		 * has changed. Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the playingChange event.</p>
		 *  
		 * @param oldPlaying Previous value of <code>playing</code>.
		 * 
		 */		
		protected function postProcessPlayingChange(oldPlaying:Boolean):void
		{
			dispatchEvent(new PlayingChangeEvent(_playing));
		}
	}
}