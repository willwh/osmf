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