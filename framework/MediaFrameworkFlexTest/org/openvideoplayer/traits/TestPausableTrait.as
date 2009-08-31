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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.PausedChangeEvent;
	import org.openvideoplayer.utils.DynamicMediaElement;
	
	public class TestPausableTrait extends TestIPausable
	{
		override public function setUp():void
		{
			mediaElement = new DynamicMediaElement();
			
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			mediaElement = null;
		}
		
		override protected function createInterfaceObject(... args):Object
		{
			return new PausableTrait(mediaElement);
		}

		protected function createPlayableTrait():PlayableTrait
		{
			return new PlayableTrait(mediaElement);
		}
		
		public function testConstructor():void
		{
			try
			{
				new PausableTrait(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}

		// Unpause is not on IPausable, hence we need to test it 'manually'
		// here:
		
		public function testUnpause():void
		{
			assertFalse(pausable.paused);
			
			pausable.addEventListener(PausedChangeEvent.PAUSED_CHANGE,eventCatcher);
			
			pausable.pause();
			assertTrue(pausable.paused);
			
			assertTrue(events.length == 1);
			var pce:PausedChangeEvent = events[0] as PausedChangeEvent;
			assertNotNull(pce);
			assertTrue(pce.paused);
			
			PausableTrait(pausable).resetPaused();
			assertFalse(pausable.paused);
			
			assertTrue(events.length == 2);
			pce = events[1] as PausedChangeEvent;
			assertNotNull(pce);
			assertFalse(pce.paused);
		}
		
		public function testPauseWithPlayableTrait():void
		{
			var playable:PlayableTrait = createPlayableTrait();
			mediaElement.doAddTrait(MediaTraitType.PLAYABLE, playable);

			assertFalse(playable.playing);
			assertFalse(pausable.paused);
			
			// Pausing before doing anything should have no effect.
			pausable.pause();

			assertFalse(playable.playing);
			assertFalse(pausable.paused);
			
			playable.play();
			
			assertTrue(playable.playing);
			assertFalse(pausable.paused);
			
			// Pausing should cause the PlayableTrait to reset its state.
			pausable.pause();

			assertFalse(playable.playing);
			assertTrue(pausable.paused);
		}
		
		protected var mediaElement:DynamicMediaElement;		
	}
}