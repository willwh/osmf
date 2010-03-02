/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.net.dvr
{
	import org.osmf.events.DVREvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.flexunit.TestCaseEx;

	public class TestDVRCastTimeTrait extends TestCaseEx
	{
		public function testDVRCastTimeTrait():void
		{
			assertThrows(function():void{ new DVRCastTimeTrait(null, null); });
			
			var nc:MockDVRCastNetConnection = new MockDVRCastNetConnection();
			
			
			assertThrows(function():void{ new DVRCastTimeTrait(nc, null); });
			
			var now:Date = new Date();
			nc.streamInfo 
				= new DVRCastStreamInfo
					(	{ callTime: now
						, offline: false
						, begOffset: 0
						, endOffset: 0
						, startRec: now
						, stopRec: now
						, isRec: false
						, streamName: "test"
						, lastUpdate: now
						, currLen: 0
						, maxLen: 0
						}
					);
			nc.recordingInfo = new DVRCastRecordingInfo();
			nc.recordingInfo.startTime = now;
			
			var stream:DVRCastNetStream = new DVRCastNetStream(nc);
			var tt:DVRCastTimeTrait = new DVRCastTimeTrait(nc, stream);
			assertEquals(0, tt.currentTime);
			assertEquals(NaN, tt.duration);
			
			assertNotNull(tt);
			
			nc.streamInfo.isRecording = true;
			
			tt.addEventListener(TimeEvent.DURATION_CHANGE, addAsync(onDurationChange, 7000));
			
			function onDurationChange(event:TimeEvent):void
			{
				//
			} 
		}
		
	}
}