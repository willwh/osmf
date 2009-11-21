package org.osmf.proxies
{
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	
	import org.osmf.media.MediaElement;

	public class TestMediaElementLoadedContext extends TestCase
	{
		public function testGetter():void
		{
			var testElement:MediaElement = new MediaElement();
			
			var context:MediaElementLoadedContext = new MediaElementLoadedContext(testElement);
			
			Assert.assertEquals(context.element, testElement);
			
		}
		
	}
}