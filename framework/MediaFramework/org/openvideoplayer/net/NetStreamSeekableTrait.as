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
package org.openvideoplayer.net
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.openvideoplayer.traits.SeekableTrait;
	
	/**
	 * The NetStreamSeekableTrait class implements an ISeekable interface that uses a NetStream.
	 * This trait is used by AudioElements and VideoElements.
	 * @private
	 * @see flash.net.NetStream
	 */ 		
	public class NetStreamSeekableTrait extends SeekableTrait
	{
		/**
		 * Constructor.
		 * @param netStream NetStream created for the ILoadable that belongs to the media element
		 * that uses this trait.
		 * @see NetLoader
		 */ 		
		public function NetStreamSeekableTrait(netStream:NetStream)
		{
			this.netStream = netStream;
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);		
		}

		/**
		 * @private
		 * Communicates a <code>seeking</code> change to the media through the NetStream. 
		 * @param newSeeking New <code>seeking</code> value.
		 * @param time Time to seek to, in seconds.
		 */						
		override protected function processSeekingChange(newSeeking:Boolean, time:Number):void
		{		
			if (newSeeking)
			{		
				requestedSeekTime = time;	
				netStream.seek(time);	
			}	
		}
				
		private function onNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				// We pass in the requested seek time, rather than
				// the NetStream's current time, because the NetStream
				// dispatches the NetStatusEvent *before* its own time
				// property is updated.  (An alternative approach would
				// be to delay the processSeekCompletion until after
				// NetStream.time gets updated.) 
				case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
				case NetStreamCodes.NETSTREAM_SEEK_INVALIDTIME:
				case NetStreamCodes.NETSTREAM_SEEK_FAILED:
					processSeekCompletion(requestedSeekTime);					
					break;				
			}
		}
		
		private var requestedSeekTime:Number;
		private var netStream:NetStream;		
	}
}