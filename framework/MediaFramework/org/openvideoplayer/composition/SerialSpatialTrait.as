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