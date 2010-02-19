package org.osmf.net.dvr
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	
	import org.osmf.media.URLResource;

	public class DVRCastNetStream extends NetStream
	{
		public function DVRCastNetStream(connection:NetConnection, resource:URLResource)
		{
			super(connection);
		}
		
		public function set disabled(value:Boolean):void
		{
			if (_disabled != value)
			{
				_disabled = value;
				if (_disabled == true)
				{
					// Close the stream:
					close();
				}	
			}
		}
		
		// Overrides
		//
		
		override public function play(...arguments):void
		{
			if (_disabled != true)
			{
				super.play.apply(this, arguments);
			}
		}
		
		override public function play2(param:NetStreamPlayOptions):void
		{
			if (_disabled != true)
			{
				super.play2(param);
			}
		}
		
		// Internals
		//
		
		private var _disabled:Boolean = false;
	}
}