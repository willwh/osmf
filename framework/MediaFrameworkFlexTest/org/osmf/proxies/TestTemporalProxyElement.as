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
	
	import org.osmf.events.SeekingChangeEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.TestMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PausableTrait;
	import org.osmf.traits.PlayableTrait;
	import org.osmf.traits.SeekableTrait;
	import org.osmf.traits.TemporalTrait;
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
			
			assertTrue(mediaElement.getTrait(MediaTraitType.TEMPORAL) == null);
			assertTrue(proxy.getTrait(MediaTraitType.TEMPORAL) != null);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.PAUSABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.PAUSABLE) != null);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.PLAYABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.PLAYABLE) != null);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.SEEKABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.SEEKABLE) != null);
			
			assertTrue(proxy.getTrait(MediaTraitType.AUDIBLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.BUFFERABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.LOADABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.SPATIAL) == null);
			assertTrue(proxy.getTrait(MediaTraitType.VIEWABLE) == null);
		}
		
		public function testEvents():void
		{
			events = new Vector.<Event>();
			var mediaElement:MediaElement = new MediaElement();
			var proxy:TemporalProxyElement = new TemporalProxyElement(50, mediaElement);
			
			var temporal:TemporalTrait = proxy.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var pausable:PausableTrait = proxy.getTrait(MediaTraitType.PAUSABLE) as PausableTrait;
			var playable:PlayableTrait = proxy.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			var seekable:SeekableTrait = proxy.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, eventCatcher);
			
			playable.play();
			assertTrue(pausable.paused == false);
			pausable.pause();
			assertTrue(playable.playing == false);
			playable.play();
			assertTrue(pausable.paused == false);
			seekable.seek(15);			
			assertFalse(seekable.seeking);
			assertEquals(2, events.length);
			assertTrue(events[0] is SeekingChangeEvent);
			assertTrue(events[1] is SeekingChangeEvent);
			assertTrue(SeekingChangeEvent(events[0]).seeking);
			assertFalse(SeekingChangeEvent(events[1]).seeking);		
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
		
		override protected function get loadable():Boolean
		{
			return false;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource(new URL("http://example.com"));
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE, MediaTraitType.PLAYABLE, MediaTraitType.PAUSABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE, MediaTraitType.PLAYABLE, MediaTraitType.PAUSABLE];
		}

		private var events:Vector.<Event>;
	}
}