package org.openvideoplayer.utils
{
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.video.VideoElement;
	
	public class CompositionMediaFactory
	{

		
		public function createCompositionElement(caseNumber:int):MediaElement
		{
			var compElement:MediaElement = new MediaElement();
			
			switch(caseNumber)
			{
				case 0:
					compElement = testCase0(compElement); 
					break;
				case 1:
					compElement = testCase1(compElement);
					break;
				case 2:
 					compElement = testCase2(compElement);                   
					break;
				case 3:
					compElement = testCase3(compElement);
					break;
				case 4:
					compElement = testCase4(compElement);
					break;					
				case 5:
					compElement = testCase5(compElement);
					break;														
				default:
					trace("default");
			}
			return compElement;
		}
		
		private function testCase0(comp:MediaElement):MediaElement
		{
				parallelElement = new ParallelElement();
				mediaElement1 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/ads/Amp%20Energy.flv"));
				mediaElement2 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/EvanAlmighty.flv"));
				parallelElement.addChild(mediaElement1);
				parallelElement.addChild(mediaElement2);
				
				comp = parallelElement as ParallelElement;
				return comp;
		}
		
		private function testCase1(comp:MediaElement):MediaElement
		{
				serialElement = new SerialElement();
				mediaElement1 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/ads/Amp%20Energy.flv"));
				mediaElement2 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/EvanAlmighty.flv"));
				serialElement.addChild(mediaElement1);
				serialElement.addChild(mediaElement2);
				comp = serialElement as SerialElement;
		
				return comp;
		}	
		
		private function testCase2(comp:MediaElement):MediaElement
		{
                serialElement = new SerialElement();
                parallelElement1 = new ParallelElement();
                mediaElement1 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/ads/Amp%20Energy.flv"));
                parallelElement1.addChild(mediaElement1);

                parallelElement2 = new ParallelElement();
                mediaElement2 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/EvanAlmighty.flv"));
                mediaElement3 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/HarryPotter5.flv"));
                parallelElement2.addChild(mediaElement2);
                parallelElement2.addChild(mediaElement3);
                
                serialElement.addChild(parallelElement1);
                serialElement.addChild(parallelElement2);
                
              	comp = serialElement as SerialElement;
		
				return comp;
		}	
		
		private function testCase3(comp:MediaElement):MediaElement
		{
			    serialElement = new SerialElement();
                parallelElement1 = new ParallelElement();
                mediaElement2 = new VideoElement(new NetLoader(), new URLResource("rtmp://flopside.corp.adobe.com/superBowl2008/Audi.flv"));
                mediaElement3 = new VideoElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/flv/HarryPotter5.flv"));
                parallelElement1.addChild(mediaElement2);
                parallelElement1.addChild(mediaElement3);
                
                parallelElement2 = new ParallelElement();
                mediaElement1 = new VideoElement(new NetLoader(), new URLResource("rtmp://flopside.corp.adobe.com/superBowl2008/Bridgestone - Night Driving.flv"));
                parallelElement2.addChild(mediaElement1);                
                
                serialElement.addChild(parallelElement1);
                serialElement.addChild(parallelElement2);
                
              	comp = serialElement as SerialElement;
		
				return comp;
		}	
		
		private function testCase4(comp:MediaElement):MediaElement
		{
			    serialElement = new SerialElement();
                parallelElement1 = new ParallelElement();
                mediaElement1 = new VideoElement(new NetLoader(), new URLResource("rtmp://flopside.corp.adobe.com/superBowl2008/Audi.flv"));
                mediaElement4 = new AudioElement(new NetLoader(), new URLResource("http://flipside.corp.adobe.com/test_assets/sounds/mp3/Batman_Superman_Adventures.mp3"));
                parallelElement1.addChild(mediaElement1);
                parallelElement1.addChild(mediaElement4);
                
                parallelElement2 = new ParallelElement();
                mediaElement3 = new VideoElement(new NetLoader(), new URLResource("rtmp://flopside.corp.adobe.com/superBowl2008/Bridgestone.flv"));
                parallelElement2.addChild(mediaElement3);                
                
                serialElement.addChild(parallelElement1);
                serialElement.addChild(parallelElement2);
                
              	comp = serialElement as SerialElement;
		
				return comp;
		}
				
		private function testCase5(comp:MediaElement):MediaElement
		{
			    serialElement = new SerialElement();
                parallelElement1 = new ParallelElement();
                mediaElement1 = new VideoElement(new NetLoader(), new URLResource("rtmp://flopside.corp.adobe.com/superBowl2008/Budlight - Accent.flv"));
                mediaElement4 = new AudioElement(new NetLoader(), new URLResource("rtmp://10.58.123.46/vod/mp3:Dole_Dole_Than"));
                parallelElement1.addChild(mediaElement1);
                parallelElement1.addChild(mediaElement4);
                
                parallelElement2 = new ParallelElement();
                mediaElement2 = new VideoElement(new NetLoader(), new URLResource("rtmp://flopside.corp.adobe.com/superBowl2008/Bridgestone.flv"));
                parallelElement2.addChild(mediaElement2);                
                
                serialElement.addChild(parallelElement1);
                serialElement.addChild(parallelElement2);
                
              	comp = serialElement as SerialElement;
		
				return comp;
		}						
								
					
		
		private var mediaElement1:VideoElement;
		private var mediaElement2:VideoElement;
		private var mediaElement3:VideoElement;
		private var mediaElement4:AudioElement;
		private var parallelElement:ParallelElement;
		private var serialElement:SerialElement;
		private var parallelElement1:ParallelElement;
		private var parallelElement2:ParallelElement;

	}
}