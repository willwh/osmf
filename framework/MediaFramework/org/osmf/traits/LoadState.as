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
	public final class LoadState
	{
		/**
		 * The loadable has been constructed, but either has not yet started
		 * loading or has been unloaded.
		 **/
		public static const UNINITIALIZED:String	= "uninitialized";
		
		/**
		 * The loadable has begun loading.
		 **/
		public static const LOADING:String			= "loading";
		
		/**
		 * The loadable has begun unloading. Dispatched before any in memory
		 * media representations are released.
		 **/
		public static const UNLOADING:String		= "unloading";
		
		/**
		 * The loadable is ready for playback.
		 **/
		public static const READY:String			= "ready";

		/**
		 * The loadable has failed to load.
		 **/
		public static const LOAD_ERROR:String		= "loadError";
		
		/**
		 * All known load states.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const ALL_STATES:Vector.<String> = new Vector.<String>(5);
			ALL_STATES[0] = UNINITIALIZED;
			ALL_STATES[1] = LOADING;
			ALL_STATES[2] = UNLOADING;
			ALL_STATES[3] = READY;
			ALL_STATES[4] = LOAD_ERROR;
	}
}