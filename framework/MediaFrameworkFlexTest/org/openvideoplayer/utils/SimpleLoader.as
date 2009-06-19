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