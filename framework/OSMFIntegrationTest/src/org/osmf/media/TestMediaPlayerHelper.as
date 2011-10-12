/*****************************************************
 *  
 *  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2011 Adobe Systems 
 *  Incorporated. All Rights Reserved. 
 *  
 *****************************************************/
package org.osmf.media
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.osmf.events.MediaError;
	
	public class TestMediaPlayerHelper extends EventDispatcher
	{		
		[Before]
		public function setUp():void
		{
			playerHelper = new MediaPlayerHelper();
		}
		
		[After]
		public function tearDown():void
		{
			playerHelper.dispose();
			playerHelper = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		/// Protected event handlers
		/**
		 * @private
		 * 
		 * Event handler called when an error was encountered.
		 */
		protected function onError(event:Event):void
		{
			testError(playerHelper.lastError);
		}
		
		/**
		 * @private
		 * 
		 * Event handler called when an error was encountered.
		 */
		protected function onTimeout(event:Event):void
		{
			testTimeout(playerHelper.info);
		}

		/// Protected methods
		/**
		 * @private
		 * 
		 * Runs a test after a specifc interval. Very usefull when we need to wait 
		 * a specific interval before we do our assertions.
		 */
		protected function runAfterInterval(testClass:Object, interval:Number, passThroughData:Object, toRunOnComplete:Function, toRunOnTimeout:Function):void
		{
			var timer:Timer = new Timer(interval, 1);
			
			function onTimerComplete(event:TimerEvent, passThroughData:Object):void
			{
				toRunOnComplete(passThroughData);
				cleanUp();
			}
			
			function onTimerTimeout(passThroughData:Object):void
			{
				toRunOnTimeout(passThroughData);
				cleanUp();
			}
			
			function cleanUp():void
			{
				timer.stop();
				timer = null;
			}
			
			Async.handleEvent(testClass, timer, TimerEvent.TIMER_COMPLETE, onTimerComplete, timer.delay + 1000, passThroughData, onTimerTimeout);
			timer.start();
		}
		
		
		/**
		 * @private
		 * 
		 * We fail the test and provide the error message.
		 */
		protected function testError(error:MediaError):void
		{
			if (error != null)
			{
				fail("Media error (" + error.errorID + ") with message (" + error.detail + ")");
			}
			else
			{
				fail("Unknown media error.");
			}
		}
		
		/**
		 * @private
		 * 
		 * We fail the test on timeout.
		 */
		protected function testTimeout( passThroughData:Object):void
		{
			if (passThroughData != null && passThroughData.hasOwnProperty("expectedEvent") && passThroughData.hasOwnProperty("expectedEventType"))
			{
				fail("Expected event <" + passThroughData["expectedEvent"] + "> of type <" + passThroughData["expectedEventType"] + "> was not received.");
			}
			else
			{
				fail("Expected event was not received.");	
			}
		}

		/// Internals
		protected var playerHelper:MediaPlayerHelper = null;
		
		protected static const DEFAULT_TEST_LENGTH:Number = 15000; //15 sec
	}
}