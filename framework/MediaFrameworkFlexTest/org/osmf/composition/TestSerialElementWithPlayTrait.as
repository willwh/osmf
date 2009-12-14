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
package org.osmf.composition
{
	import flexunit.framework.TestCase;
	
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.events.PlayEvent;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicPlayTrait;
	
	public class TestSerialElementWithPlayTrait extends TestCase
	{
		public function testPlayTrait():void
		{
			var serial:SerialElement = new SerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.PLAY) == null);
			
			// Create a few media elements with the PlayTrait.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY]);
			var playTrait1:PlayTrait = mediaElement1.getTrait(MediaTraitType.PLAY) as PlayTrait;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY]);
			var playTrait2:PlayTrait = mediaElement2.getTrait(MediaTraitType.PLAY) as PlayTrait;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY]);
			var playTrait3:PlayTrait = mediaElement3.getTrait(MediaTraitType.PLAY) as PlayTrait;
			
			// Adding a playing child should cause the composite trait to be
			// playing.
			playTrait1.play();
			serial.addChild(mediaElement1);
			var playTrait:PlayTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			assertTrue(playTrait.playState == PlayState.PLAYING);
						
			// Removing the last child should cause the composite trait to
			// disappear.
			serial.removeChild(mediaElement1);
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait == null);
			
			playTrait1.stop();

			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			assertTrue(playTrait.playState == PlayState.STOPPED);
			
			playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChanged);
			
			// Playing the composite trait should cause the current child to
			// play (and dispatch an event).
			playTrait.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.PLAYING);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			assertTrue(playStateChangedEventCount == 1);
			
			// When the current child stops playing, the next child should
			// automatically play.
			playTrait1.stop();
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.PLAYING);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			
			// Note that we get two events with the stop() call, one for
			// the stop of the current child, another for the play of the
			// next child.  From the client's perspective, it's probably
			// more appropriate to get no events given that (to them) the
			// SerialElement just keeps playing.
			assertTrue(playStateChangedEventCount == 3);

			playTrait2.stop();
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.PLAYING);
			assertTrue(playStateChangedEventCount == 5);

			playTrait3.stop();
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait.playState == PlayState.STOPPED);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			assertTrue(playStateChangedEventCount == 6);
			
			// Playing a non-current child when the composite trait is not
			// playing should have no effect on the composite trait.
			playTrait2.play();
			assertTrue(playTrait.playState == PlayState.STOPPED);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.PLAYING);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			assertTrue(playStateChangedEventCount == 6);

			playTrait2.stop();
			
			// But playing the current child should.
			playTrait3.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.PLAYING);
			assertTrue(playStateChangedEventCount == 7);

			// Playing a non-current child when the composite trait is
			// playing should also have no effect on the composite trait.
			playTrait2.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.PLAYING);
			assertTrue(playTrait3.playState == PlayState.PLAYING);
			assertTrue(playStateChangedEventCount == 7);
			
			// Pausing should affect the appropriate child (but not the
			// others).
			playTrait.pause();
			assertTrue(playTrait.playState == PlayState.PAUSED);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.PLAYING);
			assertTrue(playTrait3.playState == PlayState.PAUSED);
			assertTrue(playStateChangedEventCount == 8);
		}
		
		public function testPlayTraitWithCanPause():void
		{
			var serial:SerialElement = new SerialElement();
			
			// Create a few media elements with the PlayTrait.
			//
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY], null, null, true);
			var playTrait1:DynamicPlayTrait = mediaElement1.getTrait(MediaTraitType.PLAY) as DynamicPlayTrait;
			assertTrue(playTrait1.canPause);
			playTrait1.play();
			assertTrue(playTrait1.playState == PlayState.PLAYING);

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY], null, null, true);
			var playTrait2:DynamicPlayTrait = mediaElement2.getTrait(MediaTraitType.PLAY) as DynamicPlayTrait;
			
			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY], null, null, true);
			var playTrait3:DynamicPlayTrait = mediaElement3.getTrait(MediaTraitType.PLAY) as DynamicPlayTrait;
			
			// Make some unpausable.
			playTrait1.canPause = false;
			playTrait3.canPause = false;
			
			// The composition's canPause state should always reflect that of
			// the current child.
			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			var playTrait:PlayTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait.canPause == false);
			
			playTrait.addEventListener(PlayEvent.CAN_PAUSE_CHANGE, onCanPauseChanged);
			
			playTrait1.stop();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait.canPause == true);
			assertTrue(canPauseChangedEventCount == 1);
			
			playTrait2.stop();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait.canPause == false);
			assertTrue(canPauseChangedEventCount == 2);
			
			playTrait3.stop();
			assertTrue(playTrait.playState == PlayState.STOPPED);
			assertTrue(playTrait.canPause == false);
			assertTrue(canPauseChangedEventCount == 2);
		}
		
		public function testPlayTraitWithTimeTrait():void
		{
			var serial:SerialElement = new SerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.PLAY) == null);
			
			// Create a few media elements with the PlayTrait.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY, MediaTraitType.TIME]);
			var playTrait1:PlayTrait = mediaElement1.getTrait(MediaTraitType.PLAY) as PlayTrait;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY, MediaTraitType.TIME]);
			var playTrait2:PlayTrait = mediaElement2.getTrait(MediaTraitType.PLAY) as PlayTrait;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY, MediaTraitType.TIME]);
			var playTrait3:PlayTrait = mediaElement3.getTrait(MediaTraitType.PLAY) as PlayTrait;
			
			// Adding a playing child should cause the composite trait to be
			// "playing".
			playTrait1.play();
			serial.addChild(mediaElement1);
			var playTrait:PlayTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			assertTrue(playTrait.playState == PlayState.PLAYING);
			
			// Removing the last child should cause the composite trait to
			// disappear.
			serial.removeChild(mediaElement1);
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait == null);
			
			playTrait1.stop();

			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			assertTrue(playTrait.playState == PlayState.STOPPED);
			
			playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChanged);
			
			// Playing the composite trait should cause the current child to
			// play (and dispatch an event).
			playTrait.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.PLAYING);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			assertTrue(playStateChangedEventCount == 1);
			
			// When the current child stops playing, the next child does not
			// automatically play.  When the temporal trait is present, the
			// durationReached event is what's used to trigger playback of
			// the next child.
			playTrait1.stop();
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait.playState == PlayState.STOPPED);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			assertTrue(playStateChangedEventCount == 2);
		}
		
		public function testPlayTraitWithParallelPlayingPlayTrait():void
		{
			// We'll place our SerialElement in parallel with another element
			// which is playing.
			var parallel:ParallelElement = new ParallelElement();
			var mediaElement0:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY, MediaTraitType.TIME]);
			parallel.addChild(mediaElement0);
			var playTrait0:PlayTrait = mediaElement0.getTrait(MediaTraitType.PLAY) as PlayTrait;
			playTrait0.play();
			assertTrue(playTrait0.playState == PlayState.PLAYING);
			
			var serial:SerialElement = new SerialElement();
			parallel.addChild(serial);
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.PLAY) == null);
			
			// Create a few media elements with the PlayTrait.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY]);
			var playTrait1:PlayTrait = mediaElement1.getTrait(MediaTraitType.PLAY) as PlayTrait;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY]);
			var playTrait2:PlayTrait = mediaElement2.getTrait(MediaTraitType.PLAY) as PlayTrait;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.PLAY]);
			var playTrait3:PlayTrait = mediaElement3.getTrait(MediaTraitType.PLAY) as PlayTrait;
			
			// Adding a playing child should cause the composite trait to be
			// "playing".
			playTrait1.play();
			serial.addChild(mediaElement1);
			var playTrait:PlayTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			assertTrue(playTrait.playState == PlayState.PLAYING);
			
			// Removing the last child should cause the composite trait to
			// disappear.
			serial.removeChild(mediaElement1);
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait == null);
			
			playTrait1.stop();

			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			
			// The first child should be playing by virtue of being in parallel
			// with a playing element.
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.PLAYING);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			
			// When the current child stops playing, the next child should
			// automatically play.
			playTrait1.stop();
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.PLAYING);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			
			var playTrait3HasPlayed:Boolean = false;
			
			function onPlayTrait3PlayingChange(event:PlayEvent):void
			{
				playTrait3.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayTrait3PlayingChange);
				if (event.playState == PlayState.PLAYING)
				{
					playTrait3.stop();
					playTrait3HasPlayed = true;
				}
			}
			
			// If the playing of a child is synchronous (i.e. it resets its
			// own playing state within its play call), then we should
			// expect the following child to play.
			playTrait3.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayTrait3PlayingChange);
			playTrait2.stop();
			playTrait = serial.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait.playState == PlayState.STOPPED);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.STOPPED);
			
			assertTrue(playTrait3HasPlayed == true);
			
			// Playing a non-current child when the composite trait is not
			// playing should have no effect on the composite trait.
			playTrait2.play();
			assertTrue(playTrait.playState == PlayState.STOPPED);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.PLAYING);
			assertTrue(playTrait3.playState == PlayState.STOPPED);

			playTrait2.stop();
			
			// But playing the current child should.
			playTrait3.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.STOPPED);
			assertTrue(playTrait3.playState == PlayState.PLAYING);

			// Playing a non-current child when the composite trait is
			// playing should also have no effect on the composite trait.
			playTrait2.play();
			assertTrue(playTrait.playState == PlayState.PLAYING);
			assertTrue(playTrait1.playState == PlayState.STOPPED);
			assertTrue(playTrait2.playState == PlayState.PLAYING);
			assertTrue(playTrait3.playState == PlayState.PLAYING);
		}
		
		private function onPlayStateChanged(event:PlayEvent):void
		{
			playStateChangedEventCount++;
		}

		private function onCanPauseChanged(event:PlayEvent):void
		{
			canPauseChangedEventCount++;
		}
		
		private var playStateChangedEventCount:int = 0;
		private var canPauseChangedEventCount:int = 0;
	}
}