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
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	
	import flash.events.Event;
	
	/**
	 * A trait that implements the ILoadable interface dispatches
	 * this event when its load state has changed. 
	 */
	public class LoadableStateChangeEvent extends TraitEvent
	{
		/**
		 * The LoadableEvent.LOADABLE_STATE_CHANGE constant defines the value
		 * of the type property of the event object for a loadableStateChange
		 * event.
		 * 
		 * @eventType loadableStateChange
		 **/
		public static const LOADABLE_STATE_CHANGE:String = "loadableStateChange";

		/**
		 * Constructor.
		 * 
		 * @param oldState Previous state of the ILoadable.
		 * @param newState New state of the ILoadable.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 **/
		public function LoadableStateChangeEvent
							( oldState:LoadState,
							  newState:LoadState,
							  bubbles:Boolean=false,
							  cancelable:Boolean=false
							)
		{
			super(LOADABLE_STATE_CHANGE, bubbles, cancelable);
			
			_oldState = oldState;
			_newState = newState;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 **/
		override public function clone():Event
		{
			return new LoadableStateChangeEvent(oldState, newState);
		}

		/**
		 * The ILoadable to which this event applies.
		 **/
		public function get loadable():ILoadable
		{
			return target as ILoadable;
		}
		
		/**
		 * Previous state of the ILoadable.
		 **/
		public function get oldState():LoadState
		{
			return _oldState;
		}

		/**
		 * New state of the ILoadable.
		 **/
		public function get newState():LoadState
		{
			return _newState;
		}
		
		// Internals
		//
		
		private var _oldState:LoadState;
		private var _newState:LoadState;
	}
}
