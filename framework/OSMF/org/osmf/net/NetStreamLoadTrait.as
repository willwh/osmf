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
package org.osmf.net
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;

	
	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class NetStreamLoadTrait extends LoadTrait
	{
		public function NetStreamLoadTrait(loader:ILoader, resource:MediaResourceBase)
		{
			super(loader, resource);
			
			isStreamingResource = NetStreamUtils.isStreamingResource(resource);
		}
		
		override protected function loadStateChangeStart(newState:String, newContext:ILoadedContext):void
		{
			if (newState == LoadState.READY)
			{
				var context:NetLoadedContext = newContext as NetLoadedContext;
				netStream = context.stream;
				
				if (	!isStreamingResource
					 && (  netStream.bytesTotal <= 0
					 	|| netStream.bytesTotal == uint.MAX_VALUE
					 	)
				   )
				{
					netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				}
			}
			else if (newState == LoadState.UNINITIALIZED)
			{
				netStream = null;
			}
		}
		
		/**
		 * @private
		 */
		override public function get bytesLoaded():Number
		{
			return isStreamingResource ? NaN : (netStream != null ? netStream.bytesLoaded : NaN);
		}
		
		/**
		 * @private
		 */
		override public function get bytesTotal():Number
		{
			return isStreamingResource ? NaN : (netStream != null ? netStream.bytesTotal : NaN);
		}
		
		// Internals
		//
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			if (netStream.bytesTotal > 0)
			{
				dispatchEvent
					( new LoadEvent
						( LoadEvent.BYTES_TOTAL_CHANGE
						, false
						, false
						, null
						, netStream.bytesTotal
						)
					);
					
				netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			}
		}

		private var isStreamingResource:Boolean;
		private var netStream:NetStream;
	}
}