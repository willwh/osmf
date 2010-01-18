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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.proxies
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import org.osmf.events.SeekEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaElement;
	import org.osmf.media.TestMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.URL;

	public class TestTemporalProxyElement extends TestMediaElement
	{
		public function TestTemporalProxyElement()
		{
			super();
		}
		
		public function testConstructor():void
		{
			try 
			{
				new TemporalProxyElement(NaN);
				new TemporalProxyElement(NaN, new MediaElement());
			}
			catch(error:IllegalOperationError)
			{
				fail();
			}
		}
		
		public function testTraits():void
		{
			var mediaElement:MediaElement = new MediaElement();
			var proxy:TemporalProxyElement = new TemporalProxyElement(NaN, mediaElement);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.TIME) == null);
			assertTrue(proxy.getTrait(MediaTraitType.TIME) != null);
						
			assertTrue(mediaElement.getTrait(MediaTraitType.PLAY) == null);
			assertTrue(proxy.getTrait(MediaTraitType.PLAY) != null);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.SEEK) == null);
			assertTrue(proxy.getTrait(MediaTraitType.SEEK) != null);
			
			assertTrue(proxy.getTrait(MediaTraitType.AUDIO) == null);
			assertTrue(proxy.getTrait(MediaTraitType.BUFFER) == null);
			assertTrue(proxy.getTrait(MediaTraitType.LOAD) == null);
			assertTrue(proxy.getTrait(MediaTraitType.DISPLAY_OBJECT) == null);
		}
		
		public function testEvents():void
		{
			events = new Vector.<Event>();
			var mediaElement:MediaElement = new MediaElement();
			var proxy:TemporalProxyElement = new TemporalProxyElement(50, mediaElement);
			
			var timeTrait:TimeTrait = proxy.getTrait(MediaTraitType.TIME) as TimeTrait;
			var playTrait:PlayTrait = proxy.getTrait(MediaTraitType.PLAY) as PlayTrait;
			var seekTrait:SeekTrait = proxy.getTrait(MediaTraitType.SEEK) as SeekTrait;
			seekTrait.addEventListener(SeekEvent.SEEK_BEGIN, eventCatcher);
			seekTrait.addEventListener(SeekEvent.SEEK_END, eventCatcher);
			
			playTrait.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			playTrait.pause();
			assertTrue(playTrait.playState == PlayState.PAUSED);
			playTrait.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			seekTrait.seek(15);			
			assertFalse(seekTrait.seeking);
			assertEquals(2, events.length);
			assertTrue(events[0] is SeekEvent);
			assertTrue(events[1] is SeekEvent);
			assertTrue(SeekEvent(events[0]).type == SeekEvent.SEEK_BEGIN);
			assertTrue(SeekEvent(events[1]).type == SeekEvent.SEEK_END);		
		}
		
		public function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		// Overrides
		//
		
		override protected function createMediaElement():MediaElement
		{
			return new TemporalProxyElement(0);
		}
		
		override protected function get hasLoadTrait():Boolean
		{
			return false;
		}
		
		override protected function get resourceForMediaElement():MediaResourceBase
		{
			return new URLResource(new URL("http://example.com"));
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.TIME, MediaTraitType.SEEK, MediaTraitType.PLAY];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [MediaTraitType.TIME, MediaTraitType.SEEK, MediaTraitType.PLAY];
		}

		private var events:Vector.<Event>;
	}
}