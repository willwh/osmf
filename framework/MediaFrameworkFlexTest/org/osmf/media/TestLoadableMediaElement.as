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
package org.osmf.media
{
	import flash.events.Event;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.SimpleLoader;
	
	public class TestLoadableMediaElement extends TestMediaElement
	{
		override protected function createMediaElement():MediaElement
		{
			return new LoadableMediaElement(new SimpleLoader()); 
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new NullResource();
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.LOADABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [MediaTraitType.LOADABLE];
		}
		
		public function testConstructor():void
		{
			try
			{
				var mediaElement:MediaElement = new LoadableMediaElement(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
				// Swallow.
			}
		}
		
		public function testSetResourceUnloadsPreviousLoadable():void
		{
			var mediaElement:MediaElement = createMediaElement();
			mediaElement.resource = resourceForMediaElement;
			
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));

			var loadable:ILoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			loadable.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onTestSetResourceUnloadsPreviousLoadable
					);
			loadable.load();
			
			function onTestSetResourceUnloadsPreviousLoadable(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					// If we set a new resource on the MediaElement, that
					// should result in the ILoadable (which corresponds to
					// the previous resource) being unloaded.
					mediaElement.resource = resourceForMediaElement;
				}
				else if (event.loadState == LoadState.UNINITIALIZED)
				{
					loadable.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onTestSetResourceUnloadsPreviousLoadable);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
	}
}