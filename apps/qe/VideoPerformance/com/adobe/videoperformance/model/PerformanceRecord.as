package com.adobe.videoperformance.model
{
	import flash.system.Capabilities;
	
	import org.openvideoplayer.version.Version;
	
	public class PerformanceRecord
	{
		public function PerformanceRecord(model:Model=null)
		{
			if (model != null)
			{
				count = model.fpsArray.length;
				hostName = model.hostName;
				browser = model.browser;
				os = model.os;
				createRun = model.createRun;
				currFPSData = model.fpsArray.concat();
			}
			
			platform = Capabilities.os;
			playerVersion = Capabilities.version;
			playerType = Capabilities.playerType;
			isDebugger = Capabilities.isDebugger ? 1 : 0;
			strobeVersion = Version.version();
			build = strobeVersion.slice(strobeVersion.lastIndexOf(".") + 1, strobeVersion.length);
			swfName = SWFNAME;
		}
		
		public var count:int = 0;
		public var build:String;
		public var hostName:String;
		public var platform:String;
		public var playerVersion:String;
		public var playerType:String;
		public var isDebugger:int;
		public var browser:int;
		public var os:int;
		public var createRun:Boolean;
		public var currFPSData:Array;
		public var strobeVersion:String;
		public var swfName:String;
		private static var SWFNAME:String = "StrobeBasicPeformanceSWF";
	}
}