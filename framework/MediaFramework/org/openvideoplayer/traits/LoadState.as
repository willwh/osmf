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