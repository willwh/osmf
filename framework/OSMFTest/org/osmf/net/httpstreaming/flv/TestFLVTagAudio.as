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
package org.osmf.net.httpstreaming.flv
{
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;

	public class TestFLVTagAudio extends TestCase
	{
		public function TestFLVTagAudio(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testBasicAudioTagStructure():void
		{
			var soundData:ByteArray = new ByteArray();
			soundData.writeByte(1);
			for (var i:int = 0; i < 10; i++)
			{
				soundData.writeByte(i);
			}
			soundData.position = 0;
			
			var timeStamp:uint = new Date().getTime();
			var ba:ByteArray = FLVTestHelper.createFLVAudioTag(
				8,	// audio 
				soundData.length + 1, 
				timeStamp, 
				0,	// always 0
				10,	// AAC
				3,	// 44 kHz
				1,	// snd16Bit
				1,	// sndStereo
				soundData);  
			ba.position = 0;
			
			try
			{
				var audioTag:FLVTagAudio = new FLVTagAudio();
				audioTag.read(ba);
				
				assertTrue(audioTag.tagType == 8);
				
			}
			catch (e:Error)
			{
				assertTrue(false);
			}
		}
	}
}