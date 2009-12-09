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
	
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.ISpatial;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.MediaTraitType;

	/**
	 * Dispatched when the width and/or height of the ISpatial media has changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionEvent")]

	/**
	 * Implementation of ISpatial for parallel compositions.
	 * 
	 * If the owning element contains a viewable trait that implements ISpatial, then
	 * the parallel composite spatial trait will forward that trait.
	 * 
	 * If the owning element does not contain a viewable trait that implements ISpatial,
	 * then the parallel composite spatial trait will constitute a trait instance that
	 * has the maximum width of all its children for its width, and the maximum height of
	 * all its children as its height.
 	 *  
 	 *  @langversion 3.0
 	 *  @playerversion Flash 10
 	 *  @playerversion AIR 1.0
 	 *  @productversion OSMF 1.0
 	 */	
	internal class ParallelSpatialTrait extends CompositeSpatialTrait
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function ParallelSpatialTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(traitAggregator, owner);
			
			if (viewableSpatialSibling == null)
			{
				// If no viewable sibling that's also ISpatial is available, then
				// we need to monitor all our spatial children for change, and reflect
				// the maximum width and height found amongst our children as our own
				// intrinsic width and height:
				toggleChildSpatialListeners(true);
				
				calculateDimensions();
			}
		}
		
		// Overrides
		//
		
		/**
		 * Invoked when a new spatial child trait becomes available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			// If our dimenions are not determined by a sibling viewable,
			if (viewableSpatialSibling == null)
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			// If our dimensions are not determined by a sibling viewable,
			if (viewableSpatialSibling == null)
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
		 * Handles the spatial trait that determines the dimensions that we reflect, chaning.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		override protected function updateSpatialSource(oldSource:ISpatial, newSource:ISpatial):void
		{
			super.updateSpatialSource(oldSource, newSource);
			
			// On pulling our dimensions from one trait, there's no need to listen
			// to all child spatial traits. Vice versa, if spatialSource is null, then
			// we need to listen to all spatial traits changing dimensions:
			toggleChildSpatialListeners(newSource == null);
		}
		
		/**
		 * Adds or removes dimension change event listeners on all child spatial
		 * traits.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 * Recalculates our dimensions based on all of our child ISpatial traits.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		
		private function registerChildSpatialListener(trait:ISpatial):void
		{
			trait.addEventListener
				( DimensionEvent.DIMENSION_CHANGE
				, calculateDimensions
				, false, 0, true
				);
		}
		
		private function unregisterChildSpatialListener(trait:ISpatial):void
		{
			trait.removeEventListener
				( DimensionEvent.DIMENSION_CHANGE
				, calculateDimensions
				);
		}
	}
}