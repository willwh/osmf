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
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Dispatched when the state of the ILoadable has changed.
	 *
	 * @eventType org.osmf.events.LoadEvent.LOAD_STATE_CHANGE
	 **/
	[Event(name="loadStateChange", type="org.osmf.events.LoadEvent")]

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
	 * @see org.osmf.media.LoadableMediaElement
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function LoadableTrait(loader:ILoader, resource:IMediaResource)
		{			
			this.loader = loader;			
			_resource = resource;
			_loadState = LoadState.UNINITIALIZED;
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
		
		public function set resource(value:IMediaResource):void
		{
			_resource = value;
		}
		
		/**
		 * The load state of this trait.
		 **/
		public function get loadState():String
		{
			return _loadState;
		}
		
		final public function set loadState(value:String):void
		{
			if (_loadState != value)
			{
				_loadState = value;
				
				dispatchEvent(new LoadEvent(LoadEvent.LOAD_STATE_CHANGE, false, false, _loadState));
			}
		}
		
		/**
		 * The context resulting from this trait's successful <code>load()</code>
		 * operation.
		 * 
         * <p>The context is <code>null</code> before this trait's state is <code>READY</code> 
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
         * Dispatches the <code>loadStateChange</code> event with every state change.
         *
         * <p>Typical states are <code>LOADING</code> while the media is loading,
         * <code>READY</code> after it has successfully completed loading, 
         * and <code>LOAD_ERROR</code> if it fails to complete loading.</p>
		 * 
         * <p>If the LoadState is <code>LOADING</code> or <code>READY</code>
         * when the method is called, throws an error.</p>
         *  
         * @see LoadState
		 * @throws IllegalOperationError If this trait is unable to load
		 * itself or if the LoadState is <code>LOADING</code> or
         * <code>READY</code>.
		 **/
		public function load():void
		{
			if (loader)
			{	
				if (_loadState == LoadState.READY)
				{
					throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_READY));
				}
				if (_loadState == LoadState.LOADING)
				{
					throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_LOADING));
				}
				else
				{
					loader.load(this);
				}
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.MUST_SET_ILOADER_FOR_LOAD));
			}
		}
		
		/**
         * Unloads this loadable trait. Updates the load state.
         * Dispatches the <code>loadStateChange</code> event with every state change.
		 * 
         * <p>Typical states are <code>UNLOADING</code> while the media is unloading,
         * <code>UNINITIALIZED</code> after it has successfully completed unloading, 
         * and <code>LOAD_ERROR</code> if it fails to complete unloading.</p>
		 * 
 		 * <p>If the LoadState is not <code>READY</code> when the
 		 * method is called, throws an error.</p>
		 * 
		 * @param loadable The loadable trait to unload.
         * @see LoadState
		 * 
		 * @throws IllegalOperationError If this trait is unable to unload
		 * itself, or if the LoadState is not <code>READY</code>.
		 **/
		public function unload():void
		{
			if (loader)
			{	
				if (_loadState == LoadState.UNLOADING)
				{
					throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_UNLOADING));
				}
				if (_loadState == LoadState.UNINITIALIZED)
				{
					throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ALREADY_UNLOADED));
				}
				loader.unload(this);
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.MUST_SET_ILOADER_FOR_UNLOAD));
			}
		}
		
		// Internals
		//
		
		private var loader:ILoader;
		private var _resource:IMediaResource;
		
		private var _loadState:String;
		private var _loadedContext:ILoadedContext;
	}
}