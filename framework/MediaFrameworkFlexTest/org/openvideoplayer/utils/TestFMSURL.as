/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.openvideoplayer.utils
{
	import flexunit.framework.TestCase;

	public class TestFMSURL extends TestCase
	{
		public function testExtensionStipping():void
		{
			var testURL:String = "rtmp://testserver/myapp/myfile.flv";
			var testURL2:String = "rtmp://testserver/myapp/myfile2.flv2";
			var testURL3:String = "rtmp://testserver/myapp/mp4:myfile2.flv2";
			var testURL4:String = "rtmp://testserver/myapp/mp3:myfile2.flv";
			var testURL5:String = "rtmp://testserver/myapp/myfile2.flv2.flv";
			var testURL6:String = "rtmp://testserver/myapp/myfile6.flv?param=myparam.flv";
			var testURL7:String = "rtmp://testserver/myapp/myfile7.flv2?param=myparam.flv2";
			
			var fms1:FMSURL = new FMSURL(new URL(testURL));
			var fms2:FMSURL = new FMSURL(new URL(testURL2));
			var fms3:FMSURL = new FMSURL(new URL(testURL3));
			var fms4:FMSURL = new FMSURL(new URL(testURL4));
			var fms5:FMSURL = new FMSURL(new URL(testURL5));
			var fms6:FMSURL = new FMSURL(new URL(testURL6));
			var fms7:FMSURL = new FMSURL(new URL(testURL7));
			
			//Test 1			
			assertEquals(fms1.streamType, null);
			assertEquals(fms1.streamName, "myfile.flv");
			assertEquals(fms1.appName, "myapp");
			
			//Test 2	
			assertEquals(fms2.streamType, null);
			assertEquals(fms2.streamName, "myfile2.flv2");
			assertEquals(fms2.appName, "myapp");
			
			//Test 3	
			assertEquals(fms3.streamType, FMSURL.MP4_STREAM);
			assertEquals(fms3.streamName, "mp4:myfile2.flv2");
			assertEquals(fms3.appName, "myapp");
			
			//Test 4	
			assertEquals(fms4.streamType, FMSURL.MP3_STREAM);
			assertEquals(fms4.streamName, "mp3:myfile2.flv");
			assertEquals(fms4.appName, "myapp");
			
			//Test 5
			assertEquals(fms5.streamType, null);
			assertEquals(fms5.streamName, "myfile2.flv2.flv");
			assertEquals(fms5.appName, "myapp");
			
			//Test 6	
			assertEquals(fms6.streamType, null);
			assertEquals(fms6.streamName, "myfile6.flv");
			assertEquals(fms6.appName, "myapp");
			
			//Test 7
			assertEquals(fms7.streamType, null);
			assertEquals(fms7.streamName , "myfile7.flv2");
			assertEquals(fms7.appName, "myapp");
			
		}
		
	}
}