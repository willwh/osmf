package org.osmf.player.media
{
	import flash.utils.setTimeout;
	
	import flashx.textLayout.operations.PasteOperation;
	
	import flexunit.framework.Test;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.MediaType;
	import org.osmf.media.URLResource;
	import org.osmf.traits.AlternativeAudioTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TraitEventDispatcher;

	public class TestLateBindingAudio
	{		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		

		[Test(async, timeout="10000")]
		public function testLoader_1AV_2A():void
		{
			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD_1V_2A));
			
			player = new MediaPlayer();
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			player.bufferTime = 5;
			
			Async.handleEvent(this, player,
				MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
				onStateChange, 2000, this);
			function onStateChange(event:MediaPlayerStateChangeEvent, test:*):void
			{
				
				assertTrue(player.canPlay);
				assertTrue(player.hasAlternativeAudio, "No alternate audio present.");
				
				assertEquals(player.numAlternativeAudio, 2);
				assertEquals(player.currentAlternativeAudioIndex, -1);
				assertTrue(player.media.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO));			
				var trait:AlternativeAudioTrait = (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO)) as AlternativeAudioTrait;
				
				assertEquals(trait.currentIndex, -1);
				assertEquals(trait.numAlternativeAudioStreams, 2);
				
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).bitrate, "128");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).label, "label1");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).language, "language1");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).bitrate, "56");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).label, "label2");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).language, "language2");
				
			}
			
			Async.failOnEvent(this, player,
				MediaErrorEvent.MEDIA_ERROR, 6000, onError);
			function onError(event:MediaErrorEvent, test:*):void
			{
				fail(event.error.message + event.error.detail);
			}
			
		}
			
		
		[Test(async, timeout="10000")]
		public function testLoader_HDS_2A():void
		{
			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD_HDS_2A));
			
			player = new MediaPlayer();
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			player.bufferTime = 5;
			
			Async.handleEvent(this, player,
				MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
				onStateChange, 2000, this);
			function onStateChange(event:MediaPlayerStateChangeEvent, test:*):void
			{
				
				assertTrue(player.canPlay);
				assertTrue(player.hasAlternativeAudio, "No alternate audio present.");
				
				assertEquals(player.numAlternativeAudio, 2);
				assertEquals(player.currentAlternativeAudioIndex, -1);
				assertTrue(player.media.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO));			
				var trait:AlternativeAudioTrait = (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO)) as AlternativeAudioTrait;
				
				assertEquals(trait.currentIndex, -1);
				assertEquals(trait.numAlternativeAudioStreams, 2);
				
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).bitrate, "128");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).label, "audio1");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).language, "language1");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).bitrate, "128");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).label, "audio2");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).language, "language2");
				
			}
			
			Async.failOnEvent(this, player,
				MediaErrorEvent.MEDIA_ERROR, 6000, onError);
			function onError(event:MediaErrorEvent, test:*):void
			{
				fail(event.error.message + event.error.detail);
			}
			
		}
		
		
		[Test(async, timeout="10000")]
		public function testLoader_bootstrap_in_url():void
		{
			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD_BOOTSTRAP));
			
			player = new MediaPlayer();
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			player.bufferTime = 5;
			
			Async.handleEvent(this, player,
				MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
				onStateChange, 2000, this);
			function onStateChange(event:MediaPlayerStateChangeEvent, test:*):void
			{
				
				assertTrue(player.canPlay);
				assertTrue(player.hasAlternativeAudio, "No alternate audio present.");
				
				assertEquals(player.numAlternativeAudio, 2);
				assertEquals(player.currentAlternativeAudioIndex, -1);
				assertTrue(player.media.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO));			
				var trait:AlternativeAudioTrait = (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO)) as AlternativeAudioTrait;
				
				assertEquals(trait.currentIndex, -1);
				assertEquals(trait.numAlternativeAudioStreams, 2);
				
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).bitrate, "48");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).label, "audio1");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(0).language, "language1");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).bitrate, "128");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).label, "audio2");
				assertEquals(player.getMediaItemForAlternativeAudioIndex(1).language, "language2");
			
				
			}
			
			Async.failOnEvent(this, player,
				MediaErrorEvent.MEDIA_ERROR, 6000, onError);
			function onError(event:MediaErrorEvent, test:*):void
			{
				fail(event.error.message + event.error.detail);
			}
			
		}
		
		[Test(async, timeout="10000")]
		public function testLoader_rtmp_1A():void
		{
			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD_RTMP_1A));
			
			player = new MediaPlayer();
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			player.bufferTime = 5;
			
			Async.handleEvent(this, player,
				MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
				onStateChange, 2000, this);
			function onStateChange(event:MediaPlayerStateChangeEvent, test:*):void
			{
				
				//assertTrue(player.canPlay);
				assertFalse(player.hasAlternativeAudio, "No alternate audio present.");
				
				assertEquals(player.numAlternativeAudio, 0);
				assertFalse(player.media.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO));			
				
			}
			
			Async.failOnEvent(this, player,
				MediaErrorEvent.MEDIA_ERROR, 6000, onError);
			function onError(event:MediaErrorEvent, test:*):void
			{
				fail(event.error.message + event.error.detail);
			}
			
		}
		
		[Test(async, timeout="10000")]
		public function testLoader_HS_1A_WrongType():void
		{
			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD_WRONG_TYPE));
			
			player = new MediaPlayer();
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			player.bufferTime = 5;
			
			Async.handleEvent(this, player,
				MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
				onStateChange, 2000, this);
			function onStateChange(event:MediaPlayerStateChangeEvent, test:*):void
			{
				
				//assertTrue(player.canPlay);
				assertFalse(player.hasAlternativeAudio, "No alternate audio present.");
				
				assertEquals(player.numAlternativeAudio, 0);
				assertFalse(player.media.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO));			
				
			}
			
			Async.failOnEvent(this, player,
				MediaErrorEvent.MEDIA_ERROR, 6000, onError);
			function onError(event:MediaErrorEvent, test:*):void
			{
				fail(event.error.message + event.error.detail);
			}
			
		}
		
