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
package org.osmf.composition
{
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * Implementation of ILoadable which can be a composite media trait.
	 **/
	internal class CompositeLoadableTrait extends CompositeMediaTraitBase implements ILoadable
	{
		/**
		 * Constructor.
		 * 
		 * @param traitAggregator The object which is aggregating all instances
		 * of the ILoadable trait within this composite trait.
		 * @param mode The composition mode to which this composite trait
		 * should adhere.  See CompositionMode for valid values.
		 **/
		public function CompositeLoadableTrait(traitAggregator:TraitAggregator, mode:CompositionMode)
		{
			this.mode = mode;
			
			super(MediaTraitType.LOADABLE, traitAggregator);
		}
		
		/**
		 * @inheritDoc
		 **/
		public function get resource():IMediaResource
		{
			var value:IMediaResource = null;
			
			// For serial compositions, expose the resource of the current
			// child.  For parallel compositions, no return value makes
			// sense.
			if (mode == CompositionMode.SERIAL)
			{
				if (traitAggregator.listenedChild != null)
				{
					value = traitAggregator.listenedChild.resource;
				}
			}
			
			return value;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function get loadState():LoadState
		{
			return _loadState;
		}
		
		public function set loadState(value:LoadState):void
		{
			// No op -- setting the loadState doesn't apply to a composite
			// trait.
		}

		/**
		 * @inheritDoc
		 **/
		public function load():void
		{
			if (mode == CompositionMode.PARALLEL)
			{
				// Call load() on all not-yet-loaded children.
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					     var loadable:ILoadable = ILoadable(mediaTrait);
					     if (loadable.loadState != LoadState.LOADING &&
					     	 loadable.loadState != LoadState.LOADED)
					     {
					     	loadable.load();
					     }
					  }
					, MediaTraitType.LOADABLE
					);
			}
			else // SERIAL
			{
				// Call load() on the current child only.
				var currentLoadable:ILoadable = traitOfCurrentChild;
				if (currentLoadable != null &&
					currentLoadable.loadState != LoadState.LOADING &&
				    currentLoadable.loadState != LoadState.LOADED)
				{
					currentLoadable.load();
				}
			}
		}

		/**
         * @inheritDoc
		 **/
		public function unload():void
		{
			if (mode == CompositionMode.PARALLEL)
			{
				// Call unload() on all not-yet-unloaded children.
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					     var loadable:ILoadable = ILoadable(mediaTrait);
					     if (loadable.loadState == LoadState.LOADING ||
					     	 loadable.loadState == LoadState.LOADED)
					     {
					     	loadable.unload();
					     }
					  }
					, MediaTraitType.LOADABLE
					);
			}
			else // SERIAL
			{
				// Call unload() on the current child only.
				var currentLoadable:ILoadable = traitOfCurrentChild;
				if (currentLoadable != null &&
					currentLoadable.loadState == LoadState.LOADING ||
					currentLoadable.loadState == LoadState.LOADED)
				{
					currentLoadable.unload();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 **/
		public function get loadedContext():ILoadedContext
		{
			return _loadedContext;
		}
		
		public function set loadedContext(value:ILoadedContext):void
		{
			// No op -- a loaded context doesn't apply to a composite trait.
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			child.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChanged, false, 0, true);
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (traitAggregator.getNumTraits(MediaTraitType.LOADABLE) == 1)
				{
					// The first added child's properties are applied to the
					// composite trait.
					syncToLoadState((child as ILoadable).loadState);
				}
				else
				{
					// All subsequently added children inherit their properties
					// from the composite trait.
					syncToLoadState(loadState);
				}
			}
			else if (child == traitOfCurrentChild)
			{
				// The first added child's properties are applied to the
				// composite trait.
				syncToLoadState((child as ILoadable).loadState);
			}
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			child.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChanged);
		}
		
		// Internals
		//
		
		private function onLoadableStateChanged(event:LoadableStateChangeEvent):void
		{
			// For parallel compositions and for the current child in a serial
			// composition, changes from the child propagate to the composite
			// trait.
			if (mode == CompositionMode.PARALLEL ||
				event.target == traitOfCurrentChild)
			{
				syncToLoadState(event.newState);
			}
		}
		
		private function syncToLoadState(newState:LoadState):void
		{
			// If the state to apply is LOADED or LOADING, then we load the
			// composition as a whole.  The already-loaded parts will be
			// ignored.
			if (newState == LoadState.LOADING ||
				newState == LoadState.LOADED)
			{
				load();
			}
			// If the state to apply is CONSTRUCTED or UNLOADING, then we
			// unload the composition as a whole.  The already-unloaded parts
			// will be ignored.
			else if (newState == LoadState.CONSTRUCTED ||
					 newState == LoadState.UNLOADING)
			{
				unload();
			}
			
			updateLoadState();
		}

		private function updateLoadState():void
		{
			var newState:LoadState;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// Examine all child traits to find out the state that best
				// represents the composite trait.  This state is based on some
				// simple rules about the precedence of states in relation to each
				// other.
				var loadStateInt:int = int.MAX_VALUE;
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					  	 // Find the state with the lowest value.
					     loadStateInt
					     	= Math.min
					     		( loadStateInt
					     		, getIntegerForLoadState(ILoadable(mediaTrait).loadState)
					     		);
					  }
					, MediaTraitType.LOADABLE
					);
				
				// Convert the integer back to the composite state.
				newState = 
					   getLoadStateForInteger(loadStateInt)
					|| LoadState.CONSTRUCTED;
			}
			else // SERIAL
			{
				var currentLoadable:ILoadable = traitOfCurrentChild;
				newState = currentLoadable
						 ? currentLoadable.loadState
						 : LoadState.CONSTRUCTED;
			}
			
			// Ensure that the composition's load state is consistent with
			// the new value.
			if (_loadState != newState)
			{
				var oldState:LoadState = _loadState;
				_loadState = newState;
				
				dispatchEvent(new LoadableStateChangeEvent(oldState, _loadState));
			}
		}
		
		private function getIntegerForLoadState(loadState:LoadState):int
		{
			if (loadState == LoadState.CONSTRUCTED) 	return CONSTRUCTED_INT;
			if (loadState == LoadState.LOADING)  		return LOADING_INT;
			if (loadState == LoadState.UNLOADING)   	return UNLOADING_INT;
			if (loadState == LoadState.LOADED)		 	return LOADED_INT;
			/*  loadState == LoadState.LOAD_FAILED*/ 	return LOAD_FAILED_INT;
		}
		
		private function getLoadStateForInteger(i:int):LoadState
		{
			if (i == CONSTRUCTED_INT) return LoadState.CONSTRUCTED;
			if (i == LOADING_INT)	  return LoadState.LOADING;
			if (i == UNLOADING_INT)	  return LoadState.UNLOADING;
			if (i == LOADED_INT)	  return LoadState.LOADED;
			if (i == LOAD_FAILED_INT) return LoadState.LOAD_FAILED;
			/* i out of range */	  return null;
		}
		
		private function get traitOfCurrentChild():ILoadable
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.LOADABLE) as ILoadable
				   : null;
		}
		
		// Ordered such that the lowest one takes precedence.  For example,
		// if we have two child traits with states LOAD_FAILED and CONSTRUCTED,
		// then the composite trait has state LOAD_FAILED.
		private static const LOAD_FAILED_INT:int 	= 0;
		private static const UNLOADING_INT:int 		= 1;
		private static const LOADING_INT:int 		= 2;
		private static const CONSTRUCTED_INT:int 	= 3;
		private static const LOADED_INT:int 		= 4;

		private var mode:CompositionMode;
		private var _loadState:LoadState = LoadState.CONSTRUCTED;
		private var _loadedContext:ILoadedContext;
	}
}