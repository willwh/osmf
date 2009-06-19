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
	 * A trait that implements the IAudible interface dispatches
	 * this event when its <code>volume</code> property has changed.
	 */	
	public class VolumeChangeEvent extends TraitEvent
	{
		/**
		 * The VolumeChangeEvent.VOLUME_CHANGE constant defines the value
		 * of the type property of the event object for a volumeChange
		 * event.
		 * 
		 * @eventType VOLUME_CHANGE 
		 */	
		public static const VOLUME_CHANGE:String = "volumeChange";
		
		/**
		 * Constructor
		 * 
		 * @param oldVolume Previous volume.
		 * @param newVolume New volume.
		 */		
		public function VolumeChangeEvent(oldVolume:Number, newVolume:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldVolume = oldVolume;
			_newVolume = newVolume;
			
			super(VOLUME_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old <code>volume</code> value before it was changed. 
		 */		
		public function get oldVolume():Number
		{
			return _oldVolume;
		}
		
		/**
		 * New <code>volume</code> value resulting from this change.
		 */		
		public function get newVolume():Number
		{
			return _newVolume;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new VolumeChangeEvent(_oldVolume,_newVolume,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _oldVolume:Number;
		private var _newVolume:Number;
		
	}
}