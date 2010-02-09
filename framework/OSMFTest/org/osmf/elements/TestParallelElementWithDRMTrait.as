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
package org.osmf.elements
{
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	
	import org.osmf.events.DRMEvent;
	import org.osmf.events.MediaError;
	import org.osmf.traits.DRMAuthenticationMethod;
	import org.osmf.traits.DRMState;
	import org.osmf.traits.DRMTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicDRMTrait;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicTimeTrait;

	public class TestParallelElementWithDRMTrait extends TestCase
	{
		public function testParallelProperties():void
		{
			var elem:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);
			var elem2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);
			
			var parallel:ParallelElement = new ParallelElement();
			
			Assert.assertFalse(parallel.getTrait(MediaTraitType.DRM) != null);
			
			parallel.addChild(elem);
			parallel.addChild(elem2);
			
			Assert.assertTrue(parallel.getTrait(MediaTraitType.DRM) != null);
			
			var elem1Drm:DynamicDRMTrait = elem.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;			
			var elem2Drm:DynamicDRMTrait = elem2.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;			
			var timeTrait1:DynamicTimeTrait = elem.getTrait(MediaTraitType.TIME) as  DynamicTimeTrait;		
			timeTrait1.duration = 1;	
			
			elem.doAddTrait(MediaTraitType.TIME, timeTrait1);
			
			Assert.assertTrue(parallel.getTrait(MediaTraitType.DRM) != null);
			
			var trait:DRMTrait = parallel.getTrait(MediaTraitType.DRM) as DRMTrait;
			
			Assert.assertEquals(trait.drmState, elem1Drm.drmState);
			Assert.assertEquals(trait.endDate, elem1Drm.endDate);
			Assert.assertEquals(trait.serverURL, elem1Drm.serverURL);
			Assert.assertEquals(trait.startDate, elem1Drm.startDate);
			Assert.assertEquals(trait.period, elem1Drm.period);
			
			//Moves the parallel element to the next child.							
			timeTrait1.currentTime = 1;
		
			Assert.assertTrue(parallel.getTrait(MediaTraitType.DRM) != null);
			
			trait = parallel.getTrait(MediaTraitType.DRM) as DRMTrait;
			
			Assert.assertEquals(trait.drmState, elem2Drm.drmState);
			Assert.assertEquals(trait.endDate, elem2Drm.endDate);
			Assert.assertEquals(trait.serverURL, elem2Drm.serverURL);
			Assert.assertEquals(trait.startDate, elem2Drm.startDate);
			Assert.assertEquals(trait.period, elem2Drm.period);
			Assert.assertEquals(trait.authenticationMethod,  "");
						
			var start1:Date = new Date(2);
			var end1:Date = new Date(5);
			var start2:Date = new Date(1);
			var end2:Date = new Date(4);
			
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATED,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATED,  new ByteArray(), new MediaError(1, "test"), start2, end2, 50, "server2", DRMAuthenticationMethod.ANONYMOUS);
			
			Assert.assertEquals(trait.drmState, DRMState.AUTHENTICATED);
			Assert.assertEquals(trait.endDate, end2);
			Assert.assertEquals(trait.startDate, start1);
			Assert.assertEquals(trait.serverURL, "server2");
			Assert.assertEquals(trait.period, 25);
			Assert.assertEquals(trait.authenticationMethod,  "Both");
			
			elem2Drm.invokeDrmStateChange(DRMState.INITIALIZING,  new ByteArray(), new MediaError(1, "test"), start2, end2, 50, "server2", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.authenticationMethod,  DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			
			
			//Mixup drmStates:
			elem1Drm.invokeDrmStateChange(DRMState.INITIALIZING,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.INITIALIZING);
			
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATING,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.INITIALIZING);
			
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATING,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.AUTHENTICATING);
			
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.AUTHENTICATION_NEEDED);
			
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATED,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.AUTHENTICATION_NEEDED);
			
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATED,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.AUTHENTICATED);
			
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATE_FAILED,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.AUTHENTICATE_FAILED);
			
			elem1Drm.invokeDrmStateChange(DRMState.INITIALIZING,  new ByteArray(), new MediaError(1, "test"), start1, end1, 25, "server1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			Assert.assertEquals(trait.drmState, DRMState.AUTHENTICATE_FAILED);
									
		}
		
		public function testParallelEvents():void
		{
			var elem:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.PLAY], null, null, true);
			var elem2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.PLAY], null, null, true);
			
			var parallel:ParallelElement = new ParallelElement();
					
			parallel.addChild(elem);
			parallel.addChild(elem2);
			
			Assert.assertTrue(parallel.getTrait(MediaTraitType.DRM) != null);
			
			var elem1Drm:DynamicDRMTrait = elem.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;			
			var elem2Drm:DynamicDRMTrait = elem2.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;			
			
			Assert.assertTrue(parallel.getTrait(MediaTraitType.DRM) != null);
			
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATED, token, null, new Date(), new Date(), 15, "SeverURL1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);		
			
			var trait:DRMTrait = parallel.getTrait(MediaTraitType.DRM) as DRMTrait;
			
			trait.addEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);
							
			Assert.assertEquals(trait.drmState, DRMState.INITIALIZING);
					
			var currentDRMTrait:DRMTrait = 	elem1Drm;
			
			var token:ByteArray = new ByteArray();		
			
			var events:Number = 0;		
					
					
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATE_FAILED, token, null, new Date(), new Date(), 50, "SeverURL1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATED, token, null, new Date(), new Date(), 50, "SeverURL1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATING, token, null, new Date(), new Date(), 50, "SeverURL1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, token, null, new Date(), new Date(), 50, "SeverURL1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem1Drm.invokeDrmStateChange(DRMState.INITIALIZING, token, null, new Date(), new Date(), 50, "SeverURL1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);		
			
			trait.removeEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);
			
			token = new ByteArray();
			
			
			currentDRMTrait = elem2Drm;
						
			
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATED, token, null, new Date(), new Date(), 50, "SeverURL1", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);		
			
			trait.addEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange2);
				
			elem2Drm.invokeDrmStateChange(DRMState.INITIALIZING, token, null, new Date(), new Date(), 25, "SeverURL2", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);	
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATE_FAILED, token, null, new Date(), new Date(), 25, "SeverURL2", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATED, token, null, new Date(), new Date(), 25, "SeverURL2", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATING, token, null, new Date(), new Date(), 25, "SeverURL2", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, token, null, new Date(), new Date(), 25, "SeverURL2", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
				
				
			parallel.removeChild(elem);
			
			assertEquals(trait.drmState, elem2Drm.drmState);
					
			function onDRMStateChange(event:DRMEvent):void
			{
				events++;
				assertEquals(event.token, token);
				assertEquals(event.period, 15);
				assertEquals(event.serverURL, "SeverURL1");
				assertEquals(trait.drmState, currentDRMTrait.drmState, event.drmState);	
			}
			
			function onDRMStateChange2(event:DRMEvent):void
			{
				events++;
				assertEquals(event.token, token);
				assertEquals(event.period, 25);
				assertEquals(event.serverURL, "SeverURL2");
				assertEquals(trait.drmState, currentDRMTrait.drmState, event.drmState);	
			}
			
			assertEquals(events, 10);
			
		}
		
		
		public function testAuthentication():void
		{
			var events:Number = 0;		
			var eventQueue:Array = [DRMState.AUTHENTICATED, DRMState.AUTHENTICATING];
			var elem:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);
			var elem2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);			
			var parallel:ParallelElement = new ParallelElement();
			var elem1Drm:DynamicDRMTrait = elem.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;			
			var elem2Drm:DynamicDRMTrait = elem2.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;		
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, null, null, new Date(), new Date(), 50, "SeverURL", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, null, null, new Date(), new Date(), 50, "SeverURL", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);	

			parallel.addChild(elem);
			parallel.addChild(elem2);
			
			var trait:DRMTrait = parallel.getTrait(MediaTraitType.DRM) as DRMTrait;	
			
			Assert.assertTrue(parallel.getTrait(MediaTraitType.DRM) != null);
					
			trait.addEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);
			
			trait.authenticate("ryan", "password");
			trait.authenticate("ryan2", "password2");
													
			function onDRMStateChange(event:DRMEvent):void
			{
				assertEquals(event.drmState, eventQueue.pop());
				events++;						
			}			
			
			assertEquals(events, 2);
						
		}
		
		
		public function testAuthenticationToken():void
		{
			var events:Number = 0;		
			var eventQueue:Array = [DRMState.AUTHENTICATED, DRMState.AUTHENTICATING];
			var elem:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);
			var elem2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);			
			var parallel:ParallelElement = new ParallelElement();
			var elem1Drm:DynamicDRMTrait = elem.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;			
			var elem2Drm:DynamicDRMTrait = elem2.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;		
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, null, null, new Date(), new Date(), 50, "SeverURL", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, null, null, new Date(), new Date(), 50, "SeverURL", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);	

			parallel.addChild(elem);
			parallel.addChild(elem2);
			
			var trait:DRMTrait = parallel.getTrait(MediaTraitType.DRM) as DRMTrait;	
			
			Assert.assertTrue(parallel.getTrait(MediaTraitType.DRM) != null);
					
			trait.addEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);
			
			trait.authenticateWithToken(new ByteArray());
			trait.authenticateWithToken(new ByteArray());
													
			function onDRMStateChange(event:DRMEvent):void
			{
				assertEquals(event.drmState, eventQueue.pop());
				events++;						
			}			
			
			assertEquals(events, 2);
						
		}
		
		public function testAuthFailure():void
		{
			var events:Number = 0;		
			var eventQueue:Array = [DRMState.AUTHENTICATED, DRMState.AUTHENTICATING, DRMState.AUTHENTICATION_NEEDED, DRMState.AUTHENTICATE_FAILED, DRMState.AUTHENTICATING];
			var elem:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);
			var elem2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.DRM, MediaTraitType.TIME, MediaTraitType.PLAY], null, null, true);			
			var serial:SerialElement = new SerialElement();
			var elem1Drm:DynamicDRMTrait = elem.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;			
			var elem2Drm:DynamicDRMTrait = elem2.getTrait(MediaTraitType.DRM) as DynamicDRMTrait;		
			elem1Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, null, null, new Date(), new Date(), 50, "SeverURL", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);
			elem2Drm.invokeDrmStateChange(DRMState.AUTHENTICATION_NEEDED, null, null, new Date(), new Date(), 50, "SeverURL", DRMAuthenticationMethod.USERNAME_AND_PASSWORD);	

			serial.addChild(elem);
			serial.addChild(elem2);
			
			var trait:DRMTrait = serial.getTrait(MediaTraitType.DRM) as DRMTrait;	
			
			Assert.assertTrue(serial.getTrait(MediaTraitType.DRM) != null);
					
			trait.addEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);
			
			trait.authenticate();
			trait.authenticateWithToken(new ByteArray());
													
			function onDRMStateChange(event:DRMEvent):void
			{
				assertEquals(event.drmState, eventQueue.pop());
				events++;						
			}
			
			assertEquals( events, 2);
			
		}
		
		
		
		
	}
}