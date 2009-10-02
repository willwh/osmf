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
	
	import org.osmf.traits.BufferableTrait;

	/**
	 * The NetStreamBufferableTrait class implements an IBufferable interface that uses a NetStream.
	 * This trait is used by AudioElements and VideoElements.
	 * @private
	 * @see flash.net.NetStream
	 */  
	public class NetStreamBufferableTrait extends BufferableTrait
	{		
		/**
		 * Constructor.
		 * @param netStream NetStream created for the ILoadable that belongs to the media element
		 * that uses this trait.
		 * @see NetLoader
		 */
		public function NetStreamBufferableTrait(netStream:NetStream)
		{
			super();
			
			this.netStream = netStream;		
			bufferTime = netStream.bufferTime; 						
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);				
		}
		
		/**
		 *  @inheritDoc
		 */ 
		override public function get bufferLength():Number
		{
			return netStream.bufferLength;
		}
		
		/**
		 * Called before the <code>bufferLength</code> value is changed. 
		 * @param newSize Proposed new <code>bufferLength</code> value.
		 * @return Returns <code>true</code> by default. 
		 * Subclasses that override this method can return <code>false</code> to
		 * abort processing.
		 */		
		override protected function canProcessBufferLengthChange(newSize:Number):Boolean
		{
			return false;
		}
		
		/**
		 * @private
		 * Communicates a <code>bufferTime</code> change to the media through the NetStream. 
		 *
		 * @param newTime New <code>bufferTime</code> value.
		 */											
		override protected function processBufferTimeChange(newTime:Number):void
		{
			netStream.bufferTime = newTime;
		}
		
		/**
		 * @private 
		 */				
		override protected function canProcessBufferTimeChange(newTime:Number):Boolean
		{
			return (newTime >= 0);
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{				
			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_START:   // Once playing starts, we will be buffering (streaming and progressive, until we receive a Buffer.Full or Buffer.flush
				case NetStreamCodes.NETSTREAM_BUFFER_EMPTY:	 //Grab buffertime once again, since VOD will force it up to .1 from 0				
					bufferTime = netStream.bufferTime;				
					buffering = true;
					break;
				case NetStreamCodes.NETSTREAM_BUFFER_FLUSH:
				case NetStreamCodes.NETSTREAM_BUFFER_FULL:
					buffering = false;
					break;
			}
		}
		
		private var netStream:NetStream;			
	}
}