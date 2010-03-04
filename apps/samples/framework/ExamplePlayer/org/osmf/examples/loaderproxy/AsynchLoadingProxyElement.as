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
	import __AS3__.vec.Vector;
	
	import org.osmf.elements.ProxyElement;
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * A ProxyElement which allows for custom load logic to be layered on top
	 * of the MediaElement that's being proxied.  For instance, if you need to
	 * make some asynchronous HTTP calls *after* the video is loaded but *before*
	 * the client can begin interacting with the video, this class provides
	 * a pattern for doing so.
	 **/
	public class AsynchLoadingProxyElement extends ProxyElement
	{
		/**
		 * Constructor.
		 * 
		 * @param proxiedElement The MediaElement to proxy.
		 **/
		public function AsynchLoadingProxyElement(proxiedElement:MediaElement)
		{
			super(proxiedElement);
		}

		/**
		 * @private
		 **/
		override protected function setupOverriddenTraits():void
		{
			super.setupOverriddenTraits();
			
			// First, block all traits but the LOAD trait from being exposed
			// to clients.  The reason for this is that the proxied element
			// will complete its load before we're ready to expose its state
			// to the outside world, so we block all the other traits so that
			// we can expose them when we're truly ready.
			var traitsToBlock:Vector.<String> = new Vector.<String>();
			traitsToBlock.push(MediaTraitType.AUDIO);
			traitsToBlock.push(MediaTraitType.BUFFER);
			traitsToBlock.push(MediaTraitType.DISPLAY_OBJECT);
			traitsToBlock.push(MediaTraitType.DRM);
			traitsToBlock.push(MediaTraitType.DVR);
			traitsToBlock.push(MediaTraitType.DYNAMIC_STREAM);
			traitsToBlock.push(MediaTraitType.PLAY);
			traitsToBlock.push(MediaTraitType.SEEK);
			traitsToBlock.push(MediaTraitType.TIME);
			super.blockedTraits = traitsToBlock;
			
			// Override the LoadTrait with our own custom trait, which provides
			// hooks for executing asynchronous logic in conjunction with the
			// load of the proxied element.
			var asynchLoadTrait:AsynchLoadingProxyLoadTrait = new AsynchLoadingProxyLoadTrait(super.getTrait(MediaTraitType.LOAD) as LoadTrait);
			addTrait(MediaTraitType.LOAD, asynchLoadTrait); 

			// Make sure we're informed when the custom load trait signals that
			// it's ready, so that we can unblock the other traits.
			asynchLoadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
		}
		
		private function onLoadStateChange(event:LoadEvent):void
		{
			if (event.loadState == LoadState.READY)
			{
				// We're now ready to expose the proxied element to the outside
				// world, so we unblock all traits.
				super.blockedTraits = new Vector.<String>();
			}
		}
	}
}