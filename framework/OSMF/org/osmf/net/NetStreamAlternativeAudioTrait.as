/*****************************************************
*  
*  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2011 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.net
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.traits.AlternativeAudioTrait;
	import org.osmf.utils.OSMFStrings;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * The NetStreamalternativeAudioTrait class extends AlternativeAudioTrait for NetStream-based
	 * alternative audio support.
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */   
	public class NetStreamAlternativeAudioTrait extends AlternativeAudioTrait
	{
		/**
		 * Default constructor.
		 * 
		 * @param netStream The NetStream object that this class will work with.
		 * @param streamingResource The streaming resource object that this class will work with.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public function NetStreamAlternativeAudioTrait(netStream:NetStream, streamingResource:StreamingURLResource)
		{
			super(streamingResource.alternativeAudioStreamItems.length);	
			
			_streamingResource = streamingResource;
			_netStream = netStream;
			if (_netStream != null && _netStream.client != null)
			{
				NetClient(netStream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
			}
		}
		
		/**
		 * Disposes of any resources used by this trait. Called by the framework
		 * whenever a trait is removed from a MediaElement.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		override public function dispose():void
		{
			_netStream = null;
			_streamingResource = null;
		}
		
		/**
		 * Returns the associated streaming item for the specified index. Returns 
		 * <code>null</code> if the index is <code>-1</code>.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		override public function getItemForIndex(index:int):StreamingItem
		{
			if (index < -1 || index >= numAlternativeAudioStreams)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.ALTERNATIVEAUDIO_INVALID_INDEX));
			}
			
			if (index < - 1)
			{
				return null;
			}
			
			return _streamingResource.alternativeAudioStreamItems[index];
		}	
				
		/**
		 * @private
		 * 
		 * Called immediately before the <code>changingSource</code> property is changed.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		override protected function beginSwitching(newSwitching:Boolean, index:int):void
		{
			if (newSwitching)
			{
				// Keep track of the target index, we don't want to begin
				// the switch now since our switching state won't be
				// updated until the switchingChangeEnd method is called.
				_indexToChangeTo = index;
			}
		}
		
		/**
		 * @private
		 * 
		 * Called just after the <code>switching</code> property has changed.
		 * Dispatches the change event.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		override protected function endSwitching(index:int):void
		{
			super.endSwitching(index)
			
			if (switching)
			{
				executeSwitching(_indexToChangeTo);
			}
		}
		
		/**
		 * @private
		 * 
		 * These method will actually issue the switch command. The switch is
		 * done through <code>NetStream.play2</code> method and using the <code>
		 * NetStreamPlayTransitions.SWAP</code> command.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		protected function executeSwitching(indexToChangeTo:int):void
		{
			if (_lastTransitionIndex != indexToChangeTo)
			{	
				_activeTransitionIndex = indexToChangeTo;
				_activeTransitionStreamName = _streamingResource.alternativeAudioStreamItems[indexToChangeTo].streamName;
				_transitionInProgress = true;
				
				var playArgs:Object = NetStreamUtils.getPlayArgsForResource(_streamingResource);
				
				var nso:NetStreamPlayOptions = new NetStreamPlayOptions();
				nso.start = playArgs.start;
				nso.len = playArgs.len;
				nso.streamName = _activeTransitionStreamName;
				nso.oldStreamName = prepareStreamName(_lastTransitionStreamName);
				nso.transition = NetStreamPlayTransitions.SWAP;
				_netStream.play2(nso);
			}
		}
		
		/**
		 * @private
		 * 
		 * We listen for onPlayStatus events in order to detect when the queued
		 * switch is completed. We assume that the alternate audio stream names
		 * are different from the ones used in MBR.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		private function onPlayStatus(info:Object):void
		{
			switch (info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE:
					if (_transitionInProgress && _activeTransitionIndex > -1)
					{
						_lastTransitionIndex =_activeTransitionIndex;
						_lastTransitionStreamName = _activeTransitionStreamName;
						
						_transitionInProgress = false;
						_lastTransitionIndex = -1;
						_lastTransitionStreamName = null;
						
						setSwitching(false, _lastTransitionIndex);
					}
					break;
			}
		}
		
		/**
		 * @private
		 * 
		 * Remove additional parameters from stream name.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */ 
		private function prepareStreamName(value:String):String
		{
			if (value != null && value.indexOf("?") >= 0)
			{
				return value.substr(0, value.indexOf("?"));
			}
			return value;
		}
		
		/// Internal
		private var _netStream:NetStream;
		private var _streamingResource:StreamingURLResource;
		private var _indexToChangeTo:int;
		
		private var _transitionInProgress:Boolean = false;
		private var _activeTransitionIndex:int = -1;
		private var _activeTransitionStreamName:String = null;
		private var _lastTransitionIndex:int = -1;
		private var _lastTransitionStreamName:String = null;
	}
}
