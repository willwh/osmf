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
	public class OSMFSettings
	{
		/**
		 * Controls OSMF’s use of StageVideo in your application. 
		 * 
		 * Setting this value to true causes OSMF to try to use StageVideo on 
		 * systems where it is available. Setting the value to false disables 
		 * the use of StageVideo and instructs OSMF to fallback to the normal 
		 * Video API. 
		 * 
		 * Changes to this value affect any new media elements that are created, 
		 * but changes have no effect on existing media elements. The default 
		 * setting for this flag is true.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public static var enableStageVideo:Boolean = true;
		
		/**
		 * Obtains whether the version of Flash Player installed on the user’s 
		 * system supports StageVideo. 
		 * 
		 * If the installed version of Flash Player is equal to or greater than 10.2, 
		 * StageVideo is supported, and the function returns true. If the installed 
		 * version of Flash Player is lower than 10.2, StageVideo is not supported, 
		 * and the function returns false.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public static function get systemSupportsStageVideo():Boolean
		{
			return runtimeSupportsStageVideo(Capabilities.version);
		}

		/**
		 * Returns true if StageVideo feature can be actually used. It returns true only if
		 * the StageVideo APIs are supported by the runtime and if the developer
		 * wants to use it. 
		 * 
		 * It will return false if the platform doesn't support StageVideo API or the developer disabled in 
		 * an explicit way the use of StageVideo.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public static function get canUseStageVideo():Boolean
		{
			return enableStageVideo && systemSupportsStageVideo;
		}
		
		/**
		 * @private
		 */
		protected static function runtimeSupportsStageVideo(runtimeVersion:String):Boolean
		{
			var osArray:Array = runtimeVersion.split(' ');
			var osType:String = osArray[0]; 
			var versionArray:Array = osArray[1].split(',');
			var majorVersion:Number = parseInt(versionArray[0]);
			var majorRevision:Number = parseInt(versionArray[1]);
			var minorVersion:Number = parseInt(versionArray[2]);
			var minorRevision:Number = parseInt(versionArray[3]);
			
			return (majorVersion >= 10 && majorRevision >= 2);
		}
	}
}