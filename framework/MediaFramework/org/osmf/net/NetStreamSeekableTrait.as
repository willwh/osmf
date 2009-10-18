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
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.osmf.traits.SeekableTrait;
	
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
				previousTime = netStream.time;
				expectedTime = time;
				
				netStream.seek(time);
			}
		}
				
		private function onNetStatus(event:NetStatusEvent):void
		{
			var seekBugTimer:Timer;
			
			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
					// There's a bug (FP-1705) where NetStream.time doesn't get
					// updated until *after* the NetStream.Seek.Notify event is
					// received.  We don't want to processSeekCompletion until
					// NetStream's state is consistent, so we use a Timer to
					// delay the processing until the NetStream.time property
					// is up-to-date.
					seekBugTimer = new Timer(100);
					seekBugTimer.addEventListener(TimerEvent.TIMER, onSeekBugTimer);
					seekBugTimer.start();
					break;
				case NetStreamCodes.NETSTREAM_SEEK_INVALIDTIME:
				case NetStreamCodes.NETSTREAM_SEEK_FAILED:
					processSeekCompletion(previousTime);					
					break;				
			}
			
			function onSeekBugTimer(event:TimerEvent):void
			{
				if (netStream.time >= expectedTime)
				{
					seekBugTimer.stop();
					seekBugTimer.removeEventListener(TimerEvent.TIMER, onSeekBugTimer);
					
					processSeekCompletion(expectedTime);
				}
			}
		}
		
		private var netStream:NetStream;
		private var previousTime:Number;
		private var expectedTime:Number;
	}
}