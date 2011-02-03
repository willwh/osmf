package org.osmf.utils
{
	import flash.system.Capabilities;

	/**
	 * Utility class which exposes all user-facing OSMF settings.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.6
	 */ 
	public final class OSMFSettings
	{
		/**
		 * Flags controlling the usage of StageVideo in OSMF. Setting
		 * this value to <code>true</code> will enable StageVideo, while 
		 * setting it to <code>false</code> will disable StageVideo and 
		 * activate the fallback to normal Video API.
		 * 
		 * Modifying this value affects only the new media elements being created
		 * not the existing ones.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public static var enableStageVideo:Boolean = true;
		
		/**
		 * Flag exposing the availability of StageVideo. It returns true if StageVideo 
		 * feature is supported in the current version of Flash Runtime and false otherwise.
		 * 
		 * The availability is decided based on the Flash Player version in the following mode:
		 * - if the version is equal or greater than 10.2 then StageVideo is supported.
		 * - if the version is lower than 10.2 then StageVideo is not supported.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public static function get supportsStageVideo():Boolean
		{
			var flashPlayerVersion:String = Capabilities.version;
			
			var osArray:Array = flashPlayerVersion.split(' ');
			var osType:String = osArray[0]; 
			var versionArray:Array = osArray[1].split(',');
			var majorVersion:Number = parseInt(versionArray[0]);
			var majorRevision:Number = parseInt(versionArray[1]);
			var minorVersion:Number = parseInt(versionArray[2]);
			var minorRevision:Number = parseInt(versionArray[3]);
			
			return (majorVersion >= 10 && majorRevision >= 2);
		}

		/**
		 * Returns true if StageVideo feature can be actually used. It returns true only if
		 * the StageVideo APIs are supported by the runtime and if the developer
		 * wants to use it. 
		 * 
		 * It will return false if the platform doesn't support StageVideo API or the developer disabled in 
		 * an explicit way the use of StageVideo.
		 * 
		 */
		public static function get useStageVideo():Boolean
		{
			return enableStageVideo && supportsStageVideo;
		}
	}
}