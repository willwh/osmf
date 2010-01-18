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
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.TimeTrait;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * The NetStreamTimeTrait class extends TimeTrait to expose NetStream's time properties.
	 * 
	 * @see flash.net.NetStream
	 */ 	
	public class NetStreamTimeTrait extends TimeTrait
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 		
		public function NetStreamTimeTrait(netStream:NetStream, resource:MediaResourceBase)
		{
			super();
			
			this.netStream = netStream;			
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			this.resource = resource;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function get currentTime():Number
		{
			return netStream.time;
		}
		
		private function onMetaData(value:Object):void
		{
			// Determine the start time and duration for the
			// resource.
			var playArgs:Object = NetStreamUtils.getPlayArgsForResource(resource);
			
			// Ensure our start time is non-negative, we only use it for
			// calculating the offset.
			var subclipStartTime:Number = Math.max(0, playArgs.start);
			
			// Ensure our duration is non-negative.
			var subclipDuration:Number = playArgs.len;
			if (subclipDuration == NetStreamUtils.PLAY_LEN_ARG_ALL)
			{
				subclipDuration = Number.MAX_VALUE;
			}

			// If startTime is unspecified, our duration is everything
			// up to the end of the subclip (or the entire duration, if
			// no subclip end is specified).
			setDuration(Math.min(value.duration - subclipStartTime, subclipDuration));
		}
		
		private function onPlayStatus(event:Object):void
		{			
			switch(event.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_COMPLETE:
					// For streaming, NetStream.Play.Complete means playback
					// has completed.  But this isn't fired for progressive.
					signalComplete();
					break;
			}
		}
						
		private function onNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					// For progressive,	NetStream.Play.Stop means playback
					// has completed.  But this isn't fired for streaming.
					if (NetStreamUtils.isStreamingResource(resource) == false)
					{
						signalComplete();
					}
					break;
			}
		}
		
		private var netStream:NetStream;
		private var resource:MediaResourceBase;
	}
}