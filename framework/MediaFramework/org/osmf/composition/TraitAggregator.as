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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;

	/**
	 * Dispatched when an IMediaTrait is aggregated by the TraitAggregator.
	 * This event is dispatched even if other aggregated media elements already
	 * have a trait of the same type.
	 *
	 * @eventType org.osmf.composition.TraitAggregatorEvent.TRAIT_AGGREGATED
	 **/
	[Event(name="traitAggregated",type="org.osmf.composition.TraitAggregatorEvent")]	

	/**
	 * Dispatched when an IMediaTrait is unaggregated by the TraitAggregator.
	 * This event is dispatched even if other aggregated media elements still
	 * have a trait of the same type.
	 *
	 * @eventType org.osmf.composition.TraitAggregatorEvent.TRAIT_UNAGGREGATED
	 **/
	[Event(name="traitUnaggregated",type="org.osmf.composition.TraitAggregatorEvent")]	

	/**
	 * Dispatched when the listened child changes.
	 *
	 * @eventType org.osmf.composition.TraitAggregatorEvent.LISTENED_CHILD_CHANGE
	 **/
	[Event(name="listenedChildChange",type="org.osmf.composition.TraitAggregatorEvent")]	

	/**
	 * The TraitAggregator provides a view into the traits for a collection
	 * of MediaElements.  A client of this class will add MediaElements to it,
	 * and can then perform operations (and receive events) related to all
	 * instances of the same trait across all MediaElements.
	 **/		 
	internal class TraitAggregator extends EventDispatcher
	{
		/**
		 * Constructor.
		 **/
		public function TraitAggregator()
		{
			childrenTraits = new Dictionary();		
		}
				
		/**
		 * The Listened child element will be the only element dispatching
		 * trait added / trait removed events.  forEachChildTrait and
		 * invokeOnEachChildTrait will operate on all children, regardless of
		 * the mode.  If this variable is set to null, no children will be
		 * listened to.
		 * 
		 * Dispatches trait removed / trait added events for the previous and
		 * new listenedChild's traits, respectively.
		 **/
		public function set listenedChild(value:MediaElement):void
		{
			if (value != _listenedChild)
			{
				var traitIndex:int = 0;
				var oldListenedChild:MediaElement = _listenedChild;
				
				if (_listenedChild)
				{
					_listenedChild.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdded);
					_listenedChild.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemoved);
					
					// Dispatch traitUnaggregated events for all traits.
					for (traitIndex = 0; traitIndex < _listenedChild.traitTypes.length; traitIndex++)
					{				
						var removingTraitType:MediaTraitType = _listenedChild.traitTypes[traitIndex];
						dispatchEvent
							( new TraitAggregatorEvent
								( TraitAggregatorEvent.TRAIT_UNAGGREGATED
								, removingTraitType
								, listenedChild.getTrait(removingTraitType)
								)
							);			
					}
				}
				
				_listenedChild = value;
				
				if (_listenedChild)
				{
					// Dispatch traitAggregated events for all traits.
					for (traitIndex = 0; traitIndex < _listenedChild.traitTypes.length; traitIndex++)
					{				
						var addingTraitType:MediaTraitType = _listenedChild.traitTypes[traitIndex];
						dispatchEvent
							( new TraitAggregatorEvent
								( TraitAggregatorEvent.TRAIT_AGGREGATED
								, addingTraitType
								, listenedChild.getTrait(addingTraitType)
								)
							);			
					}
	
					_listenedChild.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdded);
					_listenedChild.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemoved);
				}
				
				dispatchEvent
					( new TraitAggregatorEvent
						( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
						, null
						, null
						, oldListenedChild
						, _listenedChild
						)
					);
			}
		}
		
		public function get listenedChild():MediaElement
		{
			return _listenedChild;
		}
		
		/**
		 * Returns the next child after child which has the given trait.  If child is null,
		 * returns the first child with the given trait.
		 **/ 
		public function getNextChildWithTrait(child:MediaElement, traitType:MediaTraitType):MediaElement
		{
			var nextChild:MediaElement = null;
			
			var nextIsNextChild:Boolean = (child == null);
			for each (var mediaElement:MediaElement in childMediaElements)
			{
				if (mediaElement.hasTrait(traitType))
				{
					if (nextIsNextChild)
					{
						nextChild = mediaElement;
						break;
					}
					if (mediaElement == child)
					{
						nextIsNextChild = true;
					}
				}
			}
			
			return nextChild;
		}
		
		 /**
         *  Calls the method passed, and passes the trait as an argument.
         *  the signature of method should take one parameter, of type IMediaTrait.  Here is an example
         *  	function myMethod(trait:IMediaTrait):void
		 *  Invokes on all traits of type traitType on all children.
		 **/
		public function forEachChildTrait(method:Function, traitType:MediaTraitType):void
		{
			for each (var mediaElement:MediaElement in childMediaElements)
			{
				var trait:IMediaTrait = mediaElement.getTrait(traitType);
				if (trait != null)
				{
					method(trait);
				}
			}
		}
		
	    /**
         *  Calls the method named by method, and applies the arguments in args to each trait of children.
		 *  Invokes on all traits of type traitType on all children.
		 **/
		public function invokeOnEachChildTrait(method:String, args:Array, traitType:MediaTraitType):void	
		{			
			for each (var mediaElement:MediaElement in childMediaElements)
			{
				var trait:IMediaTrait = mediaElement.getTrait(traitType);
				if (trait != null)
				{
					var f:Function = trait[method];
					f.apply(trait, args);
				}
			}
		}
			
		/**
		 *	Returns true any children within this collection have the specified trait.
		 **/
		public function hasTrait(traitType:MediaTraitType):Boolean
		{
			return getNumTraits(traitType) > 0;
		}
		
		/**
		 * Returns the number of children within this collection that have the specified trait.
		 **/
		public function getNumTraits(traitType:MediaTraitType):int
		{
			var numTraits:int = 0;
			
			var mediaElements:Array = childrenTraits[traitType];
			for each (var mediaElement:MediaElement in mediaElements)
			{
				if (mediaElement.hasTrait(traitType))
				{
					numTraits++;
				}
			}
			
			return numTraits;			
		}
		
		/**
		 * Returns the number of MediaElements aggregated by the aggregator.
		 **/
		public function get numChildren():int
		{
			return childMediaElements.length;
		}
		
		/**
		 * Returns the child at the given index, null if no child exists at
		 * that index.
		 **/
		public function getChildAt(index:int):MediaElement
		{
			return childMediaElements[index];
		}
		
		/**
		 * Returns the index of the given child, -1 if the child is not known
		 * by the aggregator.
		 **/
		public function getChildIndex(child:MediaElement):int
		{
			return childMediaElements.indexOf(child);
		}
		
		/**
		 * Add a child, with traits to be aggregated.  Will cause trait added
		 * events to be dispatched.
		 **/			
		public function addChild(child:MediaElement):void
		{
			addChildAt(child, childMediaElements.length);
		}
					
		/**
		 * Add a child, with traits to be aggregated, at the given index.  Will
		 * cause trait added events to be dispatched.
		 **/			
		public function addChildAt(child:MediaElement, index:int):void
		{
			child.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdded);
			child.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemoved);
			
			childMediaElements.splice(index, 0, child);
			
			for each( var traitType:MediaTraitType in child.traitTypes)
			{				
				if (!childrenTraits[traitType])
				{					
					childrenTraits[traitType] = new Array();
				}
				childrenTraits[traitType].push(child);
				
				dispatchEvent
					( new TraitAggregatorEvent
						( TraitAggregatorEvent.TRAIT_AGGREGATED
						, traitType
						, child.getTrait(traitType)
						)
					);
			}
		}
		
		/**
		 * Remove a child, with traits to be aggregated.  Will cause trait removed events to be dispatched.
		 **/	
		public function removeChild(child:MediaElement):void
		{	
			child.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdded);
			child.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemoved);

			childMediaElements.splice(childMediaElements.indexOf(child), 1)
			
			for (var traitIndex:Number = 0; traitIndex < child.traitTypes.length; ++traitIndex)
			{
				var removingTraitType:MediaTraitType = child.traitTypes[traitIndex];
				
				var children:Array = childrenTraits[removingTraitType]; 
				children.splice(children.indexOf(child),1);
				
				dispatchEvent
					( new TraitAggregatorEvent
						( TraitAggregatorEvent.TRAIT_UNAGGREGATED
						, removingTraitType
						, child.getTrait(removingTraitType)
						)
					);		
			}						
		}
		
		/**
		 * Remove a child, with traits to be aggregated, from the given index.
		 * Will cause traits removed events to be dispatched.
		 **/
		public function removeChildAt(index:int):void
		{
			if (index < 0 || index >= childMediaElements.length)
			{
				throw new RangeError();
			}
			
			removeChild(childMediaElements[index]);
		}
		
		// Internal Implementation
		//
		
		private function onTraitRemoved(event:TraitsChangeEvent):void
		{
			var child:MediaElement = event.target as MediaElement;
			
			var children:Array = childrenTraits[event.traitType]; 
			children.splice(children.indexOf(child),1);
			
			dispatchEvent
				( new TraitAggregatorEvent
					( TraitAggregatorEvent.TRAIT_UNAGGREGATED
					, event.traitType
					, child.getTrait(event.traitType)
					)
				);
		}
		
		private function onTraitAdded(event:TraitsChangeEvent):void
		{
			var child:MediaElement = event.target as MediaElement;
			
			var trait:IMediaTrait = child.getTrait(event.traitType);
			if (!childrenTraits[event.traitType])
			{
				childrenTraits[event.traitType] = new Array();
			}
			childrenTraits[event.traitType].push(child);
			
			dispatchEvent
				( new TraitAggregatorEvent
					( TraitAggregatorEvent.TRAIT_AGGREGATED
					, event.traitType
					, trait
					)
				);
		}
		
		/**
		 * Dictionary of Arrays of type MediaElement, indexed by traitType.
		 * To access, do something like this:  
		 * 		var mediaElements:Array = childrenTraits[traitType];
		 * 		var trait:IMediaTrait = mediaElements[0].getTrait(traitType);
		 **/
		private var childrenTraits:Dictionary;
		
		private var childMediaElements:Array = new Array();
		
		private var _listenedChild:MediaElement;
	}
}
