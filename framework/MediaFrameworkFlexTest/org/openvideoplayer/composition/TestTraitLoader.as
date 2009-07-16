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
package org.openvideoplayer.composition
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.ISeekable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausibleTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.SimpleLoader;
	
	public class TestTraitLoader extends TestCase
	{
		public function testFindOrLoadMediaElementWithTrait():void
		{
			var traitLoader:TraitLoader = new TraitLoader();
			traitLoader.addEventListener(TraitLoaderEvent.TRAIT_FOUND, onTraitFound);
			
			var mediaElements:Array = [];
			
			// Calling on an empty list should result in no returned
			// MediaElement.
			traitLoader.findOrLoadMediaElementWithTrait(mediaElements, MediaTraitType.SEEKABLE);
			assertTrue(traitFoundEvents.length == 1);
			var traitFoundEvent:TraitLoaderEvent = TraitLoaderEvent(traitFoundEvents[0]);
			assertTrue(traitFoundEvent.mediaElement == null);
			
			// Create a few media elements.
			//

			var mediaElement1:MediaElement =
				new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.VIEWABLE]);

			var loader2:SimpleLoader = new SimpleLoader();
			var mediaElement2:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE, MediaTraitType.TEMPORAL],
										loader2,
										new URLResource("http://www.example.com/loadable2"));
			
			var loader3:SimpleLoader = new SimpleLoader();
			var mediaElement3:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE, MediaTraitType.SPATIAL, MediaTraitType.SEEKABLE],
										loader3,
										new URLResource("http://www.example.com/loadable3"));

			var mediaElement4:MediaElement =
				new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE, MediaTraitType.PLAYABLE, MediaTraitType.PAUSIBLE]);
			
			mediaElements = [mediaElement1, mediaElement2, mediaElement3, mediaElement4]; 

			traitLoader.findOrLoadMediaElementWithTrait(mediaElements, MediaTraitType.SEEKABLE);
			
			// Second child should be loaded, but not seekable.
			var loadable2:ILoadable = mediaElement2.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable2.loadState == LoadState.LOADED);
			var seekable2:ISeekable = mediaElement2.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			assertTrue(seekable2 == null);
			
			// Third child already had the trait, so it wasn't loaded.
			var loadable3:ILoadable = mediaElement3.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable3.loadState == LoadState.CONSTRUCTED);
			var seekable3:ISeekable = mediaElement3.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			assertTrue(seekable3 != null);

			// Found child is the third child.
			assertTrue(traitFoundEvents.length == 2);
			traitFoundEvent = TraitLoaderEvent(traitFoundEvents[1]);
			assertTrue(traitFoundEvent.mediaElement == mediaElement3);
			
			// Should get the same result if we call it again.
			traitLoader.findOrLoadMediaElementWithTrait(mediaElements, MediaTraitType.SEEKABLE);
			assertTrue(traitFoundEvents.length == 3);
			traitFoundEvent = TraitLoaderEvent(traitFoundEvents[2]);
			assertTrue(traitFoundEvent.mediaElement == mediaElement3);
			
			// Try again with a trait that gets loaded.
			loadable3.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.loadable.loadState == LoadState.LOADED)
				{
					loadable3.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
					DynamicMediaElement(mediaElement3).doAddTrait(MediaTraitType.PAUSIBLE, new PausibleTrait());
				}
			}
			traitLoader.findOrLoadMediaElementWithTrait(mediaElements, MediaTraitType.PAUSIBLE);

			// Second child should be loaded, but not pausible.
			loadable2 = mediaElement2.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable2.loadState == LoadState.LOADED);
			assertTrue(mediaElement2.getTrait(MediaTraitType.PAUSIBLE) == null);
			
			// Third child already didn't have the trait, but added it after loading.
			loadable3 = mediaElement3.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable3.loadState == LoadState.LOADED);
			assertTrue(mediaElement3.getTrait(MediaTraitType.PAUSIBLE) != null);

			// Found child is the third child.
			assertTrue(traitFoundEvents.length == 4);
			traitFoundEvent = TraitLoaderEvent(traitFoundEvents[3]);
			assertTrue(traitFoundEvent.mediaElement == mediaElement3);
			
			// If we remove the third child, we should get the fourth.
			mediaElements = [mediaElement1, mediaElement2, mediaElement4];
			traitLoader.findOrLoadMediaElementWithTrait(mediaElements, MediaTraitType.PAUSIBLE);
			assertTrue(traitFoundEvents.length == 5);
			traitFoundEvent = TraitLoaderEvent(traitFoundEvents[4]);
			assertTrue(traitFoundEvent.mediaElement == mediaElement4);
			
			// Without the fourth child, we get no result.
			mediaElements = [mediaElement1, mediaElement2];
			traitLoader.findOrLoadMediaElementWithTrait(mediaElements, MediaTraitType.PAUSIBLE);
			assertTrue(traitFoundEvents.length == 6);
			traitFoundEvent = TraitLoaderEvent(traitFoundEvents[5]);
			assertTrue(traitFoundEvent.mediaElement == null);
		}
		
		private function onTraitFound(event:TraitLoaderEvent):void
		{
			traitFoundEvents.push(event);
		}
		
		override public function setUp():void
		{
			super.setUp();
			
			traitFoundEvents = []
		}
		
		private var traitFoundEvents:Array = []
	}
}