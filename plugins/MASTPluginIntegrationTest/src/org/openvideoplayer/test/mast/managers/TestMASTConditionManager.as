package org.openvideoplayer.test.mast.managers
{
	import flash.errors.*;
	import flash.events.*;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.mast.media.MASTProxyElement;
	import org.openvideoplayer.mast.model.*;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.ObjectIdentifier;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.utils.*;
	import org.openvideoplayer.video.VideoElement;

	

	public class TestMASTConditionManager extends TestCase
	{

		public function testCM():void
		{
			var mediaElement:MediaElement = new VideoElement();
			mediaElement.resource = createResourceWithMetadata();

			var proxyElement:MASTProxyElement = null;
			
			try
			{
				proxyElement = new MASTProxyElement(mediaElement);
			}
			catch(error:IllegalOperationError)
			{
				fail();
			}
			
			var loadableTrait:ILoadable = proxyElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			loadableTrait.load();
			
			var playableTrait:IPlayable = proxyElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			playableTrait.play();
			
		}
				
		private function createResourceWithMetadata():IURLResource
		{
			var resource:IURLResource = new URLResource(new FMSURL(REMOTE_STREAM));				

			var kvFacet:KeyValueFacet = new KeyValueFacet(MASTProxyElement.MAST_METADATA_NAMESPACE);
			kvFacet.addValue(new ObjectIdentifier(MASTProxyElement.METADATA_KEY_URI), MAST_URL_PROPERTIES);
			resource.metadata.addFacet(kvFacet);
			
			return resource;			
		}

		private static const MAST_URL_PROPERTIES:String = "http://mediapm.edgesuite.net/osmf/content/mast/mast_sample_properties.xml";
		
		private static const REMOTE_STREAM:String = "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		
	}
}