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