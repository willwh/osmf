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
package org.osmf.audio
{
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.TestMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.SimpleLoader;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;

	public class TestAudioElement extends TestMediaElement
	{
		override public function setUp():void
		{
			netFactory = new NetFactory();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
		}

		override protected function createMediaElement():MediaElement
		{
			return new AudioElement(netFactory.createNetLoader()); 
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}

		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource(new URL(TestConstants.STREAMING_AUDIO_FILE));
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			// Subclasses can override to specify the trait types which are
			// expected upon initialization.
			return [MediaTraitType.LOADABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			// Subclasses can override to specify the trait types which are
			// expected after a load.  Ignored if the MediaElement
			// lacks the ILoadable trait.
			return [ MediaTraitType.AUDIBLE
				   , MediaTraitType.BUFFERABLE
				   , MediaTraitType.LOADABLE
				   , MediaTraitType.PAUSABLE
				   , MediaTraitType.PLAYABLE
				   , MediaTraitType.SEEKABLE
				   , MediaTraitType.TEMPORAL
				   ];
		}
		
		public function testConstructor():void
		{
			new AudioElement(new NetLoader());
			new AudioElement(new SoundLoader());
			
			// Loader must be a NetLoader or a SoundLoader.
			try
			{
				new AudioElement(new SimpleLoader());
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}
		
		public function testDefaultDuration():void
		{
			var element:AudioElement = createMediaElement() as AudioElement;
			assertEquals(NaN, element.defaultDuration);
			
			element.defaultDuration = 100;
			assertEquals(100, element.defaultDuration);
			
			var temporal:ITemporal = element.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			assertNotNull(temporal);
			assertEquals(temporal.duration, 100);
			
			element.defaultDuration = NaN;
			assertEquals(NaN, element.defaultDuration);
			
			temporal = element.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			assertNull(temporal);
		}
		
		private var netFactory:NetFactory;
	}
}