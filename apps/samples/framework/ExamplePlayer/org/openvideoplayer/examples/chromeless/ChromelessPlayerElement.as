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
package org.openvideoplayer.examples.chromeless
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.swf.SWFElement;
	import org.openvideoplayer.swf.SWFLoader;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	
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
		
		override protected function processLoadedState():void
		{
			super.processLoadedState();
			
			// Flex SWFs load differently from pure AS3 SWFs.  For the former,
			// we need to wait until the applicationComplete event is
			// dispatched before we can access the SWF's API.
			if	(	swfRoot.hasOwnProperty("application")
				&&	Object(swfRoot).application == null
				)
			{
				swfRoot.addEventListener("applicationComplete", finishProcessLoadedState, false, 0, true);
			}
			else
			{
				finishProcessLoadedState();
			}
		}
		
		private function finishProcessLoadedState(event:Event=null):void
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
					spatial.dispatchEvent(new DimensionChangeEvent(0,spatial.width,0,spatial.height));
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