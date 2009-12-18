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
	
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicTimeTrait;
	
	public class TestSerialElementWithTimeTrait extends TestCase
	{
		public function testTimeTrait():void
		{
			var serial:SerialElement = new SerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.TIME) == null);
			
			// Create a few media elements with the TimeTrait and some
			// initial properties.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.TIME], null, null, true);
			var timeTrait1:DynamicTimeTrait = mediaElement1.getTrait(MediaTraitType.TIME) as DynamicTimeTrait;
			timeTrait1.duration = 10;
			timeTrait1.currentTime = 5;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.TIME], null, null, true);
			var timeTrait2:DynamicTimeTrait = mediaElement2.getTrait(MediaTraitType.TIME) as DynamicTimeTrait;
			timeTrait2.duration = 30;
			timeTrait2.currentTime = 10;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.TIME], null, null, true);
			var timeTrait3:DynamicTimeTrait = mediaElement3.getTrait(MediaTraitType.TIME) as DynamicTimeTrait;
			timeTrait3.duration = 20;
			timeTrait3.currentTime = 15;
			
			// Add the first child.  This should cause its properties to
			// propagate to the composition.
			serial.addChild(mediaElement1);
			var timeTrait:TimeTrait = serial.getTrait(MediaTraitType.TIME) as TimeTrait;
			assertTrue(timeTrait != null);
			assertTrue(timeTrait.duration == 10);
			assertTrue(timeTrait.currentTime == 5);
			
			// Change the first trait's currentTime. This should result in the composite
			// trait's currentTime changing too:
			timeTrait1.currentTime = 6;
			assertEquals(6, timeTrait.currentTime);
			
			// Change back to 5, for that's what the rest of the test expects:
			timeTrait1.currentTime = 5;
			
			// The composite trait's duration is the sum of all durations.  Its
			// currentTime is the currentTime of the current child within the entire
			// sequence.
			
			serial.addChild(mediaElement2);
			assertTrue(timeTrait.duration == 40);
			assertTrue(timeTrait.currentTime == 5);
			
			// We can change the current child by removing and re-adding the current one.
			serial.removeChild(mediaElement1);
			serial.addChildAt(mediaElement1, 0);
			timeTrait = serial.getTrait(MediaTraitType.TIME) as TimeTrait;
			assertTrue(timeTrait.duration == 40);
			assertTrue(timeTrait.currentTime == 20);

			serial.addChild(mediaElement3);
			assertTrue(timeTrait.duration == 60);
			assertTrue(timeTrait.currentTime == 20);
			
			serial.removeChild(mediaElement1);
			serial.removeChild(mediaElement2);
			serial.addChildAt(mediaElement1, 0);
			serial.addChildAt(mediaElement2, 1);
			
			timeTrait = serial.getTrait(MediaTraitType.TIME) as TimeTrait;
			assertTrue(timeTrait.duration == 60);
			assertTrue(timeTrait.currentTime == 55);
			
			timeTrait.addEventListener(TimeEvent.DURATION_REACHED, onDurationReached);
			
			// We should get a durationReached event when the current child
			// is the last child, and it reaches its duration.
			assertTrue(durationReachedEventCount == 0);
			timeTrait1.currentTime = 10;
			assertTrue(durationReachedEventCount == 0);
			timeTrait2.currentTime = 30;
			assertTrue(durationReachedEventCount == 0);
			timeTrait3.currentTime = 19;
			assertTrue(durationReachedEventCount == 0);
			timeTrait3.currentTime = 20;
			assertTrue(durationReachedEventCount == 1);
			
			// Adding a child before the current position should affect our
			// duration and position.
			var mediaElement4:MediaElement = new DynamicMediaElement([MediaTraitType.TIME], null, null, true);
			var timeTrait4:DynamicTimeTrait = mediaElement4.getTrait(MediaTraitType.TIME) as DynamicTimeTrait;
			timeTrait4.duration = 33;
			timeTrait4.currentTime = 22;
			serial.addChildAt(mediaElement4, 0);
			assertTrue(timeTrait.currentTime == 93);
			assertTrue(timeTrait.duration == 93);
			
			// Adding a child whose duration is NaN should not affect the
			// composite duration.
			var mediaElement5:MediaElement = new DynamicMediaElement([MediaTraitType.TIME], null, null, true);
			var timeTrait5:DynamicTimeTrait = mediaElement5.getTrait(MediaTraitType.TIME) as DynamicTimeTrait;
			timeTrait5.duration = NaN;
			serial.addChildAt(mediaElement5, 0);
			assertTrue(timeTrait.currentTime == 93);
			assertTrue(timeTrait.duration == 93);
		}
		
		private function onDurationChanged(event:TimeEvent):void
		{
			durationChangedEventCount++;
		}
		
		private function onDurationReached(event:TimeEvent):void
		{
			durationReachedEventCount++;
		}
		
		private var durationChangedEventCount:int = 0;
		private var durationReachedEventCount:int = 0;
	}
}