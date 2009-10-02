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
	import org.osmf.traits.MediaTraitType;
	
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