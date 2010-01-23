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
	 * A MediaElementEvent is dispatched when properties of a MediaElement have changed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class MediaElementEvent extends Event
	{
		/**
		 * The MediaElementEvent.TRAIT_ADD constant defines the value of the type
		 * property of the event object for a traitAdd event.
		 * 
		 * @eventType traitAdd
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const TRAIT_ADD:String = "traitAdd";
		
		/**
		 * The MediaElementEvent.TRAIT_REMOVE constant defines the value of the
		 * type property of the event object for a traitRemove event.
		 * 
		 * @eventType traitRemove
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const TRAIT_REMOVE:String = "traitRemove";
		
		/**
		 * Constructor.
		 * 
		 * @param type Event type
		 * @param bubbles Specifies whether the event can bubble up the display
 		 * list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the
 		 * event can be prevented. 
		 * @param traitType The MediaTraitType for the trait that was added or removed,.
 		 *  
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10
 		 *  @playerversion AIR 1.5
 		 *  @productversion OSMF 1.0
 		 */
		public function MediaElementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, traitType:String=null)
		{
			super(type, bubbles, cancelable);

			_traitType = traitType;
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new MediaElementEvent(type, bubbles, cancelable, traitType);
		}
		
		/**
		 * The MediaTraitType for this event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get traitType():String
		{
			return _traitType;
		}
		
		// Internals
		//
		
		private var _traitType:String;
	}
}