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
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.MediaTraitType;

	/**
	 * Dispatched when the width and/or height of the ISpatial media has changed.
	 * 
	 * @eventType org.openvideoplayer.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.openvideoplayer.events.DimensionChangeEvent")]

	/**
	 * Implementation of ISpatial for serial compositions.
	 * 
	 * ISpatial's composite trait behaves differently for parallel and serial
	 * compositions.
	 * 
	 * The spatial characteristics of a serial composition are identical to 
	 * the spatial characteristics of the active child of that serial composition.
	 */
	internal class SerialSpatialTrait extends CompositeMediaTraitBase implements ISpatial
	{
		public function SerialSpatialTrait(traitAggregator:TraitAggregator)
		{
			super(MediaTraitType.SPATIAL, traitAggregator);
			
			// In serial mode, we listen to the composition's active child
			// changing. When it changes, we pick up on that childs spatial
			// trait, bouncing of its characteristics as our own.
			traitAggregator.addEventListener
				( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
				, onCurrentChildChange
				);
				
			updateCurrentChildTrait
				( null
				, traitAggregator.listenedChild
					? traitAggregator.listenedChild.getTrait(MediaTraitType.SPATIAL) as ISpatial
					: null
				);
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
		 * Invoked on the serial's current child changing. 
		 */		
		private function onCurrentChildChange(event:TraitAggregatorEvent):void
		{
			updateCurrentChildTrait
				( event.oldListenedChild
					? event.oldListenedChild.getTrait(MediaTraitType.SPATIAL) as ISpatial
					: null
				, event.newListenedChild
					? event.newListenedChild.getTrait(MediaTraitType.SPATIAL) as ISpatial
					: null
				);
		}
		
		/**
		 * Invoked on the serial's current child's dimensions changing.
		 */		
		private function onCurrentChildDimensionChange(event:DimensionChangeEvent):void
		{
			updateDimensions(event.newWidth,event.newHeight);
		}
		
		/**
		 * Method that handles the spatial trait of the current child changing. Takes
		 * care of listening to traits DimensionChangeEvent.
		 * 
		 * @param oldTrait
		 * @param newTrait
		 */		
		private function updateCurrentChildTrait(oldTrait:ISpatial, newTrait:ISpatial):void
		{
			var newWidth:int = -1;
			var newHeight:int = -1;
			
			if (oldTrait != null)
			{
				oldTrait.removeEventListener
					( DimensionChangeEvent.DIMENSION_CHANGE
					, onCurrentChildDimensionChange
					);
			}
			
			if (newTrait != null)
			{
				newTrait.addEventListener
					( DimensionChangeEvent.DIMENSION_CHANGE
					, onCurrentChildDimensionChange
					, false, 0, true
					);
					
				newWidth = newTrait.width;
				newHeight = newTrait.height;
			}
			
			updateDimensions(newWidth, newHeight);
		}
		
		/**
		 * Method that handles the assignment of new dimensions, dispatching a change
		 * event if applicable.
		 * 
		 * @param newWidth
		 * @param newHeight
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
						, _width, _height)
					);
			}
		}
		
		private var _width:int = -1;
		private var _height:int = -1;
		
	}
}