package org.osmf.test.mast.media
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.mast.media.MASTProxyElement;
	import org.osmf.media.IURLResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.image.ImageElement;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.LoadState;
	import org.osmf.utils.FMSURL;
	import org.osmf.video.VideoElement;
	import org.osmf.events.LoadableStateChangeEvent;
	

	public class TestMASTProxyElement extends TestCase
	{
		public function testConstructor():void
		{
			// Should throw an exception because there is no resource
			try
			{
				new MASTProxyElement(new MediaElement());
				fail();
			}
			catch(error:IllegalOperationError)
			{	
			}
		}
		
		public function testSetWrappedElement():void
		{
			var proxyElement:MASTProxyElement = new MASTProxyElement();
			
			
			// Should not throw an exception
			try
			{
				proxyElement.wrappedElement = null;
			}
			catch(error:IllegalOperationError)
			{	
				fail();
			}
		}
	
		public function testWithNoMetadata():void
		{
			var resource:IURLResource = new URLResource(new FMSURL(REMOTE_STREAM));				
			var mediaElement:MediaElement = new MediaElement();
			mediaElement.resource = resource;
			
			try
			{
				new MASTProxyElement(mediaElement);
				fail();
			}
			catch(error:IllegalOperationError)
			{
				
			}
		}
		
		public function testWithMetadata():void
		{
			var mediaElement:VideoElement = new VideoElement();
			mediaElement.resource = createResourceWithMetadata();

			try
			{
				new MASTProxyElement(mediaElement);
			}
			catch(error:IllegalOperationError)
			{
				fail();
			}
		}
		
		public function testLoad():void
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
		}
					
		public function testLoadAndPlay():void
		{
			doLoadAndPlay();
			doLoadAndPlay(false);
		}

		public function testLoadFailure():void
		{
			var mediaElement:MediaElement = new VideoElement();
			var resource:IURLResource = new URLResource(new FMSURL(REMOTE_STREAM));				

			var kvFacet:KeyValueFacet = new KeyValueFacet(MASTProxyElement.MAST_METADATA_NAMESPACE);
			kvFacet.addValue(new ObjectIdentifier(MASTProxyElement.METADATA_KEY_URI), "http://foo.com/bogus/badfile.xml");
			resource.metadata.addFacet(kvFacet);

			mediaElement.resource = resource

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
			loadableTrait.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
			loadableTrait.load();
			
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					fail();
				}
				else if (event.newState == LoadState.LOAD_FAILED)
				{
					// expected
				}
				
			}
			
			
		}
		
		private function doLoadAndPlay(preroll:Boolean=true):void
		{
			var mediaElement:MediaElement = new VideoElement();
			mediaElement.resource = createResourceWithMetadata(preroll);

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

		private function createResourceWithMetadata(preroll:Boolean=true):IURLResource
		{
			var resource:IURLResource = new URLResource(new FMSURL(REMOTE_STREAM));				

			var kvFacet:KeyValueFacet = new KeyValueFacet(MASTProxyElement.MAST_METADATA_NAMESPACE);
			kvFacet.addValue(new ObjectIdentifier(MASTProxyElement.METADATA_KEY_URI), preroll ? MAST_URL_PREROLL : MAST_URL_POSTROLL);
			resource.metadata.addFacet(kvFacet);
			
			return resource;			
		}

		private static const MAST_URL_PREROLL:String = "http://mediapm.edgesuite.net/osmf/content/mast/mast_sample_onitemstart.xml";
		private static const MAST_URL_POSTROLL:String 		= "http://mediapm.edgesuite.net/osmf/content/mast/mast_sample_onitemend.xml";
		
		private static const REMOTE_STREAM:String = "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		
		
	}
}
