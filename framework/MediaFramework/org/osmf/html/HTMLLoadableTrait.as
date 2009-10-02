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
package org.osmf.html
{
	import flash.errors.IllegalOperationError;
	import flash.external.ExternalInterface;
	
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IURLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.utils.MediaFrameworkStrings;

	internal class HTMLLoadableTrait extends MediaTraitBase implements ILoadable
	{
		public function HTMLLoadableTrait(owner:HTMLElement)
		{
			this.owner = owner;
			
			super();
		}
		
		// ILoadable
		//
		
		public function get resource():IMediaResource
		{
			return owner.resource;
		}
		
		public function get loadState():LoadState
		{
			return _loadState;
		}
		
		public function set loadState(value:LoadState):void
		{
			if (_loadState != value)
			{
				var event:LoadableStateChangeEvent
					= new LoadableStateChangeEvent(_loadState, value);
					
				_loadState = value;
				
				dispatchEvent(event);
			}
		}
		
		public function load():void
		{
			if (loadState == LoadState.LOADED)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_LOADED);
			}
			if (loadState == LoadState.LOADING)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_LOADING);
			}
			if (resource is IURLResource == false)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ILOADER_CANT_HANDLER_RESOURCE);
			}
			
			requireScriptPath;
			
			loadState = LoadState.LOADING;
			
			var urlResource:IURLResource = owner.resource as IURLResource
			var url:String
				= urlResource
					? urlResource.url
						? urlResource.url.rawUrl
						: ""
					: "";
			
			var result:*
				= ExternalInterface.call
					( owner.scriptPath + "__load__"
					, url
					);
					
			if (result == false)
			{
				// No load method got executed. Assume that we're loaded:
				loadState = LoadState.LOADED;
			}
		}
		
		public function unload():void
		{
			if (loadState == LoadState.UNLOADING)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADING);
			}
			if (loadState == LoadState.CONSTRUCTED)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ALREADY_UNLOADED);
			}
			
			requireScriptPath;
			
			var result:*
				= ExternalInterface.call
					( owner.scriptPath + "__unload__"
					, resource as IURLResource
					);
					
			if (result == false)
			{
				// No unload method got executed. Assume that we're unloaded:
				loadState = LoadState.CONSTRUCTED;
			}
		}
		
		public function get loadedContext():ILoadedContext
		{
			return _loadedContext;
		}
		
		public function set loadedContext(value:ILoadedContext):void
		{
			_loadedContext = value;
		}
		
		// Internal
		//
		
		private var owner:HTMLElement;
		
		private var _loadState:LoadState = LoadState.CONSTRUCTED;
		private var _loadedContext:ILoadedContext;
		
		private function get requireScriptPath():*
		{
			if (owner.scriptPath == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_SCRIPT_PATH);	
			}
			
			return undefined;
		}
		
	}
}