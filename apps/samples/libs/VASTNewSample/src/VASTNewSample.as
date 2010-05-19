/*****************************************************
*  
*  Copyright 2010 Eyewonder, LLC.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Eyewonder, LLC.
*  Portions created by Eyewonder, LLC. are Copyright (C) 2010 
*  Eyewonder, LLC. A Limelight Networks Business. All Rights Reserved. 
*  
*****************************************************/
package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.events.SliderEvent;
	import org.osmf.layout.ScaleMode;
	import org.osmf.containers.MediaContainer;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.elements.ProxyElement;
	import org.osmf.events.LoaderEvent;
	import org.osmf.media.*
	import org.osmf.traits.LoadState;
	import org.osmf.traits.AudioTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.vast.loader.VASTLoadTrait;
	import org.osmf.vast.loader.VASTLoader;
	import org.osmf.vast.media.CompanionElement;
	import org.osmf.vast.media.VASTMediaGenerator;
	
	
	/**
	 * Sample OSMF Player
	 * 
	 * */
	
	public class VASTNewSample extends Sprite
	{
		public static const OVERLAY_DELAY:Number = 2;
		
		private var container:MediaContainer;
		private var contentResource:URLResource;
		private var videoElement:MediaElement;
		private var mediaPlayer:MediaPlayer;
		private var mediaFactory:MediaFactory;
		private var vastLoader:VASTLoader;
		private var vastLoadTrait:VASTLoadTrait;
		private var vastMediaGenerator:VASTMediaGenerator;
		private var playInMediaPlayer:MediaElement;
		private var mediaElementAudio:AudioTrait;
		
		public static const MAX_NUMBER_REDIRECTS:int 		= 5;
		
		public static const INVALID_VAST:String 						= "http://cdn1.eyewonder.com/200125/instream/osmf/invalid_vast.xml";
		public static const VAST_1_LINEAR_FLV:String 					= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_1_linear_flv.xml";
		public static const VAST_1_WRAPPER:String 						= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_1_wrapper.xml";
		public static const VAST_2_BROKEN_FLV:String 					= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_broken_flv.xml";
		public static const VAST_2_BROKEN_VPAID:String 					= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_broken_vpaid.xml";
		public static const VAST_2_ENDLESS_WRAPPER:String 				= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_endless_wrapper.xml";
		public static const VAST_2_LINEAR_FLV_NONLINEAR_VPAID:String 	= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_linear_flv_nonlinear_vpaid.xml";
		public static const VAST_2_LINEAR_VPAID:String 					= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_linear_vpaid.xml";
		public static const VAST_2_LINEAR_VPAID_TRACKING_TEST:String 	= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_linear_vpaid_tracking_test.xml";
		public static const VAST_2_NONLINEAR_VPAID:String 				= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_nonlinear_vpaid.xml";
		public static const VAST_2_WRAPPER:String 						= "http://cdn1.eyewonder.com/200125/instream/osmf/vast_2_wrapper.xml";
		
		public static const chosenFile:String = VAST_2_WRAPPER;	// Change me
		public static const chosenPlacement:String = VASTMediaGenerator.PLACEMENT_LINEAR;	// Change me
		
		public function VASTNewSample()
		{
			trace("Starting VASTNewSample Player");
			
			mute_btn.addEventListener(MouseEvent.CLICK, onMutePressed);
			
			mediaPlayer = new MediaPlayer();
			
			playBtn.visible = true;
			pauseBtn.visible = false;
			playBtn.buttonMode = true;
			pauseBtn.buttonMode = true;
			stopBtn.buttonMode = true;
			
			playBtn.addEventListener(MouseEvent.CLICK, onPlayClicked);
			pauseBtn.addEventListener(MouseEvent.CLICK, onPauseClicked);
			stopBtn.addEventListener(MouseEvent.CLICK, onStopClicked);
			fullscreenBtn.addEventListener(MouseEvent.CLICK, onFSClicked);
			volSlider.addEventListener(SliderEvent.CHANGE, onVolChanged);	
			volSlider.value = 2;
			
			//create an instance of the media container for the videoElement
			container = new MediaContainer();
			container.layoutMetadata.width = 640;
			container.layoutMetadata.height = 480;
			container.layoutMetadata.scaleMode = ScaleMode.NONE;
			addChild(container);			
			
			//create a new url resource including the path to a video as a parameter.
			var vastResource:URLResource = new URLResource(chosenFile);
			vastLoader = new VASTLoader(MAX_NUMBER_REDIRECTS);
			vastLoadTrait = new VASTLoadTrait(vastLoader, vastResource);
			vastLoader.addEventListener(LoaderEvent.LOAD_STATE_CHANGE, onVASTLoadStateChange);
			vastLoader.load(vastLoadTrait);
			
			
		}
		
		private function onVASTLoadStateChange(event:LoaderEvent):void
		{
			if(event.newState == LoadState.READY)
			{
				vastMediaGenerator = new VASTMediaGenerator();
				var vastElements:Vector.<MediaElement> = vastMediaGenerator.createMediaElements(vastLoadTrait.vastDocument, chosenPlacement);
			
				
				
				for each(var mediaElement:MediaElement in vastElements)
				{
					if(mediaElement is ProxyElement)
						playInMediaPlayer = mediaElement;
					if(mediaElement is CompanionElement)
						trace("Found Companion Element: " + mediaElement);
				}
				trace("VASTNewSample - " + playInMediaPlayer);
				if (playInMediaPlayer != null)
				{
					container.addMediaElement(playInMediaPlayer);
					mediaPlayer = new MediaPlayer();
					mediaPlayer.autoPlay = false;
					mediaPlayer.volume = (volSlider.value/10);
					mediaPlayer.media = playInMediaPlayer;
					mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				}
				else
					trace("MediaElement not found! Check tag and placement for errors!");
				
			}
		}
		
		private function onMutePressed(event:MouseEvent):void
		{
			trace("onMutePressed " + mediaPlayer.muted);
			/*
			//This is the first use case for muting the VAST/VPAID creative
			if(mediaPlayer.muted)
				mediaPlayer.muted = false;
			else
				mediaPlayer.muted = true;
			*/
			
			//This is the second use case for muting the VAST/VPAID creative
			if(mediaPlayer.volume != 0)
				mediaPlayer.volume	= 0;
			else
				mediaPlayer.volume = volSlider.value/10;
		}
	
	
		private function onPauseClicked(e:MouseEvent):void
		{
			mediaPlayer.pause();			
			pauseBtn.visible = false;
			playBtn.visible = true;
		}
		
		private function onStopClicked(e:MouseEvent):void
		{
			mediaPlayer.stop();
		}
		
	
		private function onPlayClicked(e:MouseEvent):void
		{
			trace("OSMF_Player.onPlayClicked " );
					
			mediaPlayer.play();			
			playBtn.visible = false;
			pauseBtn.visible = true;
		}
		
		private function onMediaError(e:MediaErrorEvent):void
		{
			trace("OSMF_Player.onMediaError - There is an error with the player or the specified media cannot be played ");
			//mediaPlayer.media = videoElement;
			//videoElement.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
		}
		
		private function onFSClicked(e:MouseEvent):void
		{
			switch(stage.displayState) 
			{
                case "normal":
                    stage.displayState = "fullScreen";
                    
 
                    break;
                case "fullScreen":
                default:
                    stage.displayState = "normal";

                    break;
            }

		}
		
		private function onVolChanged(e:SliderEvent):void
		{
			
			
			var vol:Number = (e.currentTarget.value/10);
			//mediaPlayer.volume = vol;
			trace("Slider Volume Changed " + vol );
			mediaElementAudio = playInMediaPlayer.getTrait(MediaTraitType.AUDIO) as AudioTrait;
			mediaElementAudio.volume = vol;
			
		}
		
	}
		
}