/*		[Test(async, timeout="100000")]
		public function testPlayFirstAudio():void
		{
			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD));
			
			player = new MediaPlayer();
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			
			
			Async.handleEvent(this, player,
				AlternativeAudioEvent.NUM_ALTERNATIVE_AUDIO_CHANGE, 
				onStreamChange, 6000, this);
			
			function onNumAlternativeAudioChange(event:AlternativeAudioEvent, test:*):void
			{
				assertEquals(player.numAlternativeAudio, 2);
				assertEquals((player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).numAlternativeAudioStreams, 2);
				
			}
			
			Async.handleEvent(this, player,
				AlternativeAudioEvent.STREAM_CHANGE, 
				onStreamChange, 7000, this);
			
			function onStreamChange(event:AlternativeAudioEvent, test:*):void
			{
				assertFalse(player.alternativeAudioStreamChanging);
			}
			
			Async.handleEvent(this, player,
				MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
				onStateChange, 8000, this);
			function onStateChange(event:MediaPlayerStateChangeEvent, test:*):void
			{
				
				if (player.canPlay)
				{
					assertTrue(player.hasAlternativeAudio, "No alternate audio present.");
					
					assertEquals(player.numAlternativeAudio, 2);
					assertEquals(player.currentAlternativeAudioIndex, -1);
					assertTrue(player.media.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO));			
					var trait:AlternativeAudioTrait = (player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO)) as AlternativeAudioTrait;
					
					assertEquals(trait.currentIndex, -1);
					assertEquals(trait.numAlternativeAudioStreams, 2);
					
					assertEquals(player.getMediaItemForAlternativeAudioIndex(0).bitrate, "48");
					assertEquals(player.getMediaItemForAlternativeAudioIndex(0).label, "label1");
					assertEquals(player.getMediaItemForAlternativeAudioIndex(0).language, "language1");
					assertEquals(player.getMediaItemForAlternativeAudioIndex(1).bitrate, "128");
					assertEquals(player.getMediaItemForAlternativeAudioIndex(1).label, "label2");
					assertEquals(player.getMediaItemForAlternativeAudioIndex(1).language, "language2");
					
					player.play();
				}
				if (player.state == MediaPlayerState.PLAYING)
				{
					player.changeAlternativeAudioIndexTo(1);
					//(player.media.getTrait(MediaTraitType.ALTERNATIVE_AUDIO) as AlternativeAudioTrait).changeTo(1);
					assertTrue(player.alternativeAudioStreamChanging);
				}
			}
			
			Async.failOnEvent(this, player,
				MediaErrorEvent.MEDIA_ERROR, 8000, onError);
			function onError(event:MediaErrorEvent, test:*):void
			{
				fail(event.error.message + event.error.detail);
			}
			
		}*/
		
		
		
		public var player:MediaPlayer;
		
		private static const F4M_VOD_1V_2A:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_alternate_a/1_media_av_2_alternate_a.f4m"; 
		
		private static const F4M_VOD_HDS_2A:String = "http://10.131.237.104/vod/late_binding_audio/parser_loader_assets/TC05_hds_2alt.f4m"; 
		private static const F4M_VOD_RTMP_1A:String = "http://10.131.237.104/vod/late_binding_audio/parser_loader_assets/TC20_rtmp_1alt.f4m"; 
		private static const F4M_VOD_BOOTSTRAP:String = "http://10.131.237.104/vod/late_binding_audio/parser_loader_assets/sim_live/liveevent.f4m"; 

		private static const F4M_VOD_WRONG_TYPE:String = "http://10.131.237.104/vod/late_binding_audio/parser_loader_assets/TC15_HS_base_media_1_alternate_track_type_video.f4m"; 


	}
}