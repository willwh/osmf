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
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;
	
	/**
	 * A base implementation of a MediaElement that has the ILoadable trait.
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
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
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
			
			updateLoadable();
		}
		
		// Protected
		//
		
		/**
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

		private function updateLoadable():void
		{
			var loadable:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
			if (loadable != null)
			{
				// Remove (and unload) any existing loadable.
				loadable.removeEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onLoadStateChange
					);
					
				if (loadable.loadState == LoadState.READY)
				{	    			   
					loadable.unload();	 
				}
				
				removeTrait(MediaTraitType.LOADABLE);
			}
			
			// Add a new loadable for the current resource.
			loadable = new LoadableTrait(loader, resource);
			loadable.addEventListener
				( LoadEvent.LOAD_STATE_CHANGE
				, onLoadStateChange, false, 10 //Using a higher priority event listener in order to process load state changes before clients.
				);
			
			addTrait(MediaTraitType.LOADABLE, loadable);
		}

		private var loader:ILoader;
	}
}