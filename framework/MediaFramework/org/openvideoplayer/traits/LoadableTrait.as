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
package org.openvideoplayer.traits
{
	import flash.errors.IllegalOperationError;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when the state of the ILoadable has changed.
	 *
	 * @eventType org.openvideoplayer.events.LoadableEvent.LOADABLE_STATE_CHANGE
	 **/
	[Event(name="loadableStateChange", type="org.openvideoplayer.events.LoadableStateChangeEvent")]

	/**
	 * The LoadableTrait class provides a base ILoadable implementation.
	 * 
	 * It can be used as the base class for a more specific loadable trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 * <p>As an alternative to adding a LoadableTrait to a MediaElement, you can subclass the
	 * LoadableMediaElement class. This class instantiates and sets up its own LoadableTrait.</p>
	 * 
	 * @see org.openvideoplayer.media.LoadableMediaElement
	 */	
	public class LoadableTrait extends MediaTraitBase implements ILoadable
	{
		/**
		 * Constructor.
		 * 
		 * @param loader The ILoader instance that will be used to load the
		 * media for the media element that owns this trait.
		 * @param resource The IMediaResource instance that represents the media resource 
		 * to be loaded.
		 * 
		 */		
		public function LoadableTrait(loader:ILoader,resource:IMediaResource)
		{			
			this.loader = loader;			
			_resource = resource;
			_loadState = LoadState.CONSTRUCTED;
		}
		
		// ILoadable
		//
		
		/**
		 * Resource representing the piece of media to be loaded into
		 * this loadable trait.
		 **/
		public function get resource():IMediaResource
		{
			return _resource;
		}
		
		/**
		 * The load state of this trait.
		 **/
		public function get loadState():LoadState
		{
			return _loadState;
		}
		
		final public function set loadState(value:LoadState):void
		{
			if (_loadState != value)
			{
				var oldState:LoadState = _loadState;
				_loadState = value;
				
				dispatchEvent(new LoadableStateChangeEvent(oldState, _loadState));
			}
		}
		
		/**
		 * The context resulting from this trait's successful <code>load()</code>
		 * operation.
		 * 
         * <p>The context is <code>null</code> before this trait's state is <code>LOADED</code> 
		 * and after the media has been unloaded.</p>
		 **/
 		public function get loadedContext():ILoadedContext
		{
			return _loadedContext;
		}
		
		public function set loadedContext(value:ILoadedContext):void
		{
			_loadedContext = value;
		}

		/**
		 * Loads this the media into this loadable trait.
		 * Updates the load state.
         * Dispatches the <code>loadableStateChange</code> event with every state change.
         *
         * <p>Typical states are <code>LOADING</code> while the media is loading,
         * <code>LOADED</code> after it has successfully completed loading, 
         * and <code>LOAD_FAILED</code> if it fails to complete loading.</p>
		 * 
         * <p>If the LoadState is <code>LOADING</code> or <code>LOADED</code>
         * when the method is called, throws an error.</p>
         *  
         * @see LoadState
		 * @throws IllegalOperationError If this trait is unable to load
		 * itself or if the LoadState is <code>LOADING</code> or
         * <code>LOADED</code>.
		 **/
		public function load():void
		{
			if (loader)
			{	
				if(_loadState == LoadState.LOADED)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_LOADED);
				}
				if(_loadState == LoadState.LOADING)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_LOADING);
				}
				else
				{
					loader.load(this);
				}
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.MUST_SET_ILOADER_FOR_LOAD);
			}
		}
		
		/**
         * Unloads this loadable trait. Updates the load state.
         * Dispatches the <code>loadableStateChange</code> event with every state change.
		 * 
         * <p>Typical states are <code>UNLOADING</code> while the mediae is unloading,
         * <code>CONSTRUCTED</code> after it has successfully completed unloading, 
         * and <code>LOAD_FAILED</code> if it fails to complete unloading.</p>
		 * 
 		 * <p>If the LoadState is not <code>LOADED</code> when the
 		 * method is called, throws an error.</p>
		 * 
		 * @param loadable The loadable trait to unload.
         * @see LoadState
		 * 
		 * @throws IllegalOperationError If this trait is unable to unload
		 * itself, or if the LoadState is not <code>LOADED</code>.
		 **/
		public function unload():void
		{
			if (loader)
			{	
				if (_loadState == LoadState.UNLOADING)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADING);
				}
				if (_loadState == LoadState.CONSTRUCTED)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADED);
				}
				loader.unload(this);
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.MUST_SET_ILOADER_FOR_UNLOAD);
			}
		}
		
		// Internals
		//
		
		private var loader:ILoader;
		private var _resource:IMediaResource;
		
		private var _loadState:LoadState;
		private var _loadedContext:ILoadedContext;
	}
}