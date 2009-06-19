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
	
	/**
	 * A trait that implements the ITemporal interface dispatches
	 * this event when its <code>duration</code> property has changed.
	 * 
	 */	
	public class DurationChangeEvent extends TraitEvent
	{
		/**
		 * The DurationChangeEvent.DURATION_CHANGE constant defines the value
		 * of the type property of the event object for a durationChange
		 * event.
		 */		
		public static const DURATION_CHANGE:String = "durationChange";
		
		/**
		 * Constructor.
		 *  
		 * @param oldDuration Previous duration in seconds.
		 * @param newDuration New duration in seconds.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function DurationChangeEvent(oldDuration:Number, newDuration:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldDuration = oldDuration;
			_newDuration = newDuration;
			
			super(DURATION_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old value of <code>duration</code> (in seconds) before it was changed.
		 */		
		public function get oldDuration():Number
		{
			return _oldDuration;
		}
		
		/**
		 * New value of <code>duration</code> (in seconds) resulting from this change.
		 */		
		public function get newDuration():Number
		{
			return _newDuration;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new DurationChangeEvent(_oldDuration,_newDuration,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _oldDuration:Number;
		private var _newDuration:Number;
		
	}
}