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
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;

	public class TestMediaPlayerSprite extends TestCase
	{
		public function testMediaPlayer():void
		{
			var player:MediaPlayerSprite = new MediaPlayerSprite();
			var element:DynamicMediaElement = new DynamicMediaElement();
			var viewableTrait:ViewableTrait = new ViewableTrait();
			var spatialTrait:SpatialTrait = new SpatialTrait();
			spatialTrait.setDimensions(150,150);
			viewableTrait.view = new Sprite();
						
			Sprite(viewableTrait.view).graphics.beginFill(0);
			Sprite(viewableTrait.view).graphics.drawRect(0,0,100,100);
			
			player.element = element;
			
			element.doAddTrait(MediaTraitType.VIEWABLE, viewableTrait);
			element.doAddTrait(MediaTraitType.SPATIAL, spatialTrait);
			
			player.scaleMode = ScaleMode.NONE;
			
			player.setAvailableSize(300, 300);
			
			assertEquals( viewableTrait.view.width, viewableTrait.view.height, 150);
			
			player.scaleMode = ScaleMode.STRETCH;
			
			assertEquals( viewableTrait.view.width, viewableTrait.view.height, 300);
						
			player.setAvailableSize(500, 500);
			
			assertEquals( viewableTrait.view.width, viewableTrait.view.height, 500);
			
			player.scaleMode = ScaleMode.NONE;
			
			player.setAvailableSize(800, 800);
			spatialTrait.setDimensions(500,500);
			assertEquals( viewableTrait.view.width, viewableTrait.view.height, 500);
			
			var newDisplay:Sprite = new Sprite();
			newDisplay.graphics.beginFill(0);
			newDisplay.graphics.drawRect(0,0,100,100);
			viewableTrait.view = newDisplay;
			assertEquals( newDisplay, viewableTrait.view, player.view, player.mediaPlayer.view);
			
			//Sanity checks
			player.element = null;
			player.setAvailableSize(0,0);
			assertNull(player.element);
			assertEquals(player.width, player.height, 0);
		}
		
		
		
	}
}