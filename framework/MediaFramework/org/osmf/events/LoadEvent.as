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
	public class LoadEvent extends TraitEvent
	{
		/**
		 * The LoadEvent.LOAD_STATE_CHANGE constant defines the value
		 * of the type property of the event object for a loadStateChange
		 * event.
		 * 
		 * @eventType loadStateChange
		 **/
		public static const LOAD_STATE_CHANGE:String = "loadStateChange";

		/**
		 * Constructor.
		 * 
		 * @param type Event type.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param loadState New LoadState of the ILoadable.
		 **/
		public function LoadEvent
							( type:String,
							  bubbles:Boolean=false,
							  cancelable:Boolean=false,
							  loadState:String=null
							)
		{
			super(type, bubbles, cancelable);
			
			_loadState = loadState;
		}
		
		/**
		 * @private
		 **/
		override public function clone():Event
		{
			return new LoadEvent(type, bubbles, cancelable, loadState);
		}

		/**
		 * New LoadState of the ILoadable.
		 **/
		public function get loadState():String
		{
			return _loadState;
		}
		
		// Internals
		//
		
		private var _loadState:String;
	}
}
