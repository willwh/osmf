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
package org.osmf.content
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.TestMediaElement;
	import org.osmf.traits.IDownloadable;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;

	public class TestContentElementIntegration extends TestMediaElement
	{
		override protected function get loadable():Boolean
		{
			return true;
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return 	[ MediaTraitType.LOADABLE
					];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return 	[ MediaTraitType.LOADABLE
					, MediaTraitType.DOWNLOADABLE
					, MediaTraitType.SPATIAL
					, MediaTraitType.VIEWABLE
				   	];
		}
		
		/**
		 * Subclasses should override to specify the total number of bytes
		 * represented by resourceForMediaElement.
		 **/
		protected function get expectedBytesTotal():Number
		{
			return NaN;
		}
		
		// Add some IDownloadable testing:
		//
		
		public function testDownloadable():void
		{
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			var count:int = 0;
			var bytesTotalFired:Boolean = false;
			
			var element:MediaElement = createMediaElement();
			element.resource = resourceForMediaElement;
			
			var loadable:ILoadable = element.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			
			eventDispatcher.addEventListener(Event.COMPLETE, addAsync(mustReceiveEvent, 10000));
			
			loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
			loadable.load();
			
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				var downloadable:IDownloadable;
				
				count++;
				if (count == 1)
				{
					assertEquals(LoadState.LOADING, event.newState);
					downloadable = element.getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable;
					assertNotNull(downloadable);
					assertEquals(NaN, downloadable.bytesDownloaded);
					assertEquals(NaN, downloadable.bytesTotal);
					
					downloadable.addEventListener(BytesTotalChangeEvent.BYTES_TOTAL_CHANGE, onBytesTotalChange);
				}
				else if (count == 2)
				{
					assertEquals(LoadState.LOADED, event.newState);
					downloadable = element.getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable;
					assertNotNull(downloadable);
					assertEquals(expectedBytesTotal, downloadable.bytesDownloaded);
					assertEquals(expectedBytesTotal, downloadable.bytesTotal);
					
					assertTrue(bytesTotalFired);
					
					eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			
			function onBytesTotalChange(event:BytesTotalChangeEvent):void
			{
				var downloadable:IDownloadable = event.target as IDownloadable;
				assertNotNull(downloadable);
				assertEquals(event.oldValue, NaN);
				assertEquals(event.newValue, expectedBytesTotal);
				
				bytesTotalFired = true;
			}
		}
	}
}