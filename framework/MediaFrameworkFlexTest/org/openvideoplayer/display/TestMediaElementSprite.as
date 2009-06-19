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
package org.openvideoplayer.display
{
	import flash.display.DisplayObject;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.netmocker.MockNetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.video.VideoElement;

	public class TestMediaElementSprite extends TestCase
	{
		public function testView():void
		{
			var sprite:MediaElementSprite = new MediaElementSprite();
			var element:VideoElement = new VideoElement(new MockNetLoader(), new URLResource("http://example.com/"));
			var element2:VideoElement = new VideoElement(new MockNetLoader(), new URLResource("http://example.com/"));
			
			sprite.element = element;
			(element.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();	
			(element2.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();	
						
			var view:DisplayObject = (element.getTrait(MediaTraitType.VIEWABLE) as IViewable).view;
			var view2:DisplayObject = (element2.getTrait(MediaTraitType.VIEWABLE) as IViewable).view;
			
			var w:Number = 300;
			var h:Number = 400;
			sprite.setAvailableSize(w, h);
			
			assertEquals(w, view.width);
			assertEquals(h, view.height);
			
			w = 500;
			h = 900;
			sprite.setAvailableSize(w, h);
			
			assertEquals(w, view.width);
			assertEquals(h, view.height);	
			
			//Make sure the width and height are differrent than the available.
			view2.width = 80;
			view2.height = 80;
			
			sprite.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensions);
			
			var dimsChanged:Boolean = false;
			
			function onDimensions(event:DimensionChangeEvent):void
			{
				assertFalse(dimsChanged); //call only once
				assertEquals(event.newHeight, 40);
				assertEquals(event.newWidth, 40);
				dimsChanged = true;
			}
			
			sprite.element = element2;
			assertEquals(sprite.element, element2);
			
			//These don't take since the video class throws out the changes to width and height.			
			assertEquals(w, view2.width);
			assertEquals(h, view2.height);
			
			(element2.getTrait(MediaTraitType.SPATIAL) as SpatialTrait).setDimensions( 40, 40);
			
			assertTrue(dimsChanged);			
				
			sprite.element = null;
			
			//Ensure we don't fire again.	
			(element2.getTrait(MediaTraitType.SPATIAL) as SpatialTrait).setDimensions( 40, 40);		
		}
		
		
		
		
	}
}