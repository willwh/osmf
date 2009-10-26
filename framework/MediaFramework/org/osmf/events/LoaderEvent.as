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
package org.osmf.events
{
	import flash.events.Event;
	
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	
	/**
	 * An ILoader dispatches a LoaderEvent when an ILoadable that it's loading
	 * or unloading has undergone a notable load-oriented change.
	 */
	public class LoaderEvent extends Event
	{
		/**
		 * The LoaderEvent.STATE_CHANGE constant defines the value of the type
		 * property of the event object for a loaderStateChange event.
		 * 
		 * @eventType loaderStateChange
		 **/
		public static const LOADABLE_STATE_CHANGE:String = "loadableStateChange";
		
		/**
		 * Constructor.
		 * 
		 * @param loader The loader for this event.
		 * @param loadable The loadable for this event.
		 * @param oldState The previous state of the loadable.
		 * @param newState The new state of the loadable.
		 * @param loadedContext The loaded context (if any) of the loadable.
 		 * @param bubbles Specifies whether the event can bubble up the display
 		 * list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the
 		 * event can be prevented.
		 **/
		public function LoaderEvent
							( loader:ILoader,
							  loadable:ILoadable,
							  oldState:LoadState,
							  newState:LoadState,
							  loadedContext:ILoadedContext,
							  bubbles:Boolean=false,
							  cancelable:Boolean=false
							)
		{			
			super(LOADABLE_STATE_CHANGE, bubbles, cancelable);
			
			_loader = loader;
			_loadable = loadable;
			_oldState = oldState;
			_newState = newState;
			_loadedContext = loadedContext;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 **/
		override public function clone():Event
		{
			return new LoaderEvent(loader, loadable, oldState, newState, loadedContext);
		}
		
		/**
		 * The loader for this event.
		 **/
		public function get loader():ILoader
		{
			return _loader;
		}

		/**
		 * The loadable for this event.
		 **/
		public function get loadable():ILoadable
		{
			return _loadable;
		}

		/**
		 * The previous state of the loadable.
		 **/
		public function get oldState():LoadState
		{
			return _oldState;
		}

		/**
		 * The new state of the loadable.
		 **/
		public function get newState():LoadState
		{
			return _newState;
		}
		
		/**
		 * The loaded context (if any) of the loadable.
		 **/
		public function get loadedContext():ILoadedContext
		{
			return _loadedContext;
		}
		
		// Internals
		//
		
		private var _loader:ILoader;
		private var _loadable:ILoadable;
		private var _oldState:LoadState;
		private var _newState:LoadState;
		private var _loadedContext:ILoadedContext;
	}
}