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
package org.osmf.examples.loaderproxy
{
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.MediaTraitType;
	
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
			
			loadableTrait = new LoadableTrait(new VideoProxyLoader(), resource);
			
			loadableTrait.addEventListener
				( LoadableStateChangeEvent.LOAD_STATE_CHANGE
				, onLoadStateChange
				);
			
			addTrait(MediaTraitType.LOADABLE, loadableTrait); 
		}
		
		private function onLoadStateChange(event:LoadableStateChangeEvent):void
		{
			if (event.loadState == LoadState.READY)
			{
				var loadedContext:VideoProxyLoadedContext = loadableTrait.loadedContext as VideoProxyLoadedContext
				
				// Replace the resource with the new URL.
				wrappedElement.resource = new URLResource(loadedContext.url);
				
				// Our work is done, remove the custom ILoadable.  This will
				// expose the base ILoadable, which we can then use to do
				// the actual load.
				removeTrait(MediaTraitType.LOADABLE);
				(getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
				
				loadableTrait = null;
			}
		}
		
		private var loadableTrait:LoadableTrait;
	}
}