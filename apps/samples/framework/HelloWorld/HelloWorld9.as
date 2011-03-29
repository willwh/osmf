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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.engine.TextElement;
	import flash.utils.setTimeout;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.DurationElement;
	import org.osmf.elements.ParallelElement;
	import org.osmf.elements.SWFElement;
	import org.osmf.elements.SerialElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.layout.LayoutMode;
	import org.osmf.layout.LayoutTargetSprite;
	import org.osmf.layout.ScaleMode;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.net.MediaItem;
	import org.osmf.traits.AlternativeAudioTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TraitEventDispatcher;
	
	/**
	 * Another simple OSMF application, building on HelloWorld2.as.
	 * 
	 * Plays a video, then shows a SWF, then plays another video.
	 **/
	[SWF(backgroundColor="0xdedede", width=640, height=480)]
	public class HelloWorld9 extends Sprite
	{
		public function HelloWorld9()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
 			
 			// Create the container class that displays the media.
 			container = new MediaContainer();
			container.x = 0;
			container.y = 0;
			container.width = stage.stageWidth;
			container.height = stage.stageHeight;
			addChild(container);
			
			// Create some layout metadata from the MediaElement.  This will cause
			// it to be centered in the container, with no scaling of content.
			var layoutMetadata:LayoutMetadata = new LayoutMetadata();
			layoutMetadata.layoutMode = LayoutMode.NONE;
			layoutMetadata.scaleMode = ScaleMode.LETTERBOX;
			layoutMetadata.percentHeight = 100;
			layoutMetadata.percentWidth = 100;
			layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
			layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;

			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD));
			mediaElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layoutMetadata);
			container.addMediaElement(mediaElement);
			
			// Set the MediaElement on a MediaPlayer.  Because autoPlay
			// defaults to true, playback begins immediately.
			player = new MediaPlayer();
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChange);
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			player.addEventListener(AlternativeAudioEvent.STREAM_CHANGE, onAlternateAudioChange);
			player.addEventListener(AlternativeAudioEvent.NUM_ALTERNATIVE_AUDIO_CHANGE, onNumAlternativeAudioChange);

			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
		}
		
		private function scenario1():void
		{
			//hangs the browser
			setTimeout(doPlay, 0);	
			setTimeout(doChangeAlternativeIndexInTrait, 11900, 0);
			//setTimeout(doPause, 30000);
			//setTimeout(doPlay, 33000);
			//setTimeout(doSeek, 37000, 20);
			//setTimeout(doChangeAlternativeIndex, 30000, 1);
			//setTimeout(doChangeAlternativeIndexInTrait, 5000, 1);
		}
		
		private function doPlay():void
		{
			if (player.canPlay)
			{
				trace("[LBA] scenario play");
				player.play();
				
			}
		}
		private function doPause():void
		{
			if (player.canPause)
			{
				trace("[LBA] scenario pause");
				player.pause();
				
			}
		}
		private function doSeek(pos:Number):void
		{
			if (player.canSeekTo(pos))
			{
				trace("[LBA] scenario seek " + pos);
				player.seek(pos);
			
			}
		}
		private function doChangeAlternativeIndex(newIndex:Number):void
		{
			if (player.hasAlternativeAudio && player.numAlternativeAudio>newIndex && -1<=newIndex)
			{
				trace("[LBA] scenario LBA switch " + newIndex );
				player.changeAlternativeAudioIndexTo(newIndex);
			
			}
		}
		private function doChangeAlternativeIndexInTrait(newIndex:Number):void
		{
			if (player.media.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO) &&
					(player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).numAlternativeAudioStreams>newIndex && 
					-1<=newIndex)
			{
				(player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).changeTo(newIndex);
				trace("[LBA] scenario LBA switch [trait] " + newIndex );
			}

		}
		
		
		private function onPlayerStateChange(event:MediaPlayerStateChangeEvent):void
		{
			switch (event.state)
			{
				case MediaPlayerState.READY:
					if (start)
					{
						start = false;
						trace("[LBA] Alternative languages", player.hasAlternativeAudio ? "available" : " not available" );
						if (player.hasAlternativeAudio)
						{
							for (var index:int = 0; index < player.numAlternativeAudio; index++)
							{
								var item:MediaItem = player.getMediaItemForAlternativeAudioIndex(index);
								trace("[LBA] [", item.language, "]", item.label);
							}
							
						}
						
						scenario1();	
					}
					break;
				case MediaPlayerState.PLAYING:
					//bad workaround to start changing
					//setTimeout(doChangeAlternativeIndex, 25000, 0);
					break;
			}
		}
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			trace("[Error]", event.toString());	
		}
		
		private function onAlternateAudioChange(event:AlternativeAudioEvent):void
		{
			trace("[LBA] [Event]", event.toString());	
			trace("[LBA] event.streamChanging = "+ event.streamChanging);
			
			trace("[LBA] alternativeAudioStreamChanging = "+ player.alternativeAudioStreamChanging);
			trace("[LBA] alternate "+ player.currentAlternativeAudioIndex +"/" +(player.numAlternativeAudio-1));
			
			trace("[LBA] [trait] alternativeAudioStreamChanging ="+ (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).changingStream);
			trace("[LBA] [trait] alternate"+ (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).currentIndex 
					+"/" +((player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).numAlternativeAudioStreams-1));
			
		}
		
		private function onNumAlternativeAudioChange(event:AlternativeAudioEvent):void
		{
			trace("[LBA] [Event]", event.toString());	
			trace("[LBA] alternativeAudioStreamChanging = "+ player.alternativeAudioStreamChanging);
			trace("[LBA] alternate "+ player.currentAlternativeAudioIndex +"/" +(player.numAlternativeAudio-1));
			
			trace("[LBA] [trait] alternativeAudioStreamChanging ="+ (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).changingStream);
			trace("[LBA] [trait] alternate"+ (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).currentIndex 
				+"/" +((player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).numAlternativeAudioStreams-1));
			
		}
		
		private var audioChanged:Boolean = false;
		private var player:MediaPlayer;
		private var container:MediaContainer;
		private var start:Boolean = true;
		
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/sync_test/sync_test_lba.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a/1_media_av_2_alternate_a.f4m";
		
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_v_2_alternate_a/1_media_v_2_alternate_a.f4m";
		private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a/1_media_av_2_alternate_a.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_longer_alternate_a/1_media_av_2_longer_alternate_a.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_shorter_alternate_a/1_media_av_2_shorter_alternate_a.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a_diff_frag_and_seg_length/1_media_av_2_alternate_a_diff_frag_and_seg_length.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a_diff_fragment_length/1_media_av_2_alternate_a_diff_fragment_length.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a_diff_segment_length/1_media_av_2_alternate_a_diff_segment_length.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a_equal_seg_diff_alternate_frag_length/1_media_av_2_alternate_a_equal_seg_diff_alternate_frag_length.f4m";
		//private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a_diff_frag_and_seg_length_for_all_media/1_media_av_2_alternate_a_diff_frag_and_seg_length_for_all_media.f4m";
		
		//private static const F4M_LIVE:String = "http://10.131.237.104/live/events/latebind/events/_definst_/liveevent.f4m";
		//private static const F4M_LIVE:String = "http://catherine.corp.adobe.com/osmf/late_bindings_audio_sp3/demo_live.f4m";	
		private static const F4M_LIVE:String = "http://10.131.237.107/live/events/latebind/events/_definst_/liveevent.f4m";
	}
}
