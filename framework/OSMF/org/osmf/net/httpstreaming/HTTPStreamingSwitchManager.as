package org.osmf.net.httpstreaming
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.events.StreamEvent;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.NetStreamMetricsBase;
	import org.osmf.net.NetStreamSwitchManager;
	import org.osmf.net.SwitchingRuleBase;
	
	[ExcludeClass]

	public class HTTPStreamingSwitchManager extends NetStreamSwitchManager
	{
		public function HTTPStreamingSwitchManager(connection:NetConnection, netStream:NetStream, resource:DynamicStreamingResource, metrics:NetStreamMetricsBase, switchingRules:Vector.<SwitchingRuleBase>)
		{
			super(connection, netStream, resource, metrics, switchingRules);
			
			super.autoSwitch = false;
			
			this.netStream = netStream;
			
			//netStream.addEventListener(StreamEvent.FRAGMENT_END, onFragmentEnd);
		}
		
		/**
		 * @private
		 * 
		 * For HTTP Streaming, autoSwitch should always be false.
		 */
		override public function set autoSwitch(value:Boolean):void
		{
			super.autoSwitch = false;
			_autoSwitch = value;
			
			if (_autoSwitch)
			{
				netStream.addEventListener(StreamEvent.FRAGMENT_END, onFragmentEnd);
			}
			else
			{
				netStream.removeEventListener(StreamEvent.FRAGMENT_END, onFragmentEnd);
			}
		}
		
//		override public function get autoSwitch():Boolean
//		{
//			return _autoSwitch;
//		}
		
		/**
		 * @private
		 * 
		 * When a fragment download has been complete, we need to call checkRules of the base
		 * class to update critical ratios such as DownloadRatio.
		 */
		private function onFragmentEnd(event:StreamEvent):void
		{
			doCheckRules();
		}
		
		private var _autoSwitch:Boolean = false;
		private var netStream:NetStream;
	}
}