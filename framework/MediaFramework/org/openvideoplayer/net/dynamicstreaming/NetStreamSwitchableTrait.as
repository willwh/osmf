/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/

package org.openvideoplayer.net.dynamicstreaming
{
	import flash.events.NetStatusEvent;
	
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.net.NetStreamCodes;
	import org.openvideoplayer.traits.SwitchableTrait;

	/**
	 * The NetStreamSwitchableTrait class implements an ISwitchable interface that uses a DynamicNetStream.
	 * @private
	 * @see DynamicNetStream
	 */   
	public class NetStreamSwitchableTrait extends SwitchableTrait
	{
		/**
		 * Constructor.
		 * 
		 * @param ns The DynamicNetStream object the class will work with.
		 * @param res The DynamicStreamingResource the class will use.
		 */
		public function NetStreamSwitchableTrait(ns:DynamicNetStream, res:DynamicStreamingResource)
		{
			super();	
			
			_autoSwitch = !ns.useManualSwitchMode;	
			_maxIndex = ns.maxIndex;
			_currentIndex = ns.renderingIndex;
				
			_ns = ns;
			_resource = res;
			_newState = _oldState = SwitchingChangeEvent.SWITCHSTATE_UNDEFINED;
						
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onNetStreamSwitchingChange);
		}
			
		/**
		 * @inheritDoc
		 */
		override public function get currentIndex():int
		{
			return _ns.renderingIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getBitrateForIndex(index:int):Number
		{
			return _resource.getItemAt(index).bitrate;
		}	
				
		/**
		 * @inheritDoc
		 */		
		override public function get switchUnderway():Boolean
		{
			return _ns.switchUnderway;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function processSwitchTo(value:int):void
		{
			_ns.switchTo(value);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function processAutoSwitchChange(value:Boolean):void
		{
			_ns.useManualSwitchMode = !value;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function processMaxIndexChange(value:int):void
		{
			_ns.maxIndex = value;
		}
				
		private function onNetStatus(event:NetStatusEvent):void
		{			
			if (!switchUnderway)
			{
				return;
			}
			
			switch (event.info.code) 
			{
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
					updateSwitchState(SwitchingChangeEvent.SWITCHSTATE_FAILED);
					break;
			}			
		}
		
		private function onNetStreamSwitchingChange(event:SwitchingChangeEvent):void
		{
			updateSwitchState(event.newState, event.detail);
		}
		
		/**
		 * A handy utility method for classes extending this class. Keeps track of
		 * the last state and dispatches a SwitchingChangeEvent containing the new state
		 * and the old state.
		 */
		private function updateSwitchState(newState:int, detail:SwitchingDetail=null):void
		{
			_oldState = _newState;
			_newState = newState;
			dispatchEvent(new SwitchingChangeEvent(_newState, _oldState, detail));
		}
		
		private var _newState:int;
		private var _oldState:int;				
		private var _ns:DynamicNetStream;
		private var _resource:DynamicStreamingResource;		
	}
}
