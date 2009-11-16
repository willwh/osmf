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
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import org.osmf.events.LoaderEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.utils.MediaFrameworkStrings;
	
	/**
	 * Dispatched when the state of an ILoadable being loaded or unloaded by
	 * the ILoader has changed.
	 *
	 * @eventType org.osmf.events.LoaderEvent.STATE_CHANGE
	 **/
	[Event(name="loaderStateChange", type="org.osmf.events.LoaderEvent")]
	
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
		 * If this method is overridden, the subclass must call super.load() in order
		 * to validate the load.
		 **/
		public function load(loadable:ILoadable):void
		{
			validateLoad(loadable);
		}
		
		/**
		 * If this method is overridden, the subclass must call super.unload() in order
		 * to validate the unload.  The Loadable's loadState is set to LoadState.UNINITIALIZED.
		 **/
		public function unload(loadable:ILoadable):void
		{
			validateUnload(loadable);		
		}
				
		// Protected
		
		/**
		 * Updates the given loadable with the given info, dispatching the
		 * appropriate events.
		 * 
		 * @param loadable The loadable to update.
		 * @param newState The new LoadState of the loadable.
		 * @param loadedContext The loaded context (if any) of the loadable.
		 **/
		protected function updateLoadable(loadable:ILoadable, newState:String, loadedContext:ILoadedContext=null):void
		{
			if (newState != loadable.loadState)
			{
				if (newState == LoadState.READY && loadedContext == null)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.LOADED_CONTEXT_NULL);
				}
				if (newState == LoadState.UNINITIALIZED && loadedContext != null)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.LOADED_CONTEXT_NOT_NULL);
				}
				
				var oldState:String = loadable.loadState;
				
				loadable.loadedContext = loadedContext;
				loadable.loadState = newState;
				
				dispatchEvent
					( new LoaderEvent
						( LoaderEvent.LOADABLE_STATE_CHANGE
						, false
						, false
						, this
						, loadable
						, oldState
						, newState
						, loadedContext
						)
					);
			}
		}
		
		/**
		 * Validates that the given ILoadable can be loaded.  Subclasses
		 * should call this method as the first step in their
		 * <code>load</code> implementation.
		 **/
		private function validateLoad(loadable:ILoadable):void
		{
			if (loadable == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			if (loadable.loadState == LoadState.READY)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_READY);
			}
			if (loadable.loadState == LoadState.LOADING)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_LOADING);
			}
			if (canHandleResource(loadable.resource) == false)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ILOADER_CANT_HANDLE_RESOURCE);
			}
		}

		
		/**
		 * Validates that the given ILoadable can be unloaded.  Subclasses
		 * should call this method as the first step in their
		 * <code>unload</code> implementation.
		 **/
		private function validateUnload(loadable:ILoadable):void
		{
			if (loadable == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			if (loadable.loadState == LoadState.UNLOADING)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADING);
			}
			if (loadable.loadState == LoadState.UNINITIALIZED)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADED);
			}
			if (canHandleResource(loadable.resource) == false)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ILOADER_CANT_HANDLE_RESOURCE);
			}
		}
	}
}