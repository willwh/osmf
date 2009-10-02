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
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.utils.DynamicMediaElement;
	
	public class TestPlayableTrait extends TestIPlayable
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
			return new PlayableTrait(mediaElement);
		}
		
		protected function createPausableTrait():PausableTrait
		{
			return new PausableTrait(mediaElement);
		}
		
		override public function testPlay():void
		{
			super.testPlay();
			
			// Stop: 
			PlayableTrait(playable).resetPlaying();
			
			assertFalse(playable.playing);
			
			// Should trigger a change event:
			assertTrue(events.length == 2);
			
			var pce:PlayingChangeEvent;
			
			// Verify if the event holds the correct info:			
			pce = events[1] as PlayingChangeEvent;
			assertNotNull(pce);
			assertFalse(pce.playing);
		}
		
		public function testConstructor():void
		{
			try
			{
				new PlayableTrait(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}
		
		public function testPlayWithPausableTrait():void
		{
			var pausable:PausableTrait = createPausableTrait();
			mediaElement.doAddTrait(MediaTraitType.PAUSABLE, pausable);

			assertFalse(playable.playing);
			assertFalse(pausable.paused);
			
			pausable.pause();
			
			assertFalse(playable.playing);
			assertTrue(pausable.paused);
			
			// Playing should cause the PausableTrait to reset its state.
			playable.play();

			assertTrue(playable.playing);
			assertFalse(pausable.paused);
		}
		
		protected var mediaElement:DynamicMediaElement;
	}
}