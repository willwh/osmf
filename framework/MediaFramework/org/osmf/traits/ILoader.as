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
package org.osmf.traits
{
	import org.osmf.media.IMediaResourceHandler;
	
	import flash.events.IEventDispatcher;

	/**
	 * Dispatched when the state of an ILoadable being loaded or unloaded by
	 * the ILoader has changed.
	 *
	 * @eventType org.osmf.loader.events.LoaderEvent.STATE_CHANGE
	 **/
	[Event(name="loadableStateChange", type="org.osmf.events.LoaderEvent")]

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
         * @see org.osmf.traits.LoadState
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
         * @see org.osmf.traits.LoadState
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