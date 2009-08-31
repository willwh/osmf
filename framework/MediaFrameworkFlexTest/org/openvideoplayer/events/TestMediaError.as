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
package org.openvideoplayer.events
{
	import flexunit.framework.TestCase;
	
	public class TestMediaError extends TestCase
	{
		public function testGetters():void
		{
			var mediaError:MediaError = createMediaError(999);
			assertTrue(mediaError.errorCode == 999);
			assertTrue(mediaError.description == "");
			assertTrue(mediaError.detail == null);
			
			mediaError = createMediaError(MediaErrorCodes.INVALID_URL_PROTOCOL, "Here are some details...");
			assertTrue(mediaError.errorCode == MediaErrorCodes.INVALID_URL_PROTOCOL);
			assertTrue(mediaError.description == "Invalid URL protocol");
			assertTrue(mediaError.detail == "Here are some details...");

			mediaError = createMediaError(33, "");
			assertTrue(mediaError.errorCode == 33);
			assertTrue(mediaError.description == "");
			assertTrue(mediaError.detail == "");
		}
		
		protected function createMediaError(errorCode:int, detail:String=null):MediaError
		{
			return new MediaError(errorCode, detail);
		}
	}
}