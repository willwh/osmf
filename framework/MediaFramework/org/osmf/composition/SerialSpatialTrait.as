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
	 * Implementation of ISpatial for serial compositions.
	 * 
	 * If the owning element contains a viewable trait that implements ISpatial, then
	 * the serial composite spatial trait will forward that trait.
	 * 
	 * If the owning element does not contain a viewable trait that implements ISpatial,
	 * then the serial composite spatial trait will forward the active child's spatial
	 * trait.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	internal class SerialSpatialTrait extends CompositeSpatialTrait
	{
		public function SerialSpatialTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(traitAggregator, owner);
			
			traitAggregator.addEventListener
				( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
				, onCurrentChildChange
				);
			
			// If we do not have a viewable trait sibling that's also spatial, then set the
			// spatial source to the currently active child of the aggregator:
			if (viewableSpatialSibling == null)
			{
				updateSpatialSource
					( spatialSource
					, traitAggregator.listenedChild
						?	traitAggregator.listenedChild.getTrait(MediaTraitType.SPATIAL)
							as ISpatial
						: null
					);
			}
		}
		
		// Overrides
		//
		
		override protected function updateViewableSibling(value:IViewable):void
		{
			viewableSpatialSibling = value as ISpatial;
			
			if (value as ISpatial == null)
			{
				// The current child determines our spatial trait, listen
				// to it changing:
				traitAggregator.addEventListener
					( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
					, onCurrentChildChange
					, false, 0, true
					);
					
				updateSpatialSource
					( spatialSource
					, traitAggregator.listenedChild
						? traitAggregator.listenedChild.getTrait(MediaTraitType.SPATIAL)
						  as ISpatial
						: null
					);
			}
			else
			{
				// The current child does not determine our spatial trait:
				// stop listening to it changing:
				traitAggregator.removeEventListener
					( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
					, onCurrentChildChange
					);
					
				updateSpatialSource
					( spatialSource
					, value as ISpatial
					);
			}
		}
		
		// Internals
		//
		
		/**
		 * Invoked on the serial's current child changing. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		private function onCurrentChildChange(event:TraitAggregatorEvent):void
		{
			updateViewableSibling
				( ( event.newListenedChild
					? event.newListenedChild.getTrait(MediaTraitType.VIEWABLE)
					: null
				  ) as IViewable
				);
		}
	}
}