package org.openvideoplayer
{
	import flexunit.framework.TestSuite;
	
	import org.openvideoplayer.test.mast.loader.TestMASTLoader;
	import org.openvideoplayer.test.mast.adapter.TestMASTAdapter;
	import org.openvideoplayer.test.mast.media.TestMASTProxyElement;
	import org.openvideoplayer.test.mast.managers.TestMASTConditionManager;
	import org.openvideoplayer.test.mast.TestMASTPluginInfo;
	import org.openvideoplayer.test.mast.parser.TestMASTParser;

	public class MASTPluginIntegrationTests extends TestSuite
	{
		public function MASTPluginIntegrationTests(param:Object=null)
		{
			super(param);
			
			addTestSuite(TestMASTLoader);
			addTestSuite(TestMASTAdapter);
			addTestSuite(TestMASTProxyElement);
			addTestSuite(TestMASTPluginInfo);
			addTestSuite(TestMASTParser);
			addTestSuite(TestMASTConditionManager);
		}
		
	}
}