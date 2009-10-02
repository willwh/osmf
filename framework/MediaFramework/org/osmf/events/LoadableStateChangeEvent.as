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
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	
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
