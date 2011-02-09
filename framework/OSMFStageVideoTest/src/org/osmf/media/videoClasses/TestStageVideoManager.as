package org.osmf.media.videoClasses
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import org.osmf.mock.StageVideo;
	
	import org.flexunit.asserts.*;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.osmf.mock.Stage;
	import org.osmf.utils.OSMFSettings;
	
	public class TestStageVideoManager
	{
		private var mockStage:Stage;
		private var videoSurfaceManager:VideoSurfaceManager;		
		
		[Before]
		public function setUp():void
		{
			mockStage = new Stage();
			videoSurfaceManager = new VideoSurfaceManager();			
			videoSurfaceManager.registerStage(mockStage);
			VideoSurface.videoSurfaceManager = videoSurfaceManager;
		}
		
		[After]
		public function tearDown():void
		{
			mockStage = null;
			VideoSurface.videoSurfaceManager = null;
		}
		
		/**
		 * Tests the basic workflow. 
		 */ 
		[Test]
		public function testAddRemoveStageVideoAvailable():void
		{		
			var videoSurface:VideoSurface = new VideoSurface(true);
			videoSurface.width = 100;
			videoSurface.height = 100;	
			
			mockStage.addChild(videoSurface);
			
			assertNotNull(videoSurface.stageVideo);
			assertNull(videoSurface.video);
			
			assertTrue(videoSurface.info.stageVideoInUse);
			assertEquals("unavailable", videoSurface.info.renderStatus);
			
			videoSurface.stageVideo.renderStateSoftware();
			assertEquals("software", videoSurface.info.renderStatus);
			
			videoSurface.stageVideo.renderStateAccelerated();
			assertEquals("accelerated", videoSurface.info.renderStatus);
			
			videoSurface.stageVideo.renderStateUnavailable();
			assertEquals("unavailable", videoSurface.info.renderStatus);
			
			assertNull(videoSurface.stageVideo);
			assertNotNull(videoSurface.video);
			
			mockStage.removeChild(videoSurface);
			assertFalse(videoSurface.info.stageVideoInUse);
		}
		
		/**
		 * Tests a simple positioning workflow.
		 */ 
		[Test]
		public function testPositioning():void
		{
			var videoSurface:VideoSurface = new VideoSurface(true);
			videoSurface.x = 7;
			videoSurface.y = 13;
			
			videoSurface.width = 100;
			videoSurface.height = 100;
			
			var container:DisplayObjectContainer = new Sprite();
			container.x = 10;
			container.y = 20;
			
			container.addChild(videoSurface);
			
			mockStage.addChild(container);
			
			assertNotNull(videoSurface.stageVideo);
			
			assertEquals(17, (videoSurface.stageVideo as StageVideo).viewPort.x);
			assertEquals(33, (videoSurface.stageVideo as StageVideo).viewPort.y);
			assertEquals(7, videoSurface.x);
			assertEquals(13, videoSurface.y);
			
			videoSurface.stageVideo.renderStateUnavailable();
			assertEquals("unavailable", videoSurface.info.renderStatus);
			
			assertNull(videoSurface.stageVideo);
			assertNotNull(videoSurface.video);
			
			assertEquals(0, videoSurface.video.x);
			assertEquals(0, videoSurface.video.y);
			assertEquals(7, videoSurface.x);
			assertEquals(13, videoSurface.y);
		}
		
		[Test]
		public function testSerialWorkflow():void
		{			
			var videoSurface:VideoSurface = new VideoSurface(true);
			videoSurface.x = 7;
			videoSurface.y = 13;			
			videoSurface.width = 100;
			videoSurface.height = 100;
			
			mockStage.addChild(videoSurface);			
			
			assertNotNull(videoSurface.stageVideo);
			assertTrue(videoSurfaceManager.activeVideoSurfaces.hasOwnProperty(videoSurface));
		
			
			mockStage.removeChild(videoSurface);
			assertTrue(videoSurfaceManager.activeVideoSurfaces.hasOwnProperty(videoSurface));			
			assertNull(videoSurface.stageVideo);
			assertNull(videoSurface.video);
			
			var adSurface:VideoSurface = new VideoSurface(true);
			adSurface.x = 20;
			adSurface.y = 20;
			adSurface.width = 50;
			adSurface.height = 50;	
		
			assertNull(videoSurface.stageVideo);
			
			mockStage.addChild(adSurface);
			
			assertTrue(videoSurfaceManager.activeVideoSurfaces.hasOwnProperty(adSurface));
			assertNotNull(adSurface.stageVideo);
			
			mockStage.removeChild(adSurface);
			assertNull(adSurface.stageVideo);
			
			mockStage.addChild(videoSurface);	
			assertNotNull(videoSurface.stageVideo);
		}
		
		/**
		 * Multiple VideoSurfaces, multiple StageVideos
		 * ... some stageVideos become unavailable and a different stageVideo instance is being picked up
		 * 
		 */ 
		[Test]
		public function testCompositeWorkflow():void
		{
		}
		
		/**
		 * One StageVideo, multiple VideoSurfaces
		 * The same stageVideo gets repicked, whenever available 
		 */ 
		[Test]
		public function testNotEnoughStageVideoObjests():void
		{
		}
		
		
	}
}