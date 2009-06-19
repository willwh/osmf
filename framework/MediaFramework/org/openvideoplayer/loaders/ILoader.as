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
	import org.openvideoplayer.media.IMediaResourceHandler;
	import org.openvideoplayer.traits.ILoadable;
	
	import flash.events.IEventDispatcher;

	/**
	 * Dispatched when the state of an ILoadable being loaded or unloaded by
	 * the ILoader has changed.
	 *
	 * @eventType org.openvideoplayer.loader.events.LoaderEvent.STATE_CHANGE
	 **/
	[Event(name="loadableStateChange", type="org.openvideoplayer.events.LoaderEvent")]

	/**
	 * An ILoader is an object that is capable of loading and unloading an ILoadable.
	 * 
	 * <p>A MediaElement that has the ILoadable trait uses an ILoader to perform the
	 * actual load operation.
	 * This decoupling of the loading and unloading from the media allows a 
	 * MediaElement to use different loaders for different circumstances.</p>
	 */	
	public interface ILoader extends IMediaResourceHandler, IEventDispatcher 
	{
		/**
         * Loads the specified ILoadable. Changes the load state of the ILoadable.
         * Dispatches the <code>loaderStateChange</code> event with every state change.
		 * 
         * <p>Typical states are <code>LOADING</code> while the ILoadable is loading,
         * <code>LOADED</code> after it has successfully completed loading, 
         * and <code>LOAD_FAILED</code> if it fails to complete loading.</p>
         * 
         * <p>If the ILoadable's LoadState is <code>LOADING</code> or
         * <code>LOADED</code> when the method is called, this method throws
         * an error.</p>
         * 
         * @see org.openvideoplayer.traits.LoadState
		 * 
		 * @param loadable The ILoadable to load.
		 * 
		 * @throws IllegalOperationError <code>IllegalOperationError</code>
		 * If this loader cannot load the given ILoadable (as determined by
         * the <code>IMediaResourceHandler.canHandleResource()</code> method),
         * or if the ILoadable's LoadState is <code>LOADING</code> or
         * <code>LOADED</code>.
		 **/
		function load(loadable:ILoadable):void;
		 
		/**
         * Unloads the specified ILoadable. Changes the load state of the ILoadable.
         * Dispatches the <code>loaderStateChange</code> event with every state change.
		 * 
         * <p>Typical states are <code>UNLOADING</code> while the ILoadable is unloading,
         * <code>CONSTRUCTED</code> after it has successfully completed unloading, 
         * and <code>LOAD_FAILED</code> if it fails to complete unloading.</p>
         * 
         * <p>If the ILoadable's LoadState is not <code>LOADED</code> when the method
         * is called, this method throws an error.</p>
         * 
         * @see org.openvideoplayer.traits.LoadState
		 * 
		 * @param loadable The ILoadable to unload.
		 * 
		 * @throws IllegalOperationError <code>IllegalOperationError</code>
		 * If this loader cannot unload the specified ILoadable (as determined by
         * the <code>IMediaResourceHandler.canHandleResource()</code> method),
         * or if the ILoadable's LoadState is not <code>LOADED</code>.
		 **/
		function unload(loadable:ILoadable):void;
	}
}