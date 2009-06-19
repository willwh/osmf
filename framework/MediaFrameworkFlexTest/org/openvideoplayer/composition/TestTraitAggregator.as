/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.composition
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.video.VideoElement;	

	public class TestTraitAggregator extends TestCase
	{
		public function testListenedChild():void
		{			
			var aggr:TraitAggregator = new TraitAggregator();
			var video:VideoElement = new VideoElement();
			aggr.listenedChild = video;
			
			assertEquals(aggr.listenedChild, video);			
		}

		public function testGetNextChildWithTrait():void
		{			
			var aggr:TraitAggregator = new TraitAggregator();
			var video1:VideoElement = new VideoElement(new NetLoader(), new URLResource(null));
			aggr.addChild(video1);
			var video2:VideoElement = new VideoElement(new NetLoader(), new URLResource(null));
			aggr.addChild(video2);
			var video3:VideoElement = new VideoElement(new NetLoader(), new URLResource(null));
			aggr.addChild(video3);
			
			assertEquals(aggr.getNextChildWithTrait(null, MediaTraitType.LOADABLE), video1);			
			assertEquals(aggr.getNextChildWithTrait(video1, MediaTraitType.LOADABLE), video2);
			assertEquals(aggr.getNextChildWithTrait(video2, MediaTraitType.LOADABLE), video3);
			assertEquals(aggr.getNextChildWithTrait(video3, MediaTraitType.LOADABLE), null);
		}
		
		public function testForEachChildTrait():void
		{			
			var aggr:TraitAggregator = new TraitAggregator();			
			var video:VideoElement = new VideoElement(new NetLoader(), new URLResource(null));
			var loadableTrait:ILoadable = video.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			
			aggr.addChild(video);
						
			var gotCallback:Boolean = false;
			function callback(trait:IMediaTrait):void
			{
				gotCallback = true;
				assertEquals(trait, loadableTrait)
			}			
			aggr.forEachChildTrait(callback, MediaTraitType.LOADABLE);
			
			assertTrue(gotCallback);
			
			aggr.removeChild(video);
			gotCallback = false;
			
			aggr.forEachChildTrait(callback, MediaTraitType.LOADABLE);
			
			assertFalse(gotCallback);	
								
		}
		
		public function testInvokeOnEachChildTrait():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video1:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			var video2:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test2.com/'));
			aggr.addChild(video1);
			aggr.addChild(video2);
			
			aggr.invokeOnEachChildTrait("load", [], MediaTraitType.LOADABLE);
			
			assertEquals( (video1.getTrait(MediaTraitType.LOADABLE) as ILoadable).loadState, LoadState.LOADED);
			assertEquals( (video2.getTrait(MediaTraitType.LOADABLE) as ILoadable).loadState, LoadState.LOADED);
			
			(video1.getTrait(MediaTraitType.LOADABLE) as ILoadable).unload();
			(video2.getTrait(MediaTraitType.LOADABLE) as ILoadable).unload();
			
			aggr.removeChild(video1);
			aggr.removeChild(video2);
			
			aggr.invokeOnEachChildTrait("load", [], MediaTraitType.LOADABLE);  //Should be a no-op
			
			assertEquals( (video1.getTrait(MediaTraitType.LOADABLE) as ILoadable).loadState, LoadState.CONSTRUCTED);
			assertEquals( (video2.getTrait(MediaTraitType.LOADABLE) as ILoadable).loadState, LoadState.CONSTRUCTED);			
		}
		
		public function testHasTrait():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video1:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			var video2:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			aggr.addChild(video1);
			aggr.addChild(video2);
			
			assertTrue(aggr.hasTrait(MediaTraitType.LOADABLE));
			
			aggr.removeChild(video1);
				
			assertTrue(aggr.hasTrait(MediaTraitType.LOADABLE));	
			
			aggr.removeChild(video2);
					
			assertFalse(aggr.hasTrait(MediaTraitType.LOADABLE));			
		}
		
		public function testGetNumTraits():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video1:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			var video2:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			
			assertEquals( aggr.getNumTraits(MediaTraitType.LOADABLE), 0);
			
			aggr.addChild(video1);
			aggr.addChild(video2);
			
			assertEquals(aggr.getNumTraits(MediaTraitType.LOADABLE), 2);
			
			aggr.removeChild(video1);
				
			assertEquals(aggr.getNumTraits(MediaTraitType.LOADABLE), 1);	
			
			aggr.removeChild(video2);
					
			assertEquals(aggr.getNumTraits(MediaTraitType.LOADABLE), 0);			
		}
		
		public function testGetChildIndex():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video1:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			var video2:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			
			assertEquals(aggr.getChildIndex(null), -1);
			assertEquals(aggr.getChildIndex(video1), -1);
			assertEquals(aggr.getChildIndex(video2), -1);
			
			aggr.addChild(video1);
			aggr.addChild(video2);
			
			assertEquals(aggr.getChildIndex(video1), 0);
			assertEquals(aggr.getChildIndex(video2), 1);
			
			aggr.removeChild(video1);
				
			assertEquals(aggr.getChildIndex(video1), -1);
			assertEquals(aggr.getChildIndex(video2), 0);
			
			aggr.removeChild(video2);
					
			assertEquals(aggr.getChildIndex(video1), -1);
			assertEquals(aggr.getChildIndex(video2), -1);
		}
		
		public function testAddChild():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			
			var loadableSeen:Boolean = false;
			var playableSeen:Boolean = false;
						
			function onTraitAggregated(event:TraitAggregatorEvent):void
			{
				if (event.traitType == MediaTraitType.LOADABLE)
				{
					loadableSeen = true;
				}
				if (event.traitType == MediaTraitType.PLAYABLE)
				{
					playableSeen = true;
				}
			}
			
			aggr.addEventListener(TraitAggregatorEvent.TRAIT_AGGREGATED, onTraitAggregated);
			
			aggr.addChild(video);
						
			assertTrue(loadableSeen);
			assertFalse(playableSeen);
			
			aggr.invokeOnEachChildTrait("load", [], MediaTraitType.LOADABLE);  //Should add the playable trait, among others.
			
			assertTrue(loadableSeen);
			assertTrue(playableSeen);
		}
		
		public function testAddChildAt():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			
			var loadableSeen:Boolean = false;
			var playableSeen:Boolean = false;
						
			function onTraitAggregated(event:TraitAggregatorEvent):void
			{
				if (event.traitType == MediaTraitType.LOADABLE)
				{
					loadableSeen = true;
				}
				if (event.traitType == MediaTraitType.PLAYABLE)
				{
					playableSeen = true;
				}
			}
			
			aggr.addEventListener(TraitAggregatorEvent.TRAIT_AGGREGATED, onTraitAggregated);
			
			aggr.addChildAt(video, 0);
			
			assertTrue(loadableSeen);
			assertFalse(playableSeen);
			
			aggr.invokeOnEachChildTrait("load", [], MediaTraitType.LOADABLE);  //Should add the playable trait, among others.
			
			assertTrue(loadableSeen);
			assertTrue(playableSeen);
			
			var video2:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/2'));
			
			aggr.addChildAt(video2, 0);
			
			assertEquals(aggr.getNextChildWithTrait(video2, MediaTraitType.LOADABLE), video);
		}
		
		public function testRemoveChild():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			
			var loadableSeen:Boolean = false;
			var playableSeen:Boolean = false;
						
			function onTraitAggregated(event:TraitAggregatorEvent):void
			{
				if (event.traitType == MediaTraitType.LOADABLE)
				{
					loadableSeen = true;
				}
				if (event.traitType == MediaTraitType.PLAYABLE)
				{
					playableSeen = true;
				}
			}
			
			aggr.addEventListener(TraitAggregatorEvent.TRAIT_UNAGGREGATED, onTraitAggregated);			
			aggr.addChild(video);									
			aggr.invokeOnEachChildTrait("load", [], MediaTraitType.LOADABLE);  //Should add the playable trait, among others.
									
			assertFalse(loadableSeen);
			assertFalse(playableSeen);		
			
			aggr.invokeOnEachChildTrait("unload", [], MediaTraitType.LOADABLE);	 ///should remove playable trait.
			
			assertFalse(loadableSeen);
			assertTrue(playableSeen);		
			
			//Should unaggregate all traits
			aggr.removeChild(video);
			
			assertTrue(loadableSeen);
			assertTrue(playableSeen);	
		}
		
		public function testRemoveChildAt():void
		{	
			var aggr:TraitAggregator = new TraitAggregator();			
			var video:VideoElement = new VideoElement(new NetLoader(), new URLResource('http://test.com/'));
			
			var loadableSeen:Boolean = false;
			var playableSeen:Boolean = false;
						
			function onTraitAggregated(event:TraitAggregatorEvent):void
			{
				if (event.traitType == MediaTraitType.LOADABLE)
				{
					loadableSeen = true;
				}
				if (event.traitType == MediaTraitType.PLAYABLE)
				{
					playableSeen = true;
				}
			}
			
			aggr.addEventListener(TraitAggregatorEvent.TRAIT_UNAGGREGATED, onTraitAggregated);			
			aggr.addChild(video);									
			aggr.invokeOnEachChildTrait("load", [], MediaTraitType.LOADABLE);  //Should add the playable trait, among others.
									
			assertFalse(loadableSeen);
			assertFalse(playableSeen);		
			
			aggr.invokeOnEachChildTrait("unload", [], MediaTraitType.LOADABLE);	 ///should remove playable trait.
			
			assertFalse(loadableSeen);
			assertTrue(playableSeen);		
			
			// Should unaggregate all traits
			aggr.removeChildAt(0);
			
			assertTrue(loadableSeen);
			assertTrue(playableSeen);
			
			try
			{
				aggr.removeChildAt(0);
				
				fail();
			}
			catch (e:RangeError)
			{
			}
		}
	}
}