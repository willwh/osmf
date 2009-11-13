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
package com.adobe.strobe.plugins.smil.media
{
	import com.adobe.strobe.plugins.smil.loader.SMILLoadedContext;
	import com.adobe.strobe.plugins.smil.loader.SMILLoader;
	
	import org.osmf.composition.CompositeElement;
	import org.osmf.composition.SerialElement;
	import org.osmf.events.LoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IURLResource;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.MediaTraitType;
	
	public class SMILElement extends SerialElement
	{
		public function SMILElement(loader:SMILLoader, resource:IURLResource = null)
		{
			this.loader = loader;
			this.resource = resource;
		}

		override public function set resource(value:IMediaResource):void
		{
			if (_resource2 != value)
			{
				super.resource = value;
				_resource2 = value;
				
				loadableTrait = new LoadableTrait(loader, value);
				
				loadableTrait.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onLoadStateChange
					);
				
				addTrait(MediaTraitType.LOADABLE,loadableTrait); 
			}
		}
		
		override public function get resource():IMediaResource
		{
			return _resource2;	
		}

		/**
		 * This function gets called just after the smile loader has successfully loaded the SMIL document
		 */
		private function processLoadedState(loadedContext:SMILLoadedContext):void
		{
			super.setupTraits();
			
			// The mediaElement instance returned by the parser is assumed to be a CompositeElement
			// in order to limit the scope of this sample plugin.
			//
			// Another assumption is that the root of the SMIL document is a 'seq' tag. That is why 
			// SMILElement extends SerialElement. As a result, we only need to get the children
			// from the 'mediaElement' object (which will be of type SeriqlElement) and add them
			// to 'this'.
			var mediaElement:CompositeElement = loadedContext.mediaElement as CompositeElement;
			if (mediaElement != null)
			{
				var numChildren:int = mediaElement.numChildren;
				for (var i:int = 0; i < numChildren; i++)
				{
					this.addChild(mediaElement.getChildAt(i));
				}
			}
		}
		
		private function processUnloadingState():void
		{
			// placeholder for performing any operations just before the unload is completed
		}
		
		private function onLoadStateChange(event:LoadEvent):void
		{
			if (event.loadState == LoadState.READY)
			{
				processLoadedState(loadableTrait.loadedContext as SMILLoadedContext);
			}
			else if (event.loadState == LoadState.UNLOADING)
			{
				processUnloadingState();
			}
		}

		private var loadableTrait:LoadableTrait
		private var loader:ILoader;
		private var _resource2:IMediaResource;
	}
}