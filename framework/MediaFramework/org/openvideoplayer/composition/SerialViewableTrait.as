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
	
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;

	/**
	 * Dispatched when the trait's view has changed.
	 * 
	 * @eventType org.openvideoplayer.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.openvideoplayer.events.ViewChangeEvent")]
	
	/**
	 * Implements IViewable for serial compositions
	 * 
	 * The viewable characteristics of a serial composition are identical to the viewable
	 * characteristics of the active child of that serial composition.
	 * 
	 */	
	internal class SerialViewableTrait extends CompositeMediaTraitBase implements IViewable
	{
		/**
		 * Constructor
		 */		
		public function SerialViewableTrait(traitAggregator:TraitAggregator)
		{
			// In order to forward the serial's active child's view, we need
			// to track the serial's active child:
			traitAggregator.addEventListener
				( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
				, onListenedChildChange
				);
			
			// Pick up on the (potential) current serial's active child:
			updateViewableSource
				( null
				, traitAggregator.listenedChild
					? traitAggregator.listenedChild.getTrait(MediaTraitType.VIEWABLE) as IViewable
					: null
				);
				
			super(MediaTraitType.VIEWABLE, traitAggregator);
		}
		
		// IViewable
		//
		
		public function get view():DisplayObject
		{
			return _view;
		}
		
		// Internals
		//
		
		/**
		 * Invoked on the serial's active child changing.
		 */		
		private function onListenedChildChange(event:TraitAggregatorEvent):void
		{
			// Collect the old and the new viewable traits as they may be available,
			// and update our internal state accordingly: 
			updateViewableSource
				( event.oldListenedChild 
					? event.oldListenedChild.getTrait(MediaTraitType.VIEWABLE) as IViewable
					: null
				, event.newListenedChild
					? event.newListenedChild.getTrait(MediaTraitType.VIEWABLE) as IViewable
					: null
				);
		}
		
		/**
		 * Invoked on the view property of the serial's active child's viewable trait
		 * having changed. 
		 */		
		private function onViewableSourceViewChange(event:ViewChangeEvent):void
		{
			updateView(event.newView);
		}
		
		/**
		 * Handles the view as we represent it to the outside world changing. Dispatches
		 * a change event.
		 */		
		private function updateView(newView:DisplayObject = null):void
		{
			if (newView != _view)
			{
				var oldView:DisplayObject = _view;
				
				_view = newView;
				
				dispatchEvent(new ViewChangeEvent(oldView, newView));
			}
		}
		
		/**
		 * Handles the trait that defines our view, changing. Takes care of registering
		 * and unregistering for ViewChangeEvents. 
		 */		
		private function updateViewableSource(oldSource:IViewable, newSource:IViewable):void
		{
			var newView:DisplayObject;
			
			if (oldSource != null)
			{
				oldSource.removeEventListener
					( ViewChangeEvent.VIEW_CHANGE
					, onViewableSourceViewChange
					);
			}
			
			if (newSource != null)
			{
				newSource.addEventListener
					( ViewChangeEvent.VIEW_CHANGE
					, onViewableSourceViewChange
					, false, 0, true
					); 
				
				newView = newSource.view;
			}
			
			updateView(newView);
		}
		
		private var _view:DisplayObject;
		
	}
}