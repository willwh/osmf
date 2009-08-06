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
package org.openvideoplayer.utils
{
	// Testing Label - weiz
	import org.openvideoplayer.loaders.LoaderBase;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	
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
		override public function load(loadable:ILoadable):void
		{
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
				updateLoadable(loadable, LoadState.LOADED, null);
			}
		}
		
		/**
		 * @inheritDoc
		 **/
		override public function unload(loadable:ILoadable):void
		{
			if (loadable.loadState == LoadState.LOADING ||
				loadable.loadState == LoadState.LOADED)
			{
				updateLoadable(loadable, LoadState.CONSTRUCTED, null);
			}
		}
	}
}