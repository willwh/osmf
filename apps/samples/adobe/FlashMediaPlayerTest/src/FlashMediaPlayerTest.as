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
package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openvideoplayer.display.MediaElementSprite;
	import org.openvideoplayer.display.MediaPlayerSprite;
	import org.openvideoplayer.display.ScalableSprite;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.IAudible;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPausible;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.video.VideoElement;
	
	[SWF(backgroundColor="0x000000")]
	public class FlashMediaPlayerTest extends Sprite
	{
				
		public function FlashMediaPlayerTest()
		{
			mediaPlayer = new MediaPlayerSprite();
			elementPlayer = new MediaElementSprite();
			
			mediaElementSpriteTest = new StrobeButton("Media Element Test", 0x4567AA); 
			mediaPlayerSpriteTest = new StrobeButton( "Media Player Test", 0x4567AA); 
			playButton = new StrobeButton("Play", 0x566577); 
			pauseButton = new StrobeButton("Pause", 0x566577); 
			muteButton = new StrobeButton("Mute",  0x566577); 
			loadButton = new StrobeButton("Load",  0x566577); 
			
			var spacing:Number = 15;
			
			mediaElementSpriteTest.x = 20;																				
			mediaPlayerSpriteTest.x = mediaElementSpriteTest.width + mediaElementSpriteTest.x + spacing;			
			playButton.x = mediaPlayerSpriteTest.x + mediaPlayerSpriteTest.width + spacing;
			pauseButton.x = playButton.x + playButton.width + spacing;
			muteButton.x = pauseButton.x + pauseButton.width + spacing;
			loadButton.x = muteButton.x + muteButton.width + spacing;
			
			loadButton.y = mediaPlayerSpriteTest.y = mediaElementSpriteTest.y = playButton.y = pauseButton.y = muteButton.y = 20;
			
			addChild(mediaPlayerSpriteTest);
			addChild(mediaElementSpriteTest);
			addChild(playButton);
			addChild(pauseButton);
			addChild(muteButton);
			addChild(loadButton);
			mediaPlayerSpriteTest.addEventListener(MouseEvent.CLICK, onMediaPlayerTest);
			mediaElementSpriteTest.addEventListener(MouseEvent.CLICK, onMediaElementTest);
			playButton.addEventListener(MouseEvent.CLICK, play);
			pauseButton.addEventListener(MouseEvent.CLICK, pause);
			muteButton.addEventListener(MouseEvent.CLICK, mute);
			loadButton.addEventListener(MouseEvent.CLICK, load);
						
			addEventListener(Event.ADDED_TO_STAGE, onStage);			
		}
		
		private function onMediaPlayerTest(event:Event):void
		{			
			testWrapper(mediaPlayer);
			mediaPlayer.element = createMediaElement();
		}
		
		private function onMediaElementTest(event:Event):void
		{			
			testWrapper(elementPlayer);
			elementPlayer.element = createMediaElement();
		}
		
		private function testWrapper(wrapper:ScalableSprite):void
		{
			if(currentSprite)
			{
				removeChild(currentSprite);
			}
			 
			wrapper.scaleMode = ScaleMode.LETTERBOX;
			addChildAt(wrapper, 0);			
			currentSprite = wrapper;
			currentSprite.setAvailableSize(stage.stageWidth, stage.stageHeight);
		}		
		
		private function createMediaElement():MediaElement
		{
			return new VideoElement(new NetLoader(), new URLResource("http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv"));
		}
		
		private function onStage(event:Event):void
		{			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		private function onResize(event:Event):void
		{	
			if (currentSprite)
			{			
				currentSprite.setAvailableSize(stage.stageWidth, stage.stageHeight);		
			}	
		}
		
		//MediaPlayer will autoload.
		private function load(event:MouseEvent):void
		{	
			if (currentSprite is MediaElementSprite)
			{
				if (elementPlayer.element.hasTrait(MediaTraitType.LOADABLE) && (elementPlayer.element.getTrait(MediaTraitType.LOADABLE) as ILoadable).loadState == LoadState.CONSTRUCTED)
				{
					(elementPlayer.element.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
				}
			}
		}
			
		private function pause(event:MouseEvent):void
		{	
			if (currentSprite is MediaPlayerSprite)
			{	
				if (mediaPlayer.mediaPlayer.pausible)
				{
					mediaPlayer.mediaPlayer.pause();
				}
			}
			else if (currentSprite is MediaElementSprite)
			{
				if (elementPlayer.element.hasTrait(MediaTraitType.PAUSIBLE))
				{
					(elementPlayer.element.getTrait(MediaTraitType.PAUSIBLE) as IPausible).pause();
				}
			}
		}
				
		private function play(event:MouseEvent):void
		{
			if (currentSprite is MediaPlayerSprite)
			{	
				if (mediaPlayer.mediaPlayer.playable)
				{
					mediaPlayer.mediaPlayer.play();
				}
			}
			else if (currentSprite is MediaElementSprite)
			{
				if (elementPlayer.element.hasTrait(MediaTraitType.PLAYABLE))
				{
					(elementPlayer.element.getTrait(MediaTraitType.PLAYABLE) as IPlayable).play();
				}
			}
		}
		
		private function mute(event:MouseEvent):void
		{
			if (currentSprite is MediaPlayerSprite)
			{	
				if (mediaPlayer.mediaPlayer.audible)
				{
					mediaPlayer.mediaPlayer.muted = !mediaPlayer.mediaPlayer.muted;
				}
			}
			else if (currentSprite is MediaElementSprite)
			{
				if (elementPlayer.element.hasTrait(MediaTraitType.AUDIBLE))
				{
					(elementPlayer.element.getTrait(MediaTraitType.AUDIBLE) as IAudible).muted = !(elementPlayer.element.getTrait(MediaTraitType.AUDIBLE) as IAudible).muted;
				}
			}
		}
				
		private var currentSprite:ScalableSprite;
		
		private var mediaPlayer:MediaPlayerSprite;
		private var elementPlayer:MediaElementSprite;
		
		private var mediaElementSpriteTest:StrobeButton;
		private var mediaPlayerSpriteTest:StrobeButton;
		
		private var playButton:StrobeButton;
		private var pauseButton:StrobeButton;
		private var muteButton:StrobeButton;
		private var loadButton:StrobeButton;
		
		
				
	}
}
