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
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaTrait;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * Dispatched when the trait's state has changed.
	 * @see LoadState
	 *
	 * @eventType org.osmf.events.LoadEvent.LOAD_STATE_CHANGE
	 **/
	[Event(name="loadStateChange", type="org.osmf.events.LoadEvent")]
	
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
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 */
	public interface ILoadable extends IMediaTrait, IEventDispatcher
	{
		/**
		 * Resource representing the piece of media to be loaded into
		 * this ILoadable.
		 **/
		function get resource():IMediaResource;
		
		/**
		 * The load state of this ILoadable. See LoadState for possible values.
		 **/
		function get loadState():String;
		function set loadState(value:String):void;

		/**
		 * Loads this ILoadable.
		 * Changes the load state of the ILoadable.
         * Dispatches the <code>loadStateChange</code> event with every state change.
         *
         * <p>Typical states are <code>LOADING</code> while the ILoadable is loading,
         * <code>READY</code> after it has successfully completed loading, 
         * and <code>LOAD_ERROR</code> if it fails to complete loading.</p>
		 * 
         * <p>If the LoadState is <code>LOADING</code> or <code>READY</code>
         * when the method is called, throws an error.</p>
         *  
         * @see LoadState
		 * @throws IllegalOperationError If this ILoadable is unable to load
		 * itself or if the LoadState is <code>LOADING</code> or
         * <code>READY</code>.
		 **/
		function load():void;

		/**
         * Unloads this ILoadable. Changes the load state of the ILoadable.
         * Dispatches the <code>loadStateChange</code> event with every state change.
		 * 
         * <p>Typical states are <code>UNLOADING</code> while the ILoadable is unloading,
         * <code>UNINITIALIZED</code> after it has successfully completed unloading, 
         * and <code>LOAD_ERROR</code> if it fails to complete unloading.</p>
		 * 
 		 * <p>If the ILoadable's LoadState is not <code>READY</code> when the
 		 * method is called, throws an error.</p>
		 * 
		 * @param loadable The ILoadable to unload.
         * @see LoadState
		 * 
		 * @throws IllegalOperationError If this ILoadable is unable to unload
		 * itself, or if the LoadState is not <code>READY</code>.
		 **/
		function unload():void;
		
		/**
		 * The context resulting from this ILoadable's successful <code>load()</code>
		 * operation.
		 * 
         * <p>The context is <code>null</code> before this ILoadable's state is <code>LOADING</code>
         * or <code>READY</code>, depending on the loader implementation at hand. The context is
         * <code>null</code> after the ILoadable has been unloaded.</p>
		 **/
		function get loadedContext():ILoadedContext;
		function set loadedContext(value:ILoadedContext):void;
	}
}
