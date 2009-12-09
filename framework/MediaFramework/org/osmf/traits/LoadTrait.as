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
	import org.osmf.events.LoaderEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Dispatched when the state of the LoadTrait has changed.
	 *
	 * @eventType org.osmf.events.LoadEvent.LOAD_STATE_CHANGE
	 **/
	[Event(name="loadStateChange", type="org.osmf.events.LoadEvent")]

	/**
	 * Dispatched when total size in bytes of data being loaded has changed.
	 * 
	 * @eventType org.osmf.events.LoadEvent.BYTES_TOTAL_CHANGE
	 */	
	[Event(name="bytesTotalChange",type="org.osmf.events.LoadEvent")]

	/**
	 * LoadTrait defines the trait interface for media that must be loaded before it
	 * can be presented.  It can also be used as the base class for a more specific
	 * LoadTrait subclass.
	 * 
	 * <p>The load operation takes an IMediaResource as input and produces an
	 * ILoadedContext as output.</p>
	 * 
	 * <p>If <code>hasTrait(MediaTraitType.LOAD)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.LOAD)</code> method
	 * to get an object of this type.</p>
	 * <p>Through its MediaElement, a LoadTrait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * @see LoadState
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 */
	public class LoadTrait extends MediaTraitBase
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
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function LoadTrait(loader:ILoader, resource:IMediaResource)
		{
			super(MediaTraitType.LOAD);
			
			this.loader = loader;			
			_resource = resource;
			_loadState = LoadState.UNINITIALIZED;
			
			if (loader != null)
			{
				// We set the highest possible priority to ensure that our handler
				// is the first to process the ILoader's event.  The reason for this
				// is to ensure that clients that work with both an ILoader and a
				// LoadTrait always perceive a consistent state between the two (which
				// could be subverted if the ILoader updates its state, then the client
				// gets the event, then the LoadTrait updates its state).
				loader.addEventListener(LoaderEvent.LOAD_STATE_CHANGE, onLoadStateChange, false, int.MAX_VALUE, true);
			}
		}
		
		/**
		 * Resource representing the piece of media to be loaded into
		 * this LoadTrait.
		 **/
		public function get resource():IMediaResource
		{
			return _resource;
		}
		
		/**
		 * The load state of this trait.  See LoadState for possible values.
		 **/
		public function get loadState():String
		{
			return _loadState;
		}
		
		/**
		 * The context resulting from this trait's successful <code>load()</code>
		 * operation.
		 * 
         * <p>The context is <code>null</code> before this object's loadState is
         * <code>LOADING</code> or <code>READY</code>, depending on the loader
         * implementation at hand. The context is <code>null</code> after the
         * LoadTrait has been unloaded.</p>
		 **/
 		public function get loadedContext():ILoadedContext
		{
			return _loadedContext;
		}
		
		/**
		 * Loads this the media into this LoadTrait.
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
         * Unloads this LoadTrait. Updates the load state.
         * Dispatches the <code>loadStateChange</code> event with every state change.
		 * 
         * <p>Typical states are <code>UNLOADING</code> while the media is unloading,
         * <code>UNINITIALIZED</code> after it has successfully completed unloading, 
         * and <code>LOAD_ERROR</code> if it fails to complete unloading.</p>
		 * 
 		 * <p>If the LoadState is not <code>READY</code> when the
 		 * method is called, throws an error.</p>
		 * 
		 * @param loadTrait The LoadTrait to unload.
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
		
		/**
		 * The number of bytes of data that have been loaded.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		/**
		 * The total size in bytes of the data being loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		// Internals
		//
		
		/**
		 * Sets the load state and (optionally) the loaded context for this LoadTrait.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected final function setLoadStateAndContext(newState:String, newContext:ILoadedContext):void
		{
			if (_loadState != newState)
			{
				processLoadStateChange(newState, newContext);
				
				_loadState = newState;
				_loadedContext = newContext;
				
				postProcessLoadStateChange();				
			}
		}
		
		/**
		 * Sets the number of bytes of data that have been loaded.
		 *  
		 * @throws ArgumentError If value is negative, NaN, or greater than bytesTotal.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected final function setBytesLoaded(value:Number):void
		{
			if (isNaN(value) || value > bytesTotal || value < 0)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			if (value != _bytesLoaded)
			{
				processBytesLoadedChange(value);
				
				_bytesLoaded = value;
				
				postProcessBytesLoadedChange();
			}
		}
		
		/**
		 * Sets the total size in bytes of the data being loaded.
		 *  
		 * @throws ArgumentError If value is negative or smaller than bytesLoaded.
		 * 
		 * @see canProcessBytesTotalChange
		 * @see processBytesTotalChange
		 * @see postProcessBytesTotalChange
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function setBytesTotal(value:Number):void
		{
			if (value < _bytesLoaded || value < 0)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}

			if (value != _bytesTotal)
			{
				processBytesTotalChange(value);
				
				_bytesTotal = value;
				
				postProcessBytesTotalChange();
			}
		}
		
		/**
		 * Called immediately before the <code>bytesLoaded</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newValue New <code>bytesLoaded</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function processBytesLoadedChange(newValue:Number):void
		{
		}

		/**
		 * Called immediately before the <code>bytesTotal</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newValue New <code>bytesTotal</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function processBytesTotalChange(newValue:Number):void
		{
		}

		/**
		 * Called immediately before the <code>loadState</code> and <code>loadedContext</code>
		 * properties are changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newState New <code>loadState</code> value.
		 * @param newContext New <code>loadedContext</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function processLoadStateChange(newState:String, newContext:ILoadedContext):void
		{
		}

		/**
		 * Called just after the <code>bytesLoaded</code> property has changed.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessBytesLoadedChange():void
		{
		}

		/**
		 * Called just after the <code>bytesTotal</code> property has changed.
		 * Dispatches the bytesTotalChange event.
		 * <p>Subclasses that override should call this method to
		 * dispatch the bytesTotalChange event.</p>
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessBytesTotalChange():void
		{
			dispatchEvent(new LoadEvent(LoadEvent.BYTES_TOTAL_CHANGE, false, false, null, _bytesTotal));
		}
		
		/**
		 * Called just after the <code>loadState</code> and <code>loadedContext</code>
		 * properties are changed.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessLoadStateChange():void
		{
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_STATE_CHANGE, false, false, _loadState));
		}
		
		private function onLoadStateChange(event:LoaderEvent):void
		{
			if (event.loadTrait == this)
			{
				setLoadStateAndContext(event.newState, event.loadedContext);
			}
		}

		private var loader:ILoader;
		private var _resource:IMediaResource;
		
		private var _loadState:String;
		private var _loadedContext:ILoadedContext;

		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
	}
}