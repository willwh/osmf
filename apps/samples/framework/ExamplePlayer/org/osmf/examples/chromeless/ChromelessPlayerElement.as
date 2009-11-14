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
package org.osmf.examples.chromeless
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.osmf.events.DimensionEvent;
	import org.osmf.media.IURLResource;
	import org.osmf.swf.SWFElement;
	import org.osmf.swf.SWFLoader;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SpatialTrait;
	
	/**
	 * SWFElement which can control the SWF it wraps via a custom SWF API
	 * that maps to the traits API.
	 **/
	public class ChromelessPlayerElement extends SWFElement
	{
		public function ChromelessPlayerElement(loader:SWFLoader=null, resource:IURLResource=null)
		{
			super(loader, resource);		
		}
		
		override protected function processReadyState():void
		{
			super.processReadyState();
			
			// Flex SWFs load differently from pure AS3 SWFs.  For the former,
			// we need to wait until the applicationComplete event is
			// dispatched before we can access the SWF's API.
			if	(	swfRoot.hasOwnProperty("application")
				&&	Object(swfRoot).application == null
				)
			{
				swfRoot.addEventListener("applicationComplete", finishProcessReadyState, false, 0, true);
			}
			else
			{
				finishProcessReadyState();
			}
		}
		
		private function finishProcessReadyState(event:Event=null):void
		{
			// Flex SWFs expose their API through the root "application"
			// property, whereas pure AS3 SWFs expose their API directly.
			var theSwfRoot:DisplayObject = swfRoot.hasOwnProperty("application") ? Object(swfRoot).application : swfRoot;
			
			// Make sure the SWF has the expected API object.
			var isValidSWF:Boolean = theSwfRoot.hasOwnProperty("videoPlayer");
			
			theSwfRoot.addEventListener("click",onClick);
			
			if (isValidSWF)
			{
				addTrait(MediaTraitType.PLAYABLE, new SWFPlayableTrait(theSwfRoot, this));
				addTrait(MediaTraitType.PAUSABLE, new SWFPausableTrait(theSwfRoot, this));
				addTrait(MediaTraitType.AUDIBLE, new SWFAudibleTrait(theSwfRoot));
				addTrait(MediaTraitType.TEMPORAL, new SWFTemporalTrait(theSwfRoot));
				
				if	(	swfRoot.hasOwnProperty("application")
					&&	Object(swfRoot).application != null
					)
				{
					// Re-dispatch our dimensions:
					var spatial:SpatialTrait = getTrait(MediaTraitType.SPATIAL) as SpatialTrait;
					spatial.dispatchEvent(new DimensionEvent(DimensionEvent.DIMENSION_CHANGE, false, false, 0, spatial.width, 0, spatial.height));
				}
			}
		}
		
		private function onClick(event:Event):void
		{
			trace("click");
		}
		
		override protected function processUnloadingState():void
		{
			super.processUnloadingState();
			
			removeTrait(MediaTraitType.PLAYABLE);
			removeTrait(MediaTraitType.PAUSABLE);
			removeTrait(MediaTraitType.AUDIBLE);
			removeTrait(MediaTraitType.TEMPORAL);
		}
	}
}