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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IMediaTrait;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * Dispatched when the trait's state has changed.
	 * @see LoadState
	 *
	 * @eventType org.openvideoplayer.events.LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
	 **/
	[Event(name="loadableStateChange", type="org.openvideoplayer.events.LoadableStateChangeEvent")]
	
	/**
	 * ILoadable defines the trait interface for media that must be loaded before they
	 * can be presented. It supports the load and unload operations.
	 * 
	 * <p>The load operation takes an IMediaResource as input and produces an
	 * ILoadedContext as output.</p>
	 * 
	 * <p>If <code>hasTrait(MediaTraitType.LOADABLE)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.LOADABLE)</code> method
	 * to get an object that is guaranteed to implement the ILoadable interface.</p>
	 * <p>Through its MediaElement, an ILoadable trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * @see LoadState
	 * @see org.openvideoplayer.composition
	 * @see org.openvideoplayer.media.MediaElement
	 */
	public interface ILoadable extends IMediaTrait, IEventDispatcher
	{
		/**
		 * Resource representing the piece of media to be loaded into
		 * this ILoadable.
		 **/
		function get resource():IMediaResource;
		
		/**
		 * The load state of this ILoadable.
		 **/
		function get loadState():LoadState;
		function set loadState(value:LoadState):void;

		/**
		 * Loads this ILoadable.
		 * Changes the load state of the ILoadable.
         * Dispatches the <code>loadableStateChange</code> event with every state change.
         *
         * <p>Typical states are <code>LOADING</code> while the ILoadable is loading,
         * <code>LOADED</code> after it has successfully completed loading, 
         * and <code>LOAD_FAILED</code> if it fails to complete loading.</p>
		 * 
         * <p>If the LoadState is <code>LOADING</code> or <code>LOADED</code>
         * when the method is called, throws an error.</p>
         *  
         * @see LoadState
		 * @throws IllegalOperationError If this ILoadable is unable to load
		 * itself or if the LoadState is <code>LOADING</code> or
         * <code>LOADED</code>.
		 **/
		function load():void;

		/**
         * Unloads this ILoadable. Changes the load state of the ILoadable.
         * Dispatches the <code>loadableStateChange</code> event with every state change.
		 * 
         * <p>Typical states are <code>UNLOADING</code> while the ILoadable is unloading,
         * <code>CONSTRUCTED</code> after it has successfully completed unloading, 
         * and <code>LOAD_FAILED</code> if it fails to complete unloading.</p>
		 * 
 		 * <p>If the ILoadable's LoadState is not <code>LOADED</code> when the
 		 * method is called, throws an error.</p>
		 * 
		 * @param loadable The ILoadable to unload.
         * @see LoadState
		 * 
		 * @throws IllegalOperationError If this ILoadable is unable to unload
		 * itself, or if the LoadState is not <code>LOADED</code>.
		 **/
		function unload():void;
		
		/**
		 * The context resulting from this ILoadable's successful <code>load()</code>
		 * operation.
		 * 
         * <p>The context is <code>null</code> before this ILoadable's state is <code>LOADED</code> 
		 * and after the ILoadable has been unloaded.</p>
		 **/
		function get loadedContext():ILoadedContext;
		function set loadedContext(value:ILoadedContext):void;
	}
}
