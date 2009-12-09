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
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.MediaElementEvent;
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
	 * Base implementation of ISpatial for compositions.
	 * 
	 * A composite media element's spatial trait is defined by its sibling viewable trait,
	 * unless:
	 * 
	 *  1. the trait is missing.
	 *  2. the trait is not implementing ISpatial.
	 * 
	 * The implementation watches for a viewable sibling trait being added/removed on the
	 * owner media element, updating a viewableSpatialSibling variable.
	 * 
	 * Futhermore, the implementation keeps state on what is the trait's current spatial
	 * source (if applicable), watching it for change.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	internal class CompositeSpatialTrait extends CompositeMediaTraitBase implements ISpatial
	{
		public function CompositeSpatialTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(MediaTraitType.SPATIAL, traitAggregator);
			
			this.owner = owner;
			
			// If a sibling viewable is available, than if that sibling is
			// also implementing ISpatial, then that will be the spatial
			// data the we will forward: 
			
			owner.addEventListener
				( MediaElementEvent.TRAIT_ADD
				, onOwnerAddTrait
				, false, 0, true
				);
			
			owner.addEventListener
				( MediaElementEvent.TRAIT_REMOVE
				, onOwnerRemoveTrait
				, false, 0, true
				);
				
			updateViewableSibling(owner.getTrait(MediaTraitType.VIEWABLE) as IViewable);
		}
		
		// ISpatial
		//
		
		public function get width():Number
		{
			return _width;
		}
		
		public function get height():Number
		{
			return _height;
		}
	
		// Internals
		//
		
		/**
		 * Invoked when our owner has a trait added.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		private function onOwnerAddTrait(event:MediaElementEvent):void
		{
			// If owner got a viewable, then we try to pull our dimensions from
			// there:
			if (event.traitType == MediaTraitType.VIEWABLE)
			{
				updateViewableSibling
					( owner.getTrait(MediaTraitType.VIEWABLE) as IViewable
					);
			}
		}
		
		/**
		 * Invoked when our owner has a trait removed. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		private function onOwnerRemoveTrait(event:MediaElementEvent):void
		{
			// If owner lost its viewable, then we revert to calculating our
			// dimensions from all child' spatial traits.
			if (event.traitType == MediaTraitType.VIEWABLE)
			{
				updateViewableSibling(null);
			}
		}
		
		/**
		 * Handles the spatial trait that determines the dimensions that we reflect, changing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function updateSpatialSource(oldSource:ISpatial, newSource:ISpatial):void
		{
			// Remove lingering listeners, if required:
			if (oldSource != null)
			{
				oldSource.removeEventListener
					( DimensionEvent.DIMENSION_CHANGE
					, onSpatialSourceDimensionChange
					);
			}
			
			// Store the new value as the current value:
			spatialSource = newSource;
			
			var newWidth:Number = -1;
			var newHeight:Number = -1;
			
			// On pulling our dimensions from one trait, we need to listen to that
			// trait for change:
			if (newSource != null)
			{
				newSource.addEventListener
					( DimensionEvent.DIMENSION_CHANGE
					, onSpatialSourceDimensionChange
					, false, 0, true
					);
					
				newWidth = newSource.width;
				if (isNaN(newWidth))
				{
					newWidth = 0;
				}
				newHeight = newSource.height;
				if (isNaN(newHeight))
				{
					newHeight = 0;
				}
			}
			
			updateDimensions(newWidth, newHeight);
		}
		
		/**
		 * Handles updating viewableSibling. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function updateViewableSibling(value:IViewable):void
		{
			viewableSpatialSibling = value as ISpatial;
			
			if (spatialSource != viewableSpatialSibling)
			{
				updateSpatialSource(spatialSource, value as ISpatial);
			}
		}
		
		/**
		 * Invoked on the spatialSource's dimensions changing. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function onSpatialSourceDimensionChange(event:DimensionEvent):void
		{
			updateDimensions(event.newWidth, event.newHeight);
		}
		
		/**
		 * Resets the dimensions that we're currently reflecting. Dispatches a change
		 * event when appropriate.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function updateDimensions(newWidth:Number = -1, newHeight:Number = -1):void
		{
			if	(	newWidth != _width
				||	newHeight != _height
				)
			{
				var oldWidth:Number = _width;
				var oldHeight:Number = _height;
				
				_width = newWidth;
				_height = newHeight;
				
				dispatchEvent
					( new DimensionEvent
						( DimensionEvent.DIMENSION_CHANGE, false, false
						, oldWidth, oldHeight
						, _width, _height
						)
					);
			}
		}
		
		protected var owner:MediaElement;
		
		protected var viewableSpatialSibling:ISpatial;
		protected var spatialSource:ISpatial;
		
		protected var _width:Number = -1;
		protected var _height:Number = -1;
		
	}
}