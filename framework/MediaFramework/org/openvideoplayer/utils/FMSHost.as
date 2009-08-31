package org.openvideoplayer.utils
{
	/**
	 * FMSHost is a utility class providing the FMSURL class the means to 
	 * return vectors of a typed object for it's properties regarding
	 * origin/edge information.
	 */
	public class FMSHost
	{
		/**
		 * Constructor.
		 * 
		 * @param host The host name to be stored in this class.
		 * @param port The port number as string to be stored in this class.
		 */
		public function FMSHost(host:String, port:String="1935")
		{
			_host = host;
			_port = port;
		}
		
		/**
		 * The host name.
		 */
		public function get host():String
		{
			return _host;
		}
		
		public function set host(value:String):void
		{
			_host = value;
		}
		
		/**
		 * The port number as a string.
		 */
		public function get port():String
		{
			return _port;
		}
		
		public function set port(value:String):void
		{
			_port = value;
		}
		
		
		private var _host:String;
		private var _port:String
	}
}
