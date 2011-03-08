package org.osmf.media
{
	import org.flexunit.asserts.*;
	import org.osmf.media.MediaType;
	
	public class TestMediaType
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
		
		[Test]
		public function testMediaConstants():void
		{
			assertEquals(MediaType.VIDEO, "video");
			assertEquals(MediaType.AUDIO, "audio");
			assertEquals(MediaType.IMAGE, "image");
			assertEquals(MediaType.SWF, "swf");
		}
	}
}