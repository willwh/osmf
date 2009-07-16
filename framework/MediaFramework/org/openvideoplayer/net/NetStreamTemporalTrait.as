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
	
	import org.openvideoplayer.traits.TemporalTrait;
	
	/**
	 * The NetStreamTemporalTrait class implements an ITemporal interface that uses a NetStream.
	 * This trait is used by AudioElements and VideoElements.
	 * @private
	 * @see flash.net.NetStream
	 */ 	
	public class NetStreamTemporalTrait extends TemporalTrait
	{
		/**
		 * Constructor.
		 * @param netStream NetStream created for the media element that uses this trait.
		 * @see NetLoader
		 */ 		
		public function NetStreamTemporalTrait(netStream:NetStream)
		{
			this.netStream = netStream;
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_ID3, onID3);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get position():Number
		{
			return netStream.time;
		}
		
		private function onMetaData(value:Object):void
		{
			duration = value.duration;
		}
		
		private function onID3(value:Object):void
		{
			
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{			
			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_STOP:				
					processDurationReached();
					break;
			}
		}
		
		private var netStream:NetStream;
	}
}