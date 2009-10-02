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
package org.osmf.composition
{
	import flash.events.Event;
	
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * The TraitAggregator dispatches a TraitAggregatorEvent when media traits are
	 * aggregated or unaggregated by the aggregator. 
	 */
	internal class TraitAggregatorEvent extends Event
	{
		/**
		 * The TraitAggregatorEvent.TRAIT_AGGREGATED constant defines the value of the type
		 * property of the event object for a traitAdd event.
		 * 
		 * @eventType traitAdd
		 **/
		public static const TRAIT_AGGREGATED:String = "traitAggregated";
		
		/**
		 * The TraitAggregatorEvent.TRAIT_UNAGGREGATED constant defines the value of the
		 * type property of the event object for a traitRemove event.
		 * 
		 * @eventType traitRemove
		 **/
		public static const TRAIT_UNAGGREGATED:String = "traitUnaggregated";

		/**
		 * The TraitAggregatorEvent.LISTENED_CHILD_CHANGE constant defines the
		 * value of the type property of the event object for a
		 * listenedChildChange event.
		 * 
		 * @eventType traitRemove
		 **/
		public static const LISTENED_CHILD_CHANGE:String = "listenedChildChange";
		
		/**
		 * Constructor.
		 * 
		 * @param type The event type; indicates the action that triggered the
		 * event.
		 * @param traitType The trait type for this event.
		 * @param trait The trait for this event.  Should be null for events
		 * related to the listenedChild.
		 * @param oldListenedChild The previous value of listenedChild for the
		 * TraitAggregator.  Should be null for events related to aggregation.
		 * @param newListenedChild The new value of listenedChild for the
		 * TraitAggregator.  Should be null for events related to aggregation.
 		 * @param bubbles Specifies whether the event can bubble up the display
 		 * list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the
 		 * event can be prevented. 
		 **/
		public function TraitAggregatorEvent
			( type:String
			, traitType:MediaTraitType
			, trait:IMediaTrait
			, oldListenedChild:MediaElement=null
			, newListenedChild:MediaElement=null
			, bubbles:Boolean=false
			, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			_oldListenedChild = oldListenedChild;
			_newListenedChild = newListenedChild;
			
			_traitType = traitType;
			_trait = trait;
		}
		
		/**
		 * @inheritDoc
		 **/
		override public function clone():Event
		{
			return new TraitAggregatorEvent(type, _traitType, _trait, _oldListenedChild, _newListenedChild);
		}
		
		/**
		 * The trait type for this event.  Should be null for events related
		 * to the listenedChild.
		 **/
		public function get traitType():MediaTraitType
		{
			return _traitType;
		}
		
		/**
		 * The trait for this event.  Should be null for events related to
		 * the listenedChild.
		 **/
		public function get trait():IMediaTrait
		{
			return _trait;
		}
		
		/**
		 * The old value of listenedChild for the TraitAggregator.  Should be
		 * null for events related to aggregation.
		 **/
		public function get oldListenedChild():MediaElement
		{
			return _oldListenedChild;
		}

		/**
		 * The new value of listenedChild for the TraitAggregator.  Should be
		 * null for events related to aggregation.
		 **/
		public function get newListenedChild():MediaElement
		{
			return _newListenedChild;
		}
		
		// Internals
		//
		
		private var _traitType:MediaTraitType;
		private var _trait:IMediaTrait;
		private var _oldListenedChild:MediaElement;
		private var _newListenedChild:MediaElement;
	}
}