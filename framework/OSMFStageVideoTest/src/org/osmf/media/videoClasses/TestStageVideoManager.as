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
		public function TestStageVideoManager()
		{
		}
		
		[Test]
		public function testAddRemoveStageVideoAvailable():void
		{
			var mockStage:Stage = new Stage();
			VideoSurface.videoSurfaceManager = new VideoSurfaceManager();
			VideoSurface.videoSurfaceManager.registerStage(mockStage);
			
			var videoSurface:VideoSurface = new VideoSurface(true);
			videoSurface.width = 100;
			videoSurface.height = 100;
			
			var container:DisplayObjectContainer = new Sprite();
			container.addChild(videoSurface);
			
			//mockStage.addChild(videoSurface);
			mockStage.addChild(container);
			
			assertNotNull(videoSurface.stageVideo);
			assertNull(videoSurface.video);
			assertEquals("available", videoSurface.info.stageVideoAvailability);
			assertEquals("unavailable", videoSurface.info.renderStatus);
			
			videoSurface.stageVideo.renderStateSoftware();
			assertEquals("software", videoSurface.info.renderStatus);
			
			videoSurface.stageVideo.renderStateAccelerated();
			assertEquals("accelerated", videoSurface.info.renderStatus);
	
			videoSurface.stageVideo.renderStateUnavailable();
			assertEquals("unavailable", videoSurface.info.renderStatus);

			assertNull(videoSurface.stageVideo);
			assertNotNull(videoSurface.video);
			
			mockStage.removeChild(container);
			assertEquals("", videoSurface.info.stageVideoAvailability);
		}
		
		[Test]
		public function testPositioning():void
		{
			var mockStage:Stage = new Stage();
			VideoSurface.videoSurfaceManager = new VideoSurfaceManager();
			VideoSurface.videoSurfaceManager.registerStage(mockStage);
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
//			assertEquals(0, (videoSurface.stageVideo as StageVideo).viewPort.x);
//			assertEquals(0, (videoSurface.stageVideo as StageVideo).viewPort.y);
			//UIImpersonator.addChild(videoSurface);
		}
		
		
	}
}