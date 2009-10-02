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
package org.osmf.utils
{
	// Testing Label - weiz
	import org.osmf.loaders.LoaderBase;
	import org.osmf.media.IMediaResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	
	/**
	 * A SimpleLoader performs loads and unloads synchronously.
	 **/
	public class SimpleLoader extends LoaderBase
	{
		/**
		 * Indicates that the load operation should be forced to
		 * fail.
		 **/
		public var forceFail:Boolean = false;
		
		/**
		 * @inheritDoc
		 **/
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			return true; 
		}
		
		/**
		 * @inheritDoc
		 **/
		override public function load(loadable:ILoadable):void
		{
			super.load(loadable);
			if (forceFail &&
				loadable.loadState != LoadState.LOAD_FAILED &&
				loadable.loadState != LoadState.LOADED)
			{
				updateLoadable(loadable, LoadState.LOAD_FAILED, null);
			}
			else if (!forceFail &&
					 loadable.loadState != LoadState.LOADING && 
					 loadable.loadState != LoadState.LOADED)
			{
				updateLoadable(loadable, LoadState.LOADED, new SimpleLoadedContext());
			}
		}
		
		/**
		 * @inheritDoc
		 **/
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);
			if (loadable.loadState == LoadState.LOADING ||
				loadable.loadState == LoadState.LOADED)
			{
				updateLoadable(loadable, LoadState.CONSTRUCTED);
			}
		}
	}
}