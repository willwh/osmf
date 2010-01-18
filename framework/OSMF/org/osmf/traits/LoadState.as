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
	 * The state of a LoadTrait.
	 */
	public final class LoadState
	{
		/**
		 * The LoadTrait has been constructed, but either has not yet started
		 * loading or has been unloaded.
		 **/
		public static const UNINITIALIZED:String	= "uninitialized";
		
		/**
		 * The LoadTrait has begun loading.
		 **/
		public static const LOADING:String			= "loading";
		
		/**
		 * The LoadTrait has begun unloading. Dispatched before any in memory
		 * media representations are released.
		 **/
		public static const UNLOADING:String		= "unloading";
		
		/**
		 * The LoadTrait is ready for playback.
		 **/
		public static const READY:String			= "ready";

		/**
		 * The LoadTrait has failed to load.
		 **/
		public static const LOAD_ERROR:String		= "loadError";
	}
}