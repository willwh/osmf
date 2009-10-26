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
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.image.ImageElement;
	import org.osmf.image.ImageLoader;
	import org.osmf.media.TestMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.IDownloadable;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;

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
		
		// Add some IDownloadable testing:
		//
		
		public function testDownloadableViaImage():void
		{
			var image:ImageElement = new ImageElement(new ImageLoader, new URLResource(new URL("assets/image.gif")));
			
			var loadable:ILoadable = image.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			
			loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, addAsync(onLoadableStateChange,3000));
			loadable.load();
			
			var count:int = 0;
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				var downloadable:IDownloadable;
				
				count++;
				if (count == 1)
				{
					assertEquals(LoadState.LOADING,event.newState);
					downloadable = image.getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable;
					assertNotNull(downloadable);
					assertEquals(NaN, downloadable.bytesDownloaded);
					assertEquals(NaN, downloadable.bytesTotal);
					
					downloadable.addEventListener(BytesTotalChangeEvent.BYTES_TOTAL_CHANGE, addAsync(onBytesTotalChange,3000));
				}
				else if (count == 2)
				{
					assertEquals(LoadState.LOADED,event.newState);
					downloadable = image.getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable;
					assertNotNull(downloadable);
					assertEquals(2248, downloadable.bytesDownloaded);
					assertEquals(2248, downloadable.bytesTotal);
				}
			}
			
			function onBytesTotalChange(event:BytesTotalChangeEvent):void
			{
				var downloadable:IDownloadable = event.target as IDownloadable;
				assertNotNull(downloadable);
				assertEquals(event.oldValue, NaN);
				assertEquals(event.newValue, 2248);
			}
		}
	}
}