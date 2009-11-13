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
package org.osmf.model
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osmf.media.IMediaReferrer;
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.media.IURLResource;
	import org.osmf.media.MediaElement;
	import org.osmf.net.NetLoader;
	import org.osmf.swf.SWFElement;
	import org.osmf.swf.SWFLoader;
	import org.osmf.traits.IPausable;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * A SWFElement which can reference other MediaElements so that
	 * any time the user clicks on the SWF, the MediaElement is paused.
	 **/ 
	public class ReferenceSWFElement extends SWFElement implements IMediaReferrer
	{
		public function ReferenceSWFElement(loader:SWFLoader=null, resource:IURLResource=null)
		{
			super(loader, resource);
			
			handler = new NetLoader() as IMediaResourceHandler;
		}

		public function canReferenceMedia(target:MediaElement):Boolean
		{
			// This object can reference any video media.
			return target != null && handler.canHandleResource(target.resource);
		}

		public function addReference(target:MediaElement):void
		{
			// For simplicity, we'll assume a single reference.  But other
			// examples might want to maintain multiple references.
			reference = target;
		}
		
		override protected function processReadyState():void
		{
			super.processReadyState();
			
			if (swfRoot != null)
			{
				// Keep track of any user clicks on the overlay SWF.
				swfRoot.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		private function onClick(event:Event):void
		{
			// Any time the user clicks on the overlay SWF, we pause the reference.
			if (reference != null)
			{
				var pausable:IPausable = reference.getTrait(MediaTraitType.PAUSABLE) as IPausable;
				if (pausable != null && pausable.paused == false)
				{
					pausable.pause();
				}
			}
		}
		
		private var handler:IMediaResourceHandler;
		private var reference:MediaElement;
	}
}