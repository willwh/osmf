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
		public static function get supportsStageVideo():Boolean
		{
			return runtimeSupportsStageVideo(Capabilities.version);
		}

		/**
		 * @private
		 */
		internal static function runtimeSupportsStageVideo(runtimeVersion:String):Boolean
		{
			if (runtimeVersion == null)
				return false;
			
			var osArray:Array = runtimeVersion.split(' ');
			if (osArray.length < 2)
				return false;
			
			var osType:String = osArray[0]; 
			var versionArray:Array = osArray[1].split(',');
			if (versionArray.length < 2)
					return false;
			var majorVersion:Number = parseInt(versionArray[0]);
			var majorRevision:Number = parseInt(versionArray[1]);
			
			return (
						majorVersion > 10 ||
						(majorVersion == 10 && majorRevision >= 2)
					);
		}
	}
}