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
	import org.osmf.media.MediaResourceBase;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * Dispatched when the state of an LoadTrait being loaded or unloaded by
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
		// MediaResourceBaseHandler
		//
		
		/**
		 * @private
		 **/
		public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			return false;
		}

		// ILoader
		//
						
		/**
		 * If this method is overridden, the subclass must call super.load() in order
		 * to validate the load.
		 **/
		public function load(loadTrait:LoadTrait):void
		{
			validateLoad(loadTrait);
		}
		
		/**
		 * If this method is overridden, the subclass must call super.unload() in order
		 * to validate the unload.  The LoadTrait's loadState is set to LoadState.UNINITIALIZED.
		 **/
		public function unload(loadTrait:LoadTrait):void
		{
			validateUnload(loadTrait);		
		}
				
		// Protected
		
		/**
		 * Updates the given LoadTrait with the given info, dispatching the
		 * appropriate events.
		 * 
		 * @param loadTrait The LoadTrait to update.
		 * @param newState The new LoadState of the LoadTrait.
		 * @param loadedContext The loaded context (if any) of the LoadTrait.
		 **/
		protected function updateLoadTrait(loadTrait:LoadTrait, newState:String, loadedContext:ILoadedContext=null):void
		{
			if (newState != loadTrait.loadState)
			{
				if (newState == LoadState.READY && loadedContext == null)
				{
					throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.LOADED_CONTEXT_NULL));
				}
				if (newState == LoadState.UNINITIALIZED && loadedContext != null)
				{
					throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.LOADED_CONTEXT_NOT_NULL));
				}
				
				var oldState:String = loadTrait.loadState;
				
				dispatchEvent
					( new LoaderEvent
						( LoaderEvent.LOAD_STATE_CHANGE
						, false
						, false
						, this
						, loadTrait
						, oldState
						, newState
						, loadedContext
						)
					);
			}
		}
		
		/**
		 * Validates that the given LoadTrait can be loaded.
		 **/
		private function validateLoad(loadTrait:LoadTrait):void
		{
			if (loadTrait == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			if (loadTrait.loadState == LoadState.READY)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_READY));
			}
			if (loadTrait.loadState == LoadState.LOADING)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_LOADING));
			}
			if (canHandleResource(loadTrait.resource) == false)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ILOADER_CANT_HANDLE_RESOURCE));
			}
		}

		
		/**
		 * Validates that the given LoadTrait can be unloaded.
		 **/
		private function validateUnload(loadTrait:LoadTrait):void
		{
			if (loadTrait == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			if (loadTrait.loadState == LoadState.UNLOADING)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_UNLOADING));
			}
			if (loadTrait.loadState == LoadState.UNINITIALIZED)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_UNLOADED));
			}
			if (canHandleResource(loadTrait.resource) == false)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ILOADER_CANT_HANDLE_RESOURCE));
			}
		}
	}
}