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
package org.openvideoplayer.examples.loaderproxy
{
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * VideoProxyElement acts as a proxy for a VideoElement, and changes the
	 * URL of the video (to a hardcoded value) when the video is loaded.  The
	 * point of this example is to demonstrate how to decorate a MediaElement
	 * with a proxy that can do preflight operations.
	 **/
	public class VideoProxyElement extends ProxyElement
	{
		public function VideoProxyElement(wrappedElement:MediaElement)
		{
			super(wrappedElement);
		}

		override protected function setupOverriddenTraits():void
		{
			super.setupOverriddenTraits();
			
			// Override the ILoadable trait with our own custom loadable,
			// which simply replaces the URL.
			//
			
			var loadableTrait:LoadableTrait
				= new LoadableTrait(new VideoProxyLoader(), resource);
			
			loadableTrait.addEventListener
				( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
				, onLoadableStateChange
				);
			
			addTrait(MediaTraitType.LOADABLE, loadableTrait); 
		}
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				var loadedContext:VideoProxyLoadedContext = event.loadable.loadedContext as VideoProxyLoadedContext
				
				// Replace the resource with the new URL.
				wrappedElement.resource = new URLResource(loadedContext.url);
				
				// Our work is done, remove the custom ILoadable.  This will
				// expose the base ILoadable, which we can then use to do
				// the actual load.
				removeTrait(MediaTraitType.LOADABLE);
				(getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
			}
		}
	}
}