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