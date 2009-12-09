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
	import org.osmf.events.GatewayChangeEvent;
	import org.osmf.events.ViewEvent;
	import org.osmf.layout.MediaElementLayoutTarget;
	import org.osmf.media.IMediaGateway;
	import org.osmf.media.MediaElement;

	/**
	 * Dispatched when the trait's view has changed.
	 * 
	 * @eventType org.osmf.events.ViewEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewEvent")]
	
	/**
	 * Implements IViewable for serial compositions
	 * 
	 * The viewable characteristics of a serial composition are identical to the viewable
	 * characteristics of the active child of that serial composition.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	internal class SerialViewableTrait extends CompositeViewableTrait implements IReusable
	{
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function SerialViewableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			this.owner = owner;
			
			super(traitAggregator, owner);
			
			// In order to forward the serial's active child's view, we need
			// to track the serial's active child:
			traitAggregator.addEventListener
				( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
				, onListenedChildChange
				);
			
			// Setup the current active child:
			setupLayoutTarget(traitAggregator.listenedChild);
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		private function onListenedChildChange(event:TraitAggregatorEvent):void
		{
			setupLayoutTarget(event.newListenedChild);
		}
		
		private function onTargetGatewayChange(event:GatewayChangeEvent):void
		{
			var oldGateway:IMediaGateway = event.oldValue;
			var newGateway:IMediaGateway = event.newValue;
			var element:MediaElement = layoutTarget.mediaElement;
		
			
			var targetInLayoutRenderer:Boolean
				= layoutRenderer.targets(layoutTarget);
				
			if (newGateway == null || newGateway == owner.gateway)
			{
				if (targetInLayoutRenderer == false)
				{
					layoutRenderer.addTarget(layoutTarget);
				}
			}
			else
			{ 
				if (targetInLayoutRenderer)
				{
					layoutRenderer.removeTarget(layoutTarget);
				}
			}
		}
		
		private function setupLayoutTarget(listenedChild:MediaElement):void
		{
			if (layoutTarget != null)
			{
				layoutTarget.mediaElement.removeEventListener
					( GatewayChangeEvent.GATEWAY_CHANGE
					, onTargetGatewayChange
					);
				
				var mediaElement:MediaElement = layoutTarget.mediaElement;
					
				if (layoutRenderer.targets(layoutTarget))
				{
					layoutRenderer.removeTarget(layoutTarget);
				}
			}
			
			if (listenedChild != null)
			{
				layoutTarget = MediaElementLayoutTarget.getInstance(listenedChild);
				
				listenedChild.addEventListener
					( GatewayChangeEvent.GATEWAY_CHANGE
					, onTargetGatewayChange
					);
					
				onTargetGatewayChange
					( new GatewayChangeEvent
						( GatewayChangeEvent.GATEWAY_CHANGE
						, false
						, false
						, null
						, layoutTarget.mediaElement.gateway
						)
					);
			}
		}
		
		private var layoutTarget:MediaElementLayoutTarget;
		private var owner:MediaElement;
	}
}