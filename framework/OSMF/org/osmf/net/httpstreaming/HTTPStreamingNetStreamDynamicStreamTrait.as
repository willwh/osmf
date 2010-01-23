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
package org.osmf.net.httpstreaming
{
	import flash.events.NetStatusEvent;
	
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.traits.DynamicStreamTrait;
	import org.osmf.utils.OSMFStrings;
	
	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class HTTPStreamingNetStreamDynamicStreamTrait extends DynamicStreamTrait
	{
		/**
		 * Constructor.
		 * 
		 * @param netStream The HTTPNetStream object the class will work with.
		 * @param dsResource The DynamicStreamingResource the class will use.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPStreamingNetStreamDynamicStreamTrait(netStream:HTTPNetStream, dsResource:DynamicStreamingResource)
		{
			super(false, 0, dsResource.streamItems.length);	
			
			this.netStream = netStream;
			this.dsResource = dsResource;
			
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
			
			autoSwitch = !netStream.manualSwitchMode;
			setNumDynamicStreams(dsResource.streamItems.length);
		}
				
		/**
		 * @private
		 */
		override public function getBitrateForIndex(index:int):Number
		{
			if (index > numDynamicStreams - 1 || index < 0)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
			}

			return dsResource.streamItems[index].bitrate;
		}	
		
		/**
		 * @private
		 */
		override protected function autoSwitchChangeStart(value:Boolean):void
		{
			netStream.manualSwitchMode = !value;
		}

		/**
		 * @private
		 */
		override protected function switchingChangeStart(newSwitching:Boolean, index:int, detail:SwitchingDetail=null):void
		{
			if (newSwitching && !inSetSwitching)
			{
				// Keep track of the target index, we don't want to begin
				// the switch now since our switching state won't be
				// updated until the switchingChangeEnd method is called.
				indexToSwitchTo = index;
			}
		}
		
		/**
		 * @private
		 */
		override protected function switchingChangeEnd(index:int, detail:SwitchingDetail=null):void
		{
			super.switchingChangeEnd(index, detail);
			
			if (switching && !inSetSwitching)
			{
				// TODO: Use play2() API.
				netStream.qualityLevel = indexToSwitchTo;
				
				setCurrentIndex(indexToSwitchTo);
			}
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION:
					// This switch is driven by the NetStream, we set a member
					// variable so that we don't assume it's being requested by
					// the client (and thus trigger a second switch).
					inSetSwitching = true;
					
					setSwitching(true, netStream.qualityLevel);
					
					inSetSwitching = false;
					
			}
		}
		
		private function onPlayStatus(event:Object):void
		{
			if (event.code == NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE)
			{
				// When a switch finishes, make sure our current index and switching
				// state reflect the changes to the NetStream.
				setCurrentIndex(netStream.qualityLevel);
				setSwitching(false, netStream.qualityLevel);
			}
		}

		private var netStream:HTTPNetStream;
		private var inSetSwitching:Boolean;
		private var dsResource:DynamicStreamingResource;
		private var indexToSwitchTo:int;	
	}
}