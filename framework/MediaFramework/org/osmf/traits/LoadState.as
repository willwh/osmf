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
	/**
	 * The state of an ILoadable.
	 */
	public class LoadState
	{
		/**
		 * The loadable has been constructed, but either has not yet started
		 * loading or has been unloaded.
		 **/
		public static const CONSTRUCTED:LoadState	= new LoadState("constructed");
		
		/**
		 * The loadable has begun loading.
		 **/
		public static const LOADING:LoadState		= new LoadState("loading");
		
		/**
		 * The loadable has begun unloading. Dispatched before any in memory
		 * media representations are released.
		 **/
		public static const UNLOADING:LoadState		= new LoadState("unloading");
		
		/**
		 * The loadable has completed loading.
		 **/
		public static const LOADED:LoadState		= new LoadState("loaded");

		/**
		 * The loadable has failed to complete loading.
		 **/
		public static const LOAD_FAILED:LoadState	= new LoadState("loadFailed");
		
		/**
		 * Lists all known load states
		 */
		public static const ALL_STATES:Vector.<LoadState> = new Vector.<LoadState>(5);
		ALL_STATES[0] = CONSTRUCTED;
		ALL_STATES[1] = LOADING;
		ALL_STATES[2] = UNLOADING;
		ALL_STATES[3] = LOADED;
		ALL_STATES[4] = LOAD_FAILED;
		
		/**
		 * @private
		 **/
		public function LoadState(name:String)
		{
			this.name = name;
		}
		
		/**
		 * @private
		 **/
		public function toString():String
		{
			return name;
		}
		
		private var name:String;
	}
}