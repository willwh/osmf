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
package org.openvideoplayer.loaders
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.ILoadedContext;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	
	/**
	 * Dispatched when the state of an ILoadable being loaded or unloaded by
	 * the ILoader has changed.
	 *
	 * @eventType org.openvideoplayer.events.LoaderEvent.STATE_CHANGE
	 **/
	[Event(name="loaderStateChange", type="org.openvideoplayer.events.LoaderEvent")]
	
	/**
	 * Default implementation of ILoader.
	 */	 
	public class LoaderBase extends EventDispatcher implements ILoader
	{
		// IMediaResourceHandler
		//
		
		/**
		 * @private
		 **/
		public function canHandleResource(resource:IMediaResource):Boolean
		{
			return false;
		}

		// ILoader
		//
						
		/**
		 * @private
		 **/
		public function load(loadable:ILoadable):void
		{
		}
		
		/**
		 * @private
		 **/
		public function unload(loadable:ILoadable):void
		{
		}
		
		// Protected
		//
		
		/**
		 * Validates that the given ILoadable can be loaded.  Subclasses
		 * should call this method as the first step in their
		 * <code>load</code> implementation.
		 **/
		protected function validateLoad(loadable:ILoadable):void
		{
			if (loadable == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			if (loadable.loadState == LoadState.LOADED)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_LOADED);
			}
			if (loadable.loadState == LoadState.LOADING)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_LOADING);
			}
			if (canHandleResource(loadable.resource) == false)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ILOADER_CANT_HANDLER_RESOURCE);
			}
		}

		
		/**
		 * Validates that the given ILoadable can be unloaded.  Subclasses
		 * should call this method as the first step in their
		 * <code>unload</code> implementation.
		 **/
		protected function validateUnload(loadable:ILoadable):void
		{
			if (loadable == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			if (loadable.loadState == LoadState.UNLOADING)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADING);
			}
			if (loadable.loadState == LoadState.CONSTRUCTED)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADED);
			}
			if (canHandleResource(loadable.resource) == false)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ILOADER_CANT_HANDLER_RESOURCE);
			}
		}
		
		/**
		 * Updates the given loadable with the given info, dispatching the
		 * appropriate events.
		 * 
		 * @param loadable The loadable to update.
		 * @param newState The new state of the loadable.
		 * @param loadedContext The loaded context (if any) of the loadable.
		 **/
		protected function updateLoadable(loadable:ILoadable, newState:LoadState, loadedContext:ILoadedContext=null):void
		{
			if (newState != loadable.loadState)
			{
				var oldState:LoadState = loadable.loadState;
				
				loadable.loadedContext = loadedContext;
				loadable.loadState = newState;
				
				dispatchEvent(new LoaderEvent(this, loadable, oldState, newState, loadedContext));
			}
		}
	}
}