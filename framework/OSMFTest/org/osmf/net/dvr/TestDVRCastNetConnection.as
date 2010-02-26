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
	import org.osmf.flexunit.TestCaseEx;

	public class TestDVRCastNetConnection extends TestCaseEx
	{
		public function testDVRCastNetConnection(methodName:String=null):void
		{
			// Pro forma (the class derives from NetConnection, adding to properties:
			var c:DVRCastNetConnection = new DVRCastNetConnection();
			var ri:DVRCastRecordingInfo = new DVRCastRecordingInfo();
			c.recordingInfo = ri;
			assertEquals(ri, c.recordingInfo);
			c.streamInfo = null;
			assertNull(c.streamInfo);
		}
		
	}
}