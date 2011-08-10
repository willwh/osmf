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
package org.osmf.utils
{
	import flexunit.framework.TestCase;

	public class TestOSMFSettings extends TestCase
	{
		public function testEnableOSMFSettings():void
		{
			OSMFSettings.enableStageVideo = true;
			assertTrue(OSMFSettings.enableStageVideo);
			
			OSMFSettings.enableStageVideo = false;
			assertFalse(OSMFSettings.enableStageVideo);
		}
		
		public function testSupportOSMFSettings():void
		{
			assertFalse(OSMFSettings.runtimeSupportsStageVideo(null));
			assertFalse(OSMFSettings.runtimeSupportsStageVideo(""));
			assertFalse(OSMFSettings.runtimeSupportsStageVideo("WIN 10,1,183,10"));
			assertTrue(OSMFSettings.runtimeSupportsStageVideo("WIN 10,2,0,0"));
			assertTrue(OSMFSettings.runtimeSupportsStageVideo("WIN 11,0,111,3"));
		}
	}
}
