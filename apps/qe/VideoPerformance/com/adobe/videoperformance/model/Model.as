package com.adobe.videoperformance.model
{
	/**
	 * Defines the central application model.
	 */	
	public class Model
	{
		// Public Interface
		//
		
public static const VIDEO_SERVER:String = "http://azuremyst.macromedia.com/flashservices/gateway";
public static const VIDEO_SERVICE:String = "data.VideoPerformance.cfc.VideoPerf.addVideoRun";


public static const PARAMETER_MAP:Array
	= 	[ [ "createRun", "_createRun", Boolean, false ]
		, [ "videoID", "_videoID", int, 1 ]
		, [ "videoUrl", "_videoURL", String, "http://azuremyst.macromedia.com/data/VideoPerformance/movies/On2/Pirates3-1.flv" ]
		, [ "encFps", "_encFps", int, 0 ]
		, [ "duration", "_duration", int, 0 ]
		, [ "interval", "_interval", int, 0 ]
		, [ "fullScreen", "_fullScreen", Boolean, false ]
		, [ "hostName", "_hostName", String, "" ]
		, [ "browser", "_browser", int, 0 ]
		, [ "os", "_os", int, 0 ]
		];
		
		/**
		 * Initializes the configuration part of the model.
		 * 
		 * @param parameters An object holding key-value pairs that
		 * specify the desired configuration values. The PARAMETER_MAPPING
		 * constants holds a list of all supported keys.
		 * 
		 * @see Model#PARAMETER_MAP
		 */		
		public function initialize(parameters:Object):void
		{
			for each (var record:Array in PARAMETER_MAP)
			{
				var paramName:String = record[0];
				var localName:String = record[1];
				var paramType:Class = record[2];
				var paramDefault:Object = record[3];
				
				var value:Object = paramDefault;
				
				if 	(	parameters != null
					&&	parameters.hasOwnProperty(paramName) == true
					&&	parameters[paramName] != null
					)
				{
					
					switch (paramType)
					{
						case Boolean:
							value = parameters[paramName].toString().toLowerCase() == "true"
							break;
							
						case String:
							value = parameters[paramName].toString();
							break;
							
						case int:
						case uint:
							value = parseInt(parameters[paramName].toString());
							break;
					}
				}
				
				trace("Setting",paramName,"to '",value,"'");
				this[localName] = value;
			} 
			
			_fpsArray = [];
		}
		
		public function get createRun():Boolean
		{
			return _createRun;
		}
		
		public function get videoID():int
		{
			return _videoID;
		}
		
		public function get videoURL():String
		{
			return _videoURL;
		}
		
		public function get encFps():int
		{
			return _encFps;
		}
		
		public function get duration():int
		{
			return _duration;
		}
		
		public function get interval():int
		{
			return _interval;
		}
		
		public function get fullScreen():Boolean
		{
			return _fullScreen;
		}
		
		public function get hostName():String
		{
			return _hostName;
		}
		
		public function get browser():int
		{
			return	_browser;
		}
		
		public function get os():int
		{
			return _os;
		}
		
		public function get fpsArray():Array
		{
			return _fpsArray;
		}
		
		
		/**
		 * Stores a performance poll record with the fpsArray.
		 * 
		 * @param poll The performance poll to store.
		 */		
		public function addPoll(poll:PerformancePoll):void
		{
			_fpsArray.push(poll);
		}
		
		// Internals
		//

		private var _createRun:Boolean;
		private var _videoID:int;
		private var _videoURL:String; 
		private var _encFps:int;
		private var _duration:int;
		private var _interval:int;
		private var _fullScreen:Boolean;
		private var _hostName:String;
		private var _browser:int;
		private var _os:int;
		private var _fpsArray:Array;
		
		
	}
}