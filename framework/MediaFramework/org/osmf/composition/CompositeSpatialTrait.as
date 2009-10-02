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
	import org.osmf.events.DimensionChangeEvent;
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.ISpatial;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.MediaTraitType;

	/**
	 * Dispatched when the width and/or height of the ISpatial media has changed.
	 * 
	 * @eventType org.osmf.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionChangeEvent")]

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
				( TraitsChangeEvent.TRAIT_ADD
				, onOwnerAddTrait
				, false, 0, true
				);
			
			owner.addEventListener
				( TraitsChangeEvent.TRAIT_REMOVE
				, onOwnerRemoveTrait
				, false, 0, true
				);
				
			updateViewableSibling(owner.getTrait(MediaTraitType.VIEWABLE) as IViewable);
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
				updateViewableSibling
					( owner.getTrait(MediaTraitType.VIEWABLE)
					as IViewable
					);
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
		 * Handles the spatial trait that determines the dimensions that we reflect, changing.
		 */		
		protected function updateSpatialSource(oldSource:ISpatial, newSource:ISpatial):void
		{
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
			
			var newWidth:int = -1;
			var newHeight:int = -1;
			
			// On pulling our dimensions from one trait, we need to listen to that
			// trait for change:
			if (newSource != null)
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
		 */		
		protected function onSpatialSourceDimensionChange(event:DimensionChangeEvent):void
		{
			updateDimensions(event.newWidth, event.newHeight);
		}
		
		/**
		 * Resets the dimensions that we're currently reflecting. Dispatches a change
		 * event when appropriate.
		 */		
		protected function updateDimensions(newWidth:int = -1, newHeight:int = -1):void
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
		
		protected var owner:MediaElement;
		
		protected var viewableSpatialSibling:ISpatial;
		protected var spatialSource:ISpatial;
		
		protected var _width:int = -1;
		protected var _height:int = -1;
		
	}
}