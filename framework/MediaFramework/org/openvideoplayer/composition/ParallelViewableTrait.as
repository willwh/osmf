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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;

	/**
	 * Dispatched when the trait's view has changed.
	 * 
	 * @eventType org.openvideoplayer.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.openvideoplayer.events.ViewChangeEvent")]
	
	/**
	 * Dispatched when the width and/or height of the trait's view has changed.
	 * 
	 * @eventType org.openvideoplayer.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.openvideoplayer.events.DimensionChangeEvent")]
	
	/**
	 * Implements IViewable and ISpatial.
	 * 
	 * The view property of the viewable trait of a parallel composition refers to a
	 * DisplayObjectContainer implementing instance, that holds each of the composition's
	 * viewable children's DisplayObject.
	 * 
	 * The bounds of the container determine the ISpatial aspect of the composition, hence
	 * this class also implements that trait.
	 */	
	internal class ParallelViewableTrait extends CompositeMediaTraitBase implements IViewable, ISpatial
	{
		/**
		 * Constructor.
		 */		
		public function ParallelViewableTrait(traitAggregator:TraitAggregator)
		{
			// Prepare a container to hold viewable children:
			sprite = new Sprite();
			
			super(MediaTraitType.VIEWABLE, traitAggregator);
		}
		
		// IViewable
		//
		
		public function get view():DisplayObject
		{
			// The aggregate view is the container holding the parallel's
			// viewable children:
			return sprite;
		}
		
		// ISpatial
		//
		
		/**
		 * @inheritDoc
		 */		
		public function get width():int
		{
			// Use getBounds to obtain the unscaled bounds of our container:
			var bounds:Rectangle = sprite.getBounds(sprite);
			
			return bounds.right - bounds.left;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get height():int
		{
			// Use getBounds to obtain the unscaled bounds of our container:
			var bounds:Rectangle = sprite.getBounds(sprite);
			
			return bounds.bottom - bounds.top;
		}
		
		// Overrides
		//
		
		/**
		 * Invoked when a new viewable trait becomes available.
		 */		
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			// Listen to the trait's view property changing:
			child.addEventListener
				( ViewChangeEvent.VIEW_CHANGE
				, onChildViewChange
				, false, 0, true
				); 
			
			// Make sure that we are reflecting this new trait's view:
			updateChildView(null, IViewable(child).view);
		}
		
		/**
		 * Invoked when a viewable trait is lost.  
		 */		
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			// Stop listening to the trait's view property changing:
			child.removeEventListener
				( ViewChangeEvent.VIEW_CHANGE
				, onChildViewChange
				);
			
			// Make sure that we are rno longer eflecting this trait's view:
			updateChildView(IViewable(child).view, null); 
		}
		
		// Internals
		//
		
		/**
		 * Invoked when one of the children's viewable trait's view property changed.
		 */		
		private function onChildViewChange(event:ViewChangeEvent):void
		{
			updateChildView(event.oldView, event.newView);
		}
		
		/**
		 * Handles a child view mutation, without concern to layout. Fires a DimensionChange
		 * event in case the mutation causes our container's bounds to change.
		 * 
		 * Open issue: A ParallelViewableTrait will be collecting DisplayObjects (from its
		 * children) onto a DisplayObjectContainer. Right now, a simple Sprite instance
		 * acts as this container. This means that clients are without control over how
		 * children will be represented relative to each other. To overcome this, we will
		 * require the development of a layout system. If this system is to be managed (in
		 * part) by the DisplayObjectContainer implementer, than part of that system may be
		 * a container factory, allowing for layout behavior to be plug-able.
		 */		
		private function updateChildView(oldView:DisplayObject, newView:DisplayObject):void
		{
			// Keep a copy of our current dimensions:
			var oldBounds:Rectangle = sprite.getBounds(sprite);
			
			// If the old view is on our container, then remove it:
			if	(	oldView != null
				&&	sprite.contains(oldView)
				)
			{
				sprite.removeChild(oldView);
			}
			
			// If the new view is not on our contrainer, then add it:
			if	(	newView != null
				&&	sprite.contains(newView) == false
				)
			{
				sprite.addChild(newView);
			}
			
			// Get our current dimensions, and dispatch a change event if they are
			// different from our previous ones:
			var newBounds:Rectangle = sprite.getBounds(sprite);
			if (newBounds.equals(oldBounds) == false)
			{
				dispatchEvent
					( new DimensionChangeEvent
						( oldBounds.right - oldBounds.left
						, oldBounds.bottom - oldBounds.top
						, newBounds.right - newBounds.left
						, newBounds.bottom - newBounds.top
						)
					);
			}
		}
		
		private var sprite:Sprite;
		
	}
}