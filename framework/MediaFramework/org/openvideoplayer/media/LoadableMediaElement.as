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
package org.openvideoplayer.media
{
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * A base implementation of a MediaElement that has the ILoadable trait.
	 **/
	public class LoadableMediaElement extends MediaElement
	{
		/**
		 * Constructor.
		 * 
		 * <p>A MediaElement must provide a default (empty) constructor, since
		 * it can get created by a factory that is unaware of the specific
		 * initialization parameters.</p>
		 * 
		 * @param loader Loader used to load the media.
		 * itself.
		 * @param resource The IMediaResource that represents the piece of
		 * media to load into this media element.
		 **/
		public function LoadableMediaElement(loader:ILoader=null, resource:IMediaResource=null)
		{
			super();			
			if (loader)
			{				
				this.resource = resource;
				initialize([loader]);				
			}			
		}
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function set resource(value:IMediaResource):void
	    {    	
	    	if (value != resource)
	    	{
	    		super.resource = value;
	    		var loadable:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
	    		if (loadable != null)
	    		{	
	    			loadable.removeEventListener
						( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
						, onLoadableStateChange
						);
					if (loadable.loadState == LoadState.LOADED)
					{	    			   
	    				loadable.unload();	 
	   				}
	    			removeTrait(MediaTraitType.LOADABLE);
	    			
	    			initialize([loader]);		    			    		
		    	}			    	
		    }
	    }

		// Overrides
		//
		
		/**
		 * @private
		 **/
		override public function initialize(value:Array):void
		{
			if (value && value.length > 0)
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
			else
			{
				super.initialize(value);
			}
		}
				
		// Protected
		//
		
		/**
		 * Subclasses can override this method to do processing when the media
		 * element enters the LOADED state.
		 **/
		protected function processLoadedState():void
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
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			// The asymmetry between LOADED and UNLOADING (versus UNLOADED) is
			// motivated by the fact that once a media is already unloaded, one
			// cannot reference it any longer. Triggering the event upfront the
			// actual unload being effectuated allows listeners to still act on
			// the media that is about to be unloaded.
			
			if (event.newState == LoadState.LOADED)
			{
				processLoadedState();
			}
			else if (event.newState == LoadState.UNLOADING)
			{
				processUnloadingState();
			}
		}
		
		private var loader:ILoader;
	}
}