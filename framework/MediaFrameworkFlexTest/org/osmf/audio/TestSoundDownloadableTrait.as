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
package org.osmf.audio
{
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.traits.TestDownloadableTrait;
	import org.osmf.utils.MockSound;

	public class TestSoundDownloadableTrait extends TestDownloadableTrait
	{
		override protected function createInterfaceObject(... args):Object
		{
			_sound = new MockSound();
			_initBytesLoaded = 50;
			_initBytesTotal = 100;
			_sound.bytesLoaded = _initBytesLoaded;
			_sound.bytesTotal = _initBytesTotal;
			
			return new SoundDownloadableTrait(_sound);
		}
		
		override public function testInitialProperties():void
		{
			assertTrue(downloadable.bytesDownloaded == _initBytesLoaded);
			assertTrue(downloadable.bytesTotal == _initBytesTotal);
		}	

		override public function testProperties():void
		{
			downloadable.addEventListener(BytesTotalChangeEvent.BYTES_TOTAL_CHANGE, eventCatcher);
			
			_sound.bytesTotal = 150;
			_sound.bytesLoaded = 10;
			
			assertTrue(downloadable.bytesDownloaded == 10);
			assertTrue(downloadable.bytesTotal == 150);
			assertTrue(events.length == 1);

			_sound.bytesTotal = 150;
			assertTrue(events.length == 1);
		}
		
		private var _sound:MockSound;
		private var _initBytesLoaded:uint;
		private var _initBytesTotal:uint;
	}
}