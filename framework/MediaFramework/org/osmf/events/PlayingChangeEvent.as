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
	 * A trait that implements the IPlayable interface dispatches
	 * this event when its <code>playing</code> property has changed.
	 */	
	public class PlayingChangeEvent extends TraitEvent
	{
		/**
		 * The PlayingChangeEvent.PLAYING_CHANGE constant defines the value
		 * of the type property of the event object for a playingChange
		 * event.
		 * 
		 * @eventType PLAYING_CHANGE  
		 */		
		public static const PLAYING_CHANGE:String = "playingChange";
		
		/**
		 * Constructor
		 * 
		 * @param playing New playing value.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function PlayingChangeEvent(playing:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_playing = playing;
			
			super(PLAYING_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * New value of <code>playing</code> resulting from this change. 
		 */		
		public function get playing():Boolean
		{
			return _playing;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new PlayingChangeEvent(_playing,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _playing:Boolean;
		
	}
}