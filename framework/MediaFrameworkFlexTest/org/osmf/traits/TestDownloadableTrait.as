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
package org.osmf.traits
{
	import org.osmf.events.LoadEvent;
	
	public class TestDownloadableTrait extends TestIDownloadable
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new DownloadableTrait();
		}
		
		public function testInitialProperties():void
		{
			assertTrue(isNaN(downloadable.bytesLoaded));
			assertTrue(isNaN(downloadable.bytesTotal));
		}
		
		public function testProperties():void
		{
			var downloadableTrait:DownloadableTrait = downloadable as DownloadableTrait;
			assertTrue(downloadableTrait != null);
			
			downloadableTrait.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE, eventCatcher);
			
			downloadableTrait.bytesTotal = 100;
			downloadableTrait.bytesLoaded = 50;
			
			assertTrue(downloadableTrait.bytesLoaded == 50);
			assertTrue(downloadableTrait.bytesTotal == 100);
			
			assertTrue(events.length == 1);
		}
		
		public function testPropertiesWithErrors():void
		{
			var downloadableTrait:DownloadableTrait = downloadable as DownloadableTrait;
			assertTrue(downloadableTrait != null);
			
			downloadableTrait.bytesTotal = 100;
			downloadableTrait.bytesLoaded = 50;
			
			try
			{
				downloadableTrait.bytesLoaded = 120;
				assertTrue(false);
			}
			catch(error:ArgumentError)
			{
			}
			
			downloadableTrait.bytesTotal = 100;
			
			try
			{
				downloadableTrait.bytesTotal = 20;
				assertTrue(false);
			}
			catch(error:ArgumentError)
			{
			}
		}
	}
}