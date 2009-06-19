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
package com.adobe.strobe.plugins.smil.media
{
	import com.adobe.strobe.plugins.smil.loader.SMILLoadedContext;
	import com.adobe.strobe.plugins.smil.loader.SMILLoader;
	
	import org.openvideoplayer.composition.CompositeElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class SMILElement extends SerialElement
	{
		public function SMILElement(loader:SMILLoader = null, resource:IURLResource = null)
		{
			this.loader = loader;
			this.resource = resource;
		}

		override public function initialize(value:Array):void
		{
			loader = value[0] as ILoader;
			var loadableTrait:LoadableTrait
				= new LoadableTrait(loader, resource);
			
			loadableTrait.addEventListener
				( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
				, onLoadableStateChange
				);
			
			addTrait(MediaTraitType.LOADABLE,loadableTrait); 
		}

		override public function set resource(value:IMediaResource):void
		{
			_resource2 = value;
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
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			
			if (event.newState == LoadState.LOADED)
			{
				processLoadedState(event.loadable.loadedContext as SMILLoadedContext);
			}
			else if (event.newState == LoadState.UNLOADING)
			{
				processUnloadingState();
			}
		}

		private var loader:ILoader;
		private var _resource2:IMediaResource;
	}
}