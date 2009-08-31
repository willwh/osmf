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
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.layout.MediaElementLayoutTarget;
	import org.openvideoplayer.media.MediaElement;

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
	internal class SerialViewableTrait extends CompositeViewableTrait implements IReusable
	{
		/**
		 * Constructor
		 */		
		public function SerialViewableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(traitAggregator, owner);
			
			// In order to forward the serial's active child's view, we need
			// to track the serial's active child:
			traitAggregator.addEventListener
				( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
				, onListenedChildChange
				);
			
			// If we currently have an active child, then add it to our
			// layout renderer:
			var child:MediaElement = traitAggregator.listenedChild; 
			if (child)
			{
				currentLayoutTarget = new MediaElementLayoutTarget(child);
					
				layoutRenderer.addTarget(currentLayoutTarget);
			}
		}
		
		// IReusable
		//
		
		public function prepare():void
		{	
			attach();
		}
		
		// Internals
		//
		
		/**
		 * Invoked on the serial's active child changing.
		 */		
		private function onListenedChildChange(event:TraitAggregatorEvent):void
		{
			if (currentLayoutTarget)
			{
				layoutRenderer.removeTarget(currentLayoutTarget);	
			}
			
			var child:MediaElement = event.newListenedChild;
			
			if (child)
			{
				currentLayoutTarget = new MediaElementLayoutTarget(child);
					
				layoutRenderer.addTarget(currentLayoutTarget);
				
			}
		}
		
		private var currentLayoutTarget:MediaElementLayoutTarget;
	}
}