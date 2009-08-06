package org.openvideoplayer.metadata
{
	import flexunit.framework.TestCase;

	public class TestMediaType extends TestCase
	{
		
		public function testMediaConstants():void
		{
			assertEquals( MediaType.VIDEO,"Video");
			assertEquals( MediaType.AUDIO,"Audio");
			assertEquals( MediaType.IMAGE,"Image");
			assertEquals( MediaType.SWF,"SWF");
		}
		
	}
}