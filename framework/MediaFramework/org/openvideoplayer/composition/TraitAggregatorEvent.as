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
package org.openvideoplayer.composition
{
	import flash.events.Event;
	
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	
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