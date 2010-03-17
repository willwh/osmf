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
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * A base implementation of a MediaElement that has a LoadTrait.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class LoadableElementBase extends MediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param resource The MediaResourceBase that represents the piece of
		 * media to load into this media element.
		 * @param loader Loader used to load the media.  If null, the loader will
		 * be dynamically generated from the loaderClasses Array based on the type
		 * of the resource.
		 * @param loaderClasses An Array of Class objects representing all possible
		 * LoaderBase classes that this MediaElement can use to load media.  If null,
		 * then loader must be specified (and will be used for all resources).  When
		 * the appropriate loader to use is unknown (e.g. because loader is null),
		 * this list will be used to locate and set the appropriate loader.  Note
		 * that multiple loaders in the list might be able to handle a resource,
		 * in which case the first loader in the list to do so will be selected.  If
		 * no loader in the list can handle a resource, then the last one will
		 * be set (simply so that errors are generated consistently).
		 * 
		 * @throws ArgumentError If both loader and loaderClasses are null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function LoadableElementBase(resource:MediaResourceBase=null, loader:LoaderBase=null, loaderClasses:Array=null)
		{
			super();
			
			if (loader == null && loaderClasses == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			this.loader = loader;
			this.loaderClasses = loaderClasses || [];
			this.resource = resource;
		}
		
		/**
		 * @private
		 */
		override public function set resource(value:MediaResourceBase):void
	    {
			super.resource = value;
			
			setLoaderForResource(value);
			
			updateLoadTrait();
		}
		
		// Protected
		//
		
		/**
		 * Subclasses can override this method to return a custom LoadTrait
		 * subclass.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function createLoadTrait(resource:MediaResourceBase, loader:LoaderBase):LoadTrait
		{
			return new LoadTrait(loader, resource);
		}
				
		/**
		 * 
		 * Subclasses can override this method to do processing when the media
		 * element enters the LOADING state.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function processLoadingState():void
		{
			// Subclass stub
		}
		
		/**
		 * Subclasses can override this method to do processing when the media
		 * element enters the READY state.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function processReadyState():void
		{
			// Subclass stub
		}
		
		/**
		 * Subclasses can override this method to do processing when the media
		 * element enters the UNLOADING state.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
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

		/**
		 * Given a resource, this method will locate the first LoaderBase which can handle
		 * the resource and set it as the LoaderBase for this class.  Gives precedence to
		 * the current loader first, then the constructor-supplied loaderClasses, in order.
		 **/
		private function setLoaderForResource(resource:MediaResourceBase):void
		{
			if (resource != null && (loader == null || loader.canHandleResource(resource) == false))
			{
				// Don't call canHandleResource twice on the same loader.
				var loaderFound:Boolean = false;
				
				for each (var loaderClass:Class in loaderClasses)
				{
					// Skip this one if it's the same type as the current loader.
					if (loader == null || !(loader is loaderClass))
					{
						var iterLoader:LoaderBase = new loaderClass() as LoaderBase;
						if (iterLoader.canHandleResource(resource))
						{
							loader = iterLoader;
							break;
						}
					}
				}
				
				// If none was found that can handle the resource, pick the
				// last one, if only so that errors will be dispatched
				// further downstream.
				if (loader == null)
				{
					loaderClass = loaderClasses[loaderClasses.length - 1];
					loader = new loaderClass() as LoaderBase;
				}
			}
		}

		private function updateLoadTrait():void
		{
			var loadTrait:LoadTrait = getTrait(MediaTraitType.LOAD) as LoadTrait;
			if (loadTrait != null)
			{
				// Remove (and unload) any existing LoadTrait.
				if (loadTrait.loadState == LoadState.READY)
				{	    			   
					loadTrait.unload();	 
				}

				loadTrait.removeEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onLoadStateChange
					);
				
				removeTrait(MediaTraitType.LOAD);
			}
			
			if (loader != null)
			{
				// Add a new LoadTrait for the current resource.
				loadTrait = createLoadTrait(resource, loader);
				loadTrait.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onLoadStateChange, false, 10 // Using a higher priority event listener in order to process load state changes before clients.
					);
				
				addTrait(MediaTraitType.LOAD, loadTrait);
			}
		}

		private var loader:LoaderBase;
		private var loaderClasses:Array;
	}
}