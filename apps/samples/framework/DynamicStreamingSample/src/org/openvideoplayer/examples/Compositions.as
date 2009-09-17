package org.openvideoplayer.examples
{
	import mx.collections.ArrayCollection;
	
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingItem;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingNetLoader;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingResource;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.video.VideoElement;
	
	public class Compositions extends ArrayCollection
	{
		// ------ TEST CONTENT ------
		// SMIL
		private static const SMIL_TEST1:String 		= "http://mediapm.edgesuite.net/ovp/content/demo/smil/elephants_dream.smil";
		private static const SMIL_TEST2:String		= "http://www.streamflashhd.com/video/train.smil";
		// NON-DYNAMIC PROGRESSIVE
		private static const PROGRESSIVE_FLV:String = "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		// NON-DYNAMIC STREAMING
		private static const STREAMING_F4V:String	= "rtmp://cp67126.edgefcs.net/ondemand/mp4:mediapm/osmf/content/test/sample1_700kbps.f4v";
	
		public function Compositions()
		{			
		}
				
		public function get comps():ArrayCollection
		{
			return new ArrayCollection([ createParallel(),
									  	 createSerial() ,
									  	 SMIL_TEST1,
									     SMIL_TEST2,
									  	 PROGRESSIVE_FLV,
									  	 STREAMING_F4V, 
									  	 new VideoElement(new DynamicStreamingNetLoader(), createDyn5()),
									  	 new VideoElement(new DynamicStreamingNetLoader(), createDyn3()),
									  	 new VideoElement(new DynamicStreamingNetLoader(), createDyn4()),
									  	 new VideoElement(new DynamicStreamingNetLoader(), createDyn1())]);		
		}
		
		private function createDyn1():DynamicStreamingResource
		{
			var resource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL('rtmp://cp67126.edgefcs.net/ondemand'));
			resource.addItem(new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_768x428_24.0fps_408kbps.mp4", 408000));
			resource.addItem(new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_768x428_24.0fps_608kbps.mp4", 908000));
			resource.addItem(new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1024x522_24.0fps_1308kbps.mp4", 1308000));
			resource.addItem(new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1280x720_24.0fps_1708kbps.mp4", 1708000));
			return resource;
		}
		
		private function createDyn2():DynamicStreamingResource
		{
			var resource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL('rtmp://cp60395.edgefcs.net/ondemand'));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Train_1000kbps_H.mp4", 1000000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Train_900kbps.mp4", 900000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Train_700kbps.mp4", 700000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Train_450kbps.mp4", 450000));
			return resource;
		}
		
		private function createDyn3():DynamicStreamingResource
		{      
			var resource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL('rtmp://cp60395.edgefcs.net/ondemand'));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Holly_Hunter_Final_Mix.mov16x9_3500H_29.970.mp4", 3500000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Holly_Hunter_Final_Mix.mov16x9_3000_29.970.mp4", 3000000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Holly_Hunter_Final_Mix.mov16x9_2200_29.970.mp4", 2200000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Holly_Hunter_Final_Mix.mov16x9_1400_29.970.mp4", 1500000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Holly_Hunter_Final_Mix.mov16x9_700_29.970.mp4", 700000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/Holly_Hunter_Final_Mix.mov16x9_450_29.970.mp4", 450000));
			return resource;
		}
		
		private function createDyn4():DynamicStreamingResource
		{      
			var resource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL('rtmp://cp60395.edgefcs.net/ondemand'));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/mlb_on_tbs_prores.mov16x9_3500H_29.970.mp4", 3500000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/mlb_on_tbs_prores.mov16x9_3200H_29.970.mp4", 3200000));
		    resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/mlb_on_tbs_prores.mov16x9_3000_29.970.mp4", 3000000));
		    resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/mlb_on_tbs_prores.mov16x9_2200_29.970.mp4", 2200000));
		    resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/mlb_on_tbs_prores.mov16x9_1400_29.970.mp4", 1400000));
		    resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/mlb_on_tbs_prores.mov16x9_700_29.970.mp4", 700000));
		    resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/mlb_on_tbs_prores.mov16x9_450_29.970.mp4", 450000));
			return resource;
		}
		
		private function createDyn5():DynamicStreamingResource
		{
			var resource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL('rtmp://cp60395.edgefcs.net/ondemand'));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/FW_FC3_022hd-720-inoutedit.mov16x9_3500H_29.970.mp4", 3500000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/FW_FC3_022HD-720-inoutedit.mov16x9_3000_23.976.mp4", 3000000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/FW_FC3_022HD-720-inoutedit.mov16x9_2200_23.976.mp4", 2200000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/FW_FC3_022HD-720-inoutedit.mov16x9_1400_23.976.mp4", 1500000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/FW_FC3_022HD-720-inoutedit.mov16x9_700_23.976.mp4", 700000));
			resource.addItem(new DynamicStreamingItem("mp4:videos/encoded2/FW_FC3_022HD-720-inoutedit.mov16x9_450_23.976.mp4", 450000));
			return 	resource;	
		}
			
		private function createParallel():MediaElement
		{
			var parallel:ParallelElement = new ParallelElement();
			parallel.addChild(new VideoElement(new DynamicStreamingNetLoader(), createDyn1()));			
			parallel.addChild(new VideoElement(new DynamicStreamingNetLoader(), createDyn5()));			
			return parallel;
		}
		
		private function createSerial():MediaElement
		{
			var serial:SerialElement = new SerialElement();
			serial.addChild(new VideoElement(new DynamicStreamingNetLoader(), createDyn1()));
			serial.addChild(new VideoElement(new DynamicStreamingNetLoader(), createDyn5()));
			return serial;
		}
		
	
	}
}