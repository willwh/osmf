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
package org.osmf.display
{
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.media.MediaPlayer;
	import org.osmf.traits.*;
	import org.osmf.utils.DynamicMediaElement;

	public class TestMediaPlayerSprite extends TestCase
	{
		public function testMediaPlayerSprite():void
		{
			var player:MediaPlayerSprite = new MediaPlayerSprite();
			var media:DynamicMediaElement = new DynamicMediaElement();
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(new Sprite(), 150, 150);
						
			Sprite(displayObjectTrait.displayObject).graphics.beginFill(0);
			Sprite(displayObjectTrait.displayObject).graphics.drawRect(0,0,150,150);
			
			player.mediaElement = media;
			
			media.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			
			player.scaleMode = ScaleMode.NONE;
			
			player.width = 300;
			player.height = 300;
			
			assertEquals( displayObjectTrait.displayObject.width, displayObjectTrait.displayObject.height, 150);
			
			player.scaleMode = ScaleMode.STRETCH;
			
			assertEquals( displayObjectTrait.displayObject.width, displayObjectTrait.displayObject.height, 300);
						
			player.width = 500;
			player.height = 500;
			
			assertEquals( displayObjectTrait.displayObject.width, displayObjectTrait.displayObject.height, 500);
			
			player.scaleMode = ScaleMode.NONE;
						
			// Sanity checks
			player.mediaElement = null;
			player.width = 0;
			player.height = 0;
			assertNull(player.mediaElement);
			assertEquals(player.width, player.height, 0);
		}
		
		public function testMediaPlayer():void
		{
			var mediaPlayer:MediaPlayer = new MediaPlayer();
			var player:MediaPlayerSprite = new MediaPlayerSprite(mediaPlayer);
			var media:DynamicMediaElement = new DynamicMediaElement();
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(new Sprite(), 150, 150);
			
			assertEquals(mediaPlayer, player.mediaPlayer);
			
			mediaPlayer = new MediaPlayer();
			player.mediaPlayer = mediaPlayer;
			
			assertEquals(mediaPlayer, player.mediaPlayer);
		}
		
		public function testScaleMode():void
		{			
			var player:MediaPlayerSprite = new MediaPlayerSprite();
			var media:DynamicMediaElement = new DynamicMediaElement();
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(new Sprite(), 150, 150);
			
			assertEquals(ScaleMode.LETTERBOX, player.scaleMode);
			player.scaleMode = ScaleMode.NONE;
			assertEquals(player.scaleMode, ScaleMode.NONE);			
		}
		
	}
}