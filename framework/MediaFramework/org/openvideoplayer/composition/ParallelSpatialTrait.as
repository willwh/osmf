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
package org.openvideoplayer.composition
{
	import flash.events.Event;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;

	/**
	 * Dispatched when the width and/or height of the ISpatial media has changed.
	 * 
	 * @eventType org.openvideoplayer.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.openvideoplayer.events.DimensionChangeEvent")]

	/**
	 * Implementation of ISpatial for parallel compositions.
	 * 
	 * ISpatial's composite trait behaves differently for parallel and serial
	 * compositions.
	 * 
	 * In the parallel scenario, one may argue that if two spatial elements are
	 * to express their aggregate dimensions, it suffices to take the highest
	 * height of the two, and the widest width of both elements. However, this
	 * merely calculates the minimal space that is required when both elements are
	 * placed on top of each other in such a way that there is an optimal overlap
	 * between the two.This is only useful information in the absence of a
	 * composite viewable trait.
	 *
	 * When a composite viewable trait is available on the composition, than the
	 * composition's spatial trait should reflect the bounds of the composition's
	 * view, for that reflects the real intrinsic width and height of the
	 * composition, correcly reflecting potential child translation, rotation and
	 * scaling.
	 * 
	 * A parallel composition is therefore considered spatial:
	 * 
	 * 	1.	if it has a sibling viewable trait, in which case the spatial trait
	 * 		exposes the unscaled width and height of the DisplayObject as it is
	 * 		exposed by the sibling viewable trait, or
	 * 	2.	if it has no sibling viewable trait, but one or more children that
	 * 		expose the spatial trait, in which case the trait will reflect the
	 * 		highest height as well as the widest width found amongst all of those
	 * 		children that expose the spatial trait.
 	 */	
	internal class ParallelSpatialTrait extends CompositeMediaTraitBase implements ISpatial
	{
		/**
		 * Constructor.
		 * 
		 * Note that this trait implementation takes a reference to its owner. The trait
		 * needs this reference to watch its owner for obtaining or loosing a viewable
		 * trait.
		 * 
		 * @param traitAggregator
		 * @param owner
		 * 
		 */		
		public function ParallelSpatialTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(MediaTraitType.SPATIAL, traitAggregator);
			
			this.owner = owner;
			
			// In parallel mode, we use the owner property to monitor for a
			// viewable sibling becoming available.
			
			// If a sibling viewable is available, then we pull the spatial
			// characteristics of that sibling. We do so by having
			// CompositeViewableTrait implementing the spatial trait in 
			// addition to the viewable trait.
			
			owner.addEventListener
				( TraitsChangeEvent.TRAIT_ADD
				, onOwnerAddTrait
				, false, 0, true
				);
			
			owner.addEventListener
				( TraitsChangeEvent.TRAIT_REMOVE
				, onOwnerRemoveTrait
				, false, 0, true
				);
				
			updateViewableSibling(owner.getTrait(MediaTraitType.VIEWABLE));
			
			if (viewableSibling == null)
			{
				// If no viewable sibling is available, then we need to
				// monitor all our spatial children for change, and reflect
				// the maximum width and height found amongst our children
				// as our own intrinsic width and height:
				
				toggleChildSpatialListeners(true);
				
				calculateDimensions();
			}
		}
		
		// ISpatial
		//
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
	
		// Overrides
		//
		
		/**
		 * Invoked when a new spatial child trait becomes available.
		 */		
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			// If our dimenions are not determined by a sibling viewable,
			if (viewableSibling == null)
			{
				// ... then listen to this trait's dimensions changing,
				registerChildSpatialListener(child as ISpatial);
				
				// and update our current dimensions to include those of the
				// trait that just got added:
				calculateDimensions();
			}
		}
		
		/**
		 * Invoked when a child spatial trait is lost.
		 */		
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			// If our dimensions are not determined by a sibling viewable,
			if (viewableSibling == null)
			{
				// ... then stop listening to this trait's dimensions changing,
				unregisterChildSpatialListener(child as ISpatial);
				
				// and update our current dimensions to no longer include those
				// of the trait that just got removed:
				calculateDimensions();
			}
		}
	
		// Internals
		//
		
		/**
		 * Invoked when our owner has a trait added.
		 */		
		private function onOwnerAddTrait(event:TraitsChangeEvent):void
		{
			// If owner got a viewable, then we try to pull our dimensions from
			// there:
			if (event.traitType == MediaTraitType.VIEWABLE)
			{
				updateViewableSibling(owner.getTrait(MediaTraitType.VIEWABLE));
			}
		}
		
		/**
		 * Invoked when our owner has a trait removed. 
		 */		
		private function onOwnerRemoveTrait(event:TraitsChangeEvent):void
		{
			// If owner lost its viewable, then we revert to calculating our
			// dimensions from all child' spatial traits.
			if (event.traitType == MediaTraitType.VIEWABLE)
			{
				updateViewableSibling(null);
			}
		}
		
		/**
		 * Handles the spatial trait that determines the dimensions that we reflect, chaning.
		 */		
		private function updateSpatialSource(oldSource:ISpatial, newSource:ISpatial):void
		{
			var newWidth:int = -1;
			var newHeight:int = -1;
			
			// Remove lingering listeners, if required:
			if (oldSource != null)
			{
				oldSource.removeEventListener
					( DimensionChangeEvent.DIMENSION_CHANGE
					, onSpatialSourceDimensionChange
					);
			}
			
			// Store the new value as the current value:
			spatialSource = newSource;
			
			// On pulling our dimensions from one trait, there's no need to listen
			// to all child spatial traits. Vice versa, if spatialSource is null, then
			// we need to listen to all spatial traits changing dimensions:
			toggleChildSpatialListeners(spatialSource == null);
			
			// On pulling our dimensions from one trait, we need to listen to that
			// trait for change:
			if (spatialSource != null)
			{
				newSource.addEventListener
					( DimensionChangeEvent.DIMENSION_CHANGE
					, onSpatialSourceDimensionChange
					, false, 0, true
					);
					
				newWidth = newSource.width;
				newHeight = newSource.height;
			}
			
			updateDimensions(newWidth, newHeight);
		}
		
		/**
		 * Handles updating viewableSibling. 
		 */		
		private function updateViewableSibling(value:IMediaTrait):void
		{
			viewableSibling = value as IViewable;
			
			updateSpatialSource(spatialSource, value as ISpatial);
		}
		
		/**
		 * Adds or removes dimension change event listeners on all child spatial
		 * traits.
		 */		
		private function toggleChildSpatialListeners(on:Boolean):void
		{
			traitAggregator.forEachChildTrait
				( on	? registerChildSpatialListener
						: unregisterChildSpatialListener
				, MediaTraitType.SPATIAL
				);
				
			if (on)
			{
				calculateDimensions();
			}
		}
		
		/**
		 * Invoked on the spatialSource's dimensions changing. 
		 */		
		private function onSpatialSourceDimensionChange(event:DimensionChangeEvent):void
		{
			updateDimensions(event.newWidth, event.newHeight);
		}
		
		/**
		 * Recalculates our dimensions based on all of our child ISpatial traits.
		 */		
		private function calculateDimensions(event:Event = null):void
		{
			var newWidth:int = -1;
			var newHeight:int = -1;
			
			traitAggregator.forEachChildTrait
				(	function(trait:ISpatial):void
					{
						newWidth = Math.max(newWidth, trait.width);
						newHeight = Math.max(newHeight, trait.height);
					}
				,	MediaTraitType.SPATIAL
				);
		
			updateDimensions(newWidth,newHeight);
		}
		
		/**
		 * Resets the dimensions that we're currently reflecting. Dispatches a change
		 * event when appropriate.
		 */		
		private function updateDimensions(newWidth:int = -1, newHeight:int = -1):void
		{
			if	(	newWidth != _width
				||	newHeight != _height
				)
			{
				var oldWidth:int = _width;
				var oldHeight:int = _height;
				
				_width = newWidth;
				_height = newHeight;
				
				dispatchEvent
					( new DimensionChangeEvent
						( oldWidth, oldHeight
						, _width, _height
						)
					);
			}
		}
		
		private function registerChildSpatialListener(trait:ISpatial):void
		{
			trait.addEventListener
				( DimensionChangeEvent.DIMENSION_CHANGE
				, calculateDimensions
				, false, 0, true
				);
		}
		
		private function unregisterChildSpatialListener(trait:ISpatial):void
		{
			trait.removeEventListener
				( DimensionChangeEvent.DIMENSION_CHANGE
				, calculateDimensions
				);
		}
		
		private var owner:MediaElement;
		
		private var viewableSibling:IViewable;
		private var spatialSource:ISpatial;
		
		private var _width:int = -1;
		private var _height:int = -1;
		
	}
}