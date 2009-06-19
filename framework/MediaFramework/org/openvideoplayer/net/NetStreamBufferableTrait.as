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
package org.openvideoplayer.net
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.openvideoplayer.traits.BufferableTrait;

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
				case NetStreamCodes.NETSTREAM_BUFFER_EMPTY:
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