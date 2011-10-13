/***********************************************************
 * Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
 *
 * *********************************************************
 *  The contents of this file are subject to the Berkeley Software Distribution (BSD) Licence
 *  (the "License"); you may not use this file except in
 *  compliance with the License. 
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 *
 * The Initial Developer of the Original Code is Adobe Systems Incorporated.
 * Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems
 * Incorporated. All Rights Reserved.
 **********************************************************/

package
{
			import flexunit.framework.*;
			import org.osmf.media.TestMediaPlayerWithStreamingRTMP_Vod;
			import org.osmf.media.TestMediaPlayerWithRTMPLive;
			import org.osmf.media.TestMediaPlayerWithRTMP_MBR;
			import org.osmf.media.TestMediaPlayerWithNonVideoAssets;
			import org.osmf.media.TestMediaPlayerWithAnonymusDRM_FLV;
			import org.osmf.elements.f4mClasses.TestMultiLevelManifestParser;
			import org.osmf.elements.f4mClasses.TestManifestParser;
			
			
			public class OSMFIntegrationTests
			{
				public static var testsToRun:Array = new Array();
				
				public static function currentRunTestSuite():Array
				{
					
					testsToRun.push(org.osmf.elements.f4mClasses.TestManifestParser);
					testsToRun.push(org.osmf.elements.f4mClasses.TestMultiLevelManifestParser);
					testsToRun.push(org.osmf.media.TestMediaPlayerWithAnonymusDRM_FLV);
					testsToRun.push(org.osmf.media.TestMediaPlayerWithNonVideoAssets);
					testsToRun.push(org.osmf.media.TestMediaPlayerWithRTMP_MBR);
					testsToRun.push(org.osmf.media.TestMediaPlayerWithRTMPLive);
					testsToRun.push(org.osmf.media.TestMediaPlayerWithStreamingRTMP_Vod);
					
					return testsToRun;
				}
			}
}