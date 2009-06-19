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
	import org.openvideoplayer.traits.MediaTraitType;
	
	import flash.events.Event;
	
	/**
	 * A MediaElement dispatches a TraitsChangeEvent when media traits are
	 * added to or removed from the media element. 
	 */
	public class TraitsChangeEvent extends MediaEvent
	{
		/**
		 * The MediaTraitEvent.TRAIT_ADD constant defines the value of the type
		 * property of the event object for a traitAdd event.
		 * 
		 * @eventType traitAdd
		 **/
		public static const TRAIT_ADD:String = "traitAdd";
		
		/**
		 * The MediaTraitEvent.TRAIT_REMOVE constant defines the value of the
		 * type property of the event object for a traitRemove event.
		 * 
		 * @eventType traitRemove
		 **/
		public static const TRAIT_REMOVE:String = "traitRemove";
		
		/**
		 * Constructor.
		 * 
		 * @param type The event type of the action that triggered this
		 * event. Valid values are "traitAdd" and "traitRemove".
		 * @param traitType The trait class for the trait that was added or removed, 
		 * such as <code>BUFFERABLE</code>, <code>PLAYABLE</code>, <code>SEEKABLE</code>.
 		 * @param bubbles Specifies whether the event can bubble up the display
 		 * list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the
 		 * event can be prevented. 
		 **/
		public function TraitsChangeEvent(type:String, traitType:MediaTraitType, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			_traitType = traitType;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 **/
		override public function clone():Event
		{
			return new TraitsChangeEvent(type, traitType);
		}
		
		/**
		 * The trait class for this event.
		 **/
		public function get traitType():MediaTraitType
		{
			return _traitType;
		}
		
		// Internals
		//
		
		private var _traitType:MediaTraitType;
	}
}