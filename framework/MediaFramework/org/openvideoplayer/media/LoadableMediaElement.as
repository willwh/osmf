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