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
package org.openvideoplayer.events
{
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.ILoadedContext;
	import org.openvideoplayer.traits.LoadState;
	
	import flash.events.Event;
	
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