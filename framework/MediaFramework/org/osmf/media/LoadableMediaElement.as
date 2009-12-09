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
package org.osmf.media
{
	import org.osmf.events.LoadEvent;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * A base implementation of a MediaElement that has a LoadTrait.
	 **/
	public class LoadableMediaElement extends MediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param loader Loader used to load the media.
		 * @param resource The IMediaResource that represents the piece of
		 * media to load into this media element.
		 * 
		 * @throws ArgumentError If loader is null.
		 **/
		public function LoadableMediaElement(loader:ILoader, resource:IMediaResource=null)
		{
			super();
			
			if (loader == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			this.loader = loader;
			this.resource = resource;
		}
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function set resource(value:IMediaResource):void
	    {
			super.resource = value;
			
			updateLoadTrait();
		}
		
		// Protected
		//
		
		/**
		 * Subclasses can override this method to return a custom LoadTrait
		 * subclass.
		 **/
		protected function createLoadTrait(loader:ILoader, resource:IMediaResource):LoadTrait
		{
			return new LoadTrait(loader, resource);
		}
		
		/**
		 * 
		 * Subclasses can override this method to do processing when the media
		 * element enters the LOADING state.
		 **/
		protected function processLoadingState():void
		{
			// Subclass stub
		}
		
		/**
		 * Subclasses can override this method to do processing when the media
		 * element enters the READY state.
		 **/
		protected function processReadyState():void
		{
			// Subclass stub
		}
		
		/**
		 * Subclasses can override this method to do processing when the media
		 * element enters the UNLOADING state.
		 **/
		protected function processUnloadingState():void
		{
			// Subclass stub
		}
		
		// Private
		//
		
		private function onLoadStateChange(event:LoadEvent):void
		{
			// The asymmetry between READY and UNLOADING (versus UNINITIALIZED) is
			// motivated by the fact that once a media is already unloaded, one
			// cannot reference it any longer. Triggering the event upfront the
			// actual unload being effectuated allows listeners to still act on
			// the media that is about to be unloaded.
			
			if (event.loadState == LoadState.LOADING)
			{
				processLoadingState();
			}
			else if (event.loadState == LoadState.READY)
			{
				processReadyState();
			}
			else if (event.loadState == LoadState.UNLOADING)
			{
				processUnloadingState();
			}
		}

		private function updateLoadTrait():void
		{
			var loadTrait:LoadTrait = getTrait(MediaTraitType.LOAD) as LoadTrait;
			if (loadTrait != null)
			{
				// Remove (and unload) any existing LoadTrait.
				loadTrait.removeEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onLoadStateChange
					);
					
				if (loadTrait.loadState == LoadState.READY)
				{	    			   
					loadTrait.unload();	 
				}
				
				removeTrait(MediaTraitType.LOAD);
			}
			
			// Add a new LoadTrait for the current resource.
			loadTrait = createLoadTrait(loader, resource);
			loadTrait.addEventListener
				( LoadEvent.LOAD_STATE_CHANGE
				, onLoadStateChange, false, 10 // Using a higher priority event listener in order to process load state changes before clients.
				);
			
			addTrait(MediaTraitType.LOAD, loadTrait);
		}

		private var loader:ILoader;
	}
}