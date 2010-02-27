/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.examples
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.display.ScaleMode;
	import org.osmf.elements.AudioElement;
	import org.osmf.elements.BeaconElement;
	import org.osmf.elements.DurationElement;
	import org.osmf.elements.F4MElement;
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.ParallelElement;
	import org.osmf.elements.SWFElement;
	import org.osmf.elements.SerialElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.LoadEvent;
	import org.osmf.examples.buffering.DualThresholdBufferingProxyElement;
	import org.osmf.examples.buffering.SynchronizedParallelElement;
	import org.osmf.examples.chromeless.ChromelessPlayerElement;
	import org.osmf.examples.loaderproxy.VideoProxyElement;
	import org.osmf.examples.posterframe.PosterFrameElement;
	import org.osmf.examples.posterframe.RTMPPosterFrameElement;
	import org.osmf.examples.seeking.UnseekableProxyElement;
	import org.osmf.examples.switchingproxy.SwitchingProxyElement;
	import org.osmf.examples.text.TextElement;
	import org.osmf.examples.traceproxy.TraceListenerProxyElement;
	import org.osmf.layout.LayoutMode;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.net.DynamicStreamingItem;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.NetLoader;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.net.rtmpstreaming.RTMPDynamicStreamingNetLoader;
	import org.osmf.traits.BufferTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	
	/**
	 * Central repository of all examples for this application.
	 **/
	public class AllExamples
	{
		/**
		 * All examples to be used in the player.
		 **/
		public static function get examples():Array
		{
			var examples:Array = [];
			var mediaElement:MediaElement = null;
			
			var timer:Timer = new Timer(1000);
			var timerHandler:Function;
			
			examples.push
				( new Example
					( 	"Progressive Video"
					, 	"Demonstrates playback of a progressive video using VideoElement and NetLoader."
				  	,  	function():MediaElement
				  	   	{
				  	    	return new VideoElement(new URLResource(REMOTE_PROGRESSIVE));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Streaming Video"
					, 	"Demonstrates playback of a streaming video using VideoElement and NetLoader."
				  	,  	function():MediaElement
				  	   	{
				  	   		return new VideoElement(new URLResource(REMOTE_STREAM));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Dynamic Streaming Video"
					, 	"Demonstrates the use of dynamic streaming.  The player will automatically switch between five variations of the same stream, each encoded at a different bitrate (from 408 Kbps to 1708 Kbps), based on the available bandwidth.  Note that the switching behavior can be modified via custom switching rules."
					, 	function():MediaElement
				  	   	{
							var dsResource:DynamicStreamingResource = new DynamicStreamingResource(REMOTE_MBR_STREAM_HOST);
							for (var i:int = 0; i < 5; i++)
							{
								dsResource.streamItems.push(MBR_STREAM_ITEMS[i]);
							}
							
				  	   		return new VideoElement(dsResource);
				  	   	}
					)
				);
				
			examples.push
				( new Example
					( 	"Streaming Video With Dual-Threshold Buffer"
					, 	"Demonstrates playback of a streaming video with a dual-threshold buffer.  The buffer starts small, but increases once we've buffered enough data to enable playback.  The larger buffer reduces the chance that a rebuffer will need to occur."
				  	,  	function():MediaElement
				  	   	{
				  	   		var videoElement:VideoElement = new VideoElement(new URLResource(REMOTE_STREAM));
				  	   		return new DualThresholdBufferingProxyElement(2, 15, videoElement);
				  	   	}
				  	)
				);


			examples.push
				( new Example
					( 	"Progressive Video With Dynamic Buffer"
					, 	"Demonstrates playback of a progressive video with a dynamic buffer.  The size of the buffer grows slowly as the video plays, then shrinks back down again."
				  	,  	function():MediaElement
				  	   	{
							var videoElement:VideoElement = new VideoElement(new URLResource(REMOTE_PROGRESSIVE));

							// Trigger the timer every second.
				  	   		timer.delay = 1000;
				  	   		timer.repeatCount = 20;
				  	   		timer.addEventListener(TimerEvent.TIMER, timerHandler = onTimer);
				  	   		timer.start();
				  	   		
				  	   		function onTimer(event:TimerEvent):void
				  	   		{
				  	   			// Only adjust the buffer while we're playing.
				  	   			var playTrait:PlayTrait = videoElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
				  	   			var bufferTrait:BufferTrait = videoElement.getTrait(MediaTraitType.BUFFER) as BufferTrait;
				  	   			if (bufferTrait && !bufferTrait.buffering && playTrait && playTrait.playState == PlayState.PLAYING)
				  	   			{
				  	   				if (timer.currentCount <= 10)
				  	   				{
				  	   					bufferTrait.bufferTime += 1.0;
				  	   				}
				  	   				else
				  	   				{
				  	   					bufferTrait.bufferTime -= 1.0;
				  	   				}
				  	   			}
				  	   		}
				  	    	
				  	    	return videoElement;
				  	   	}
				  	, 	function():void
						{
							timer.stop();
							timer.reset();
							timer.removeEventListener
								( TimerEvent.TIMER
								, timerHandler
								);
						}
					)
				);

			examples.push
				( new Example
					( 	"Image"
					, 	"Demonstrates display of an image using ImageElement and ImageLoader."
				  	,  	function():MediaElement
				  	   	{
							return new ImageElement(new URLResource(REMOTE_IMAGE));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"SWF"
					, 	"Demonstrates display of a SWF using SWFElement and SWFLoader."
				  	,  	function():MediaElement
				  	   	{
							return new SWFElement(new URLResource(REMOTE_SWF));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Progressive Audio"
					, 	"Demonstrates playback of a progressive audio file using AudioElement and SoundLoader."
				  	,  	function():MediaElement
				  	   	{
							return new AudioElement(new URLResource(REMOTE_MP3));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Streaming Audio"
					, 	"Demonstrates playback of a streaming audio file using AudioElement and NetLoader."
				  	,  	function():MediaElement
				  	   	{
							return new AudioElement(new URLResource(REMOTE_AUDIO_STREAM));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Invalid Progressive Video"
					, 	"Demonstrates load failures and error handling for a progressive video with an invalid URL."
				  	,  	function():MediaElement
				  	   	{
							return new VideoElement(new URLResource(REMOTE_INVALID_PROGRESSIVE));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Invalid Streaming Video"
					, 	"Demonstrates load failures and error handling for a streaming video with an invalid URL."
				  	,  	function():MediaElement
				  	   	{
							return new VideoElement(new URLResource(REMOTE_INVALID_STREAM));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Invalid Image"
					, 	"Demonstrates load failures and error handling for an image with an invalid URL."
				  	,  	function():MediaElement
				  	   	{
							return new ImageElement(new URLResource(REMOTE_INVALID_IMAGE));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Invalid Progressive Audio"
					, 	"Demonstrates load failures and error handling for a progressive audio file with an invalid URL."
				  	,  	function():MediaElement
				  	   	{
							return new AudioElement(new URLResource(REMOTE_INVALID_MP3));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Invalid Streaming Audio"
					, 	"Demonstrates load failures and error handling for a streaming audio file with an invalid URL."
				  	,  	function():MediaElement
				  	   	{
							return new AudioElement(new URLResource(REMOTE_INVALID_STREAM));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Serial Composition"
					, 	"Demonstrates playback of a SerialElement that contains two videos (one progressive, one streaming), using the default layout settings.  Note that the duration of the second video is not incorporated into the SerialElement until its playback begins (because we don't know the duration until it is loaded)."
				  	,  	function():MediaElement
				  	   	{
							var serialElement:SerialElement = new SerialElement();
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_PROGRESSIVE)));
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_STREAM)));
							return serialElement; 
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Serial Composition (Preloaded)"
					, 	"Demonstrates playback of a SerialElement that contains two videos (one progressive, one streaming), where each video is loaded up front, enabling a quicker transition from one to the other."
				  	,  	function():MediaElement
				  	   	{
				  	   		function preload(mediaElement:MediaElement):void
				  	   		{
								var loadTrait:LoadTrait = videoElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
								loadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
								loadTrait.load();
								
								function onLoadStateChange(event:LoadEvent):void
								{
									if (event.loadState == LoadState.READY)
									{
										loadTrait.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
										
										var playTrait:PlayTrait = mediaElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
										playTrait.play();
										playTrait.pause();
									}
								}
				  	   		}
				  	   		
							var serialElement:SerialElement = new SerialElement();
							var videoElement:VideoElement = new VideoElement(new URLResource(REMOTE_PROGRESSIVE));
							preload(videoElement);
							serialElement.addChild(videoElement);
							videoElement = new VideoElement(new URLResource(REMOTE_STREAM));
							preload(videoElement);
							serialElement.addChild(videoElement);
							return serialElement;
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Parallel Composition (Default Layout)"
					, 	"Demonstrates playback of a ParallelElement that contains two videos (one progressive, one streaming), using the default layout settings.  Note that only one video is shown.  This is because both videos use the default layout settings, and thus overlap each other."
				  	,  	function():MediaElement
				  	   	{
							var parallelElement:ParallelElement = new ParallelElement();
							parallelElement.addChild(new VideoElement(new URLResource(REMOTE_PROGRESSIVE)));
							parallelElement.addChild(new VideoElement(new URLResource(REMOTE_STREAM)));
							return parallelElement;
				  	   	}
				  	)
				);

			
			examples.push
				( new Example
					( 	"Parallel Composition (Adjacent)"
					, 	"Demonstrates playback of a ParallelElement that contains two videos (one progressive, one streaming), with the videos laid out adjacently."
				  	,  	function():MediaElement
				  	   	{
							var parallelElement:ParallelElement = new ParallelElement();
							var layout:LayoutRendererProperties = new LayoutRendererProperties(parallelElement);
							layout.layoutMode = LayoutMode.HORIZONTAL;
							layout.width = 640
							layout.height = 352;
							
							var mediaElement1:MediaElement = new VideoElement(new URLResource(REMOTE_PROGRESSIVE));
							layout = new LayoutRendererProperties(mediaElement1);
							layout.percentWidth = 50;
							layout.percentHeight = 50;
							layout.scaleMode = ScaleMode.LETTERBOX;
							parallelElement.addChild(mediaElement1);
							
							var mediaElement2:MediaElement = new VideoElement(new URLResource(REMOTE_STREAM));
							layout = new LayoutRendererProperties(mediaElement2);
							layout.percentWidth = 50;
							layout.percentHeight = 50;
							layout.scaleMode = ScaleMode.LETTERBOX;
							parallelElement.addChild(mediaElement2);
							
							return parallelElement;
				  	   	} 
				  	)
				);
				
			examples.push
				( new Example
					( 	"Synchronized Parallel Composition"
					, 	"Demonstrates playback of a ParallelElement that contains the same streaming video twice, where both videos get paused when one of them is in a buffering state."
				  	,  	function():MediaElement
				  	   	{
							var parallelElement:SynchronizedParallelElement = new SynchronizedParallelElement();
							var layout:LayoutRendererProperties = new LayoutRendererProperties(parallelElement);
							layout.layoutMode = LayoutMode.HORIZONTAL;
							layout.width = 640
							layout.height = 352;
							
							var mediaElement1:MediaElement = new VideoElement(new URLResource(REMOTE_STREAM));
							layout = new LayoutRendererProperties(mediaElement1);
							layout.percentWidth = 50;
							layout.percentHeight = 50;
							layout.scaleMode = ScaleMode.LETTERBOX;
							parallelElement.addChild(mediaElement1);
							
							var mediaElement2:MediaElement = new VideoElement(new URLResource(REMOTE_STREAM));
							layout = new LayoutRendererProperties(mediaElement2);
							layout.percentWidth = 50;
							layout.percentHeight = 50;
							layout.scaleMode = ScaleMode.LETTERBOX;
							parallelElement.addChild(mediaElement2);
							
							return parallelElement;
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Invalid Serial Composition"
				  	, 	"Demonstrates load failures and error handling for a SerialElement whose second element has an invalid URL."
				  	,  	function():MediaElement
				  	   	{
							var serialElement:SerialElement = new SerialElement();
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_PROGRESSIVE))); 
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_INVALID_STREAM)));
							return serialElement;
				  	   	} 
				  	)
				);

			/* This example requires a local video file to be present.  To run this,
			uncomment this section and set a valid path for LOCAL_PROGRESSIVE.
			
			examples.push
				( new Example
					( 	"Local Video"
				  	, 	"Demonstrates playback of a local video file."
				  	,  	function():MediaElement
				  	   	{
				  	   		return new VideoElement(new URLResource(LOCAL_PROGRESSIVE)));
				  	   	} 
				  	)
				);
			*/
			examples.push
				( new Example
					( 	"Poster Frame"
					, 	"Demonstrates the use of a SerialElement to present a poster frame prior to playback.  Note that we use a subclass of ImageElement which adds the IPlayable trait to ensure that we can play through the image."
				  	,  	function():MediaElement
				  	   	{
							var serialElement:SerialElement = new SerialElement();
							serialElement.addChild(new PosterFrameElement(new URLResource(REMOTE_IMAGE2)));
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_STREAM)));
							return serialElement; 
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"RTMP Poster Frame"
					, 	"Demonstrates the use of a SerialElement to present a poster frame prior to playback.  Note that we use a subclass of ImageElement which adds the IPlayable trait to ensure that we can play through the image."
				  	,  	function():MediaElement
				  	   	{
				  	   		var netLoader:NetLoader = new NetLoader();
				  	   		
							var serialElement:SerialElement = new SerialElement();
				  	   		serialElement.addChild(new RTMPPosterFrameElement(new StreamingURLResource(REMOTE_STREAM), 5, netLoader));
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_STREAM), netLoader));
							return serialElement; 
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Slideshow"
				  	, 	"Demonstrates the use of DurationElement to present a set of images in sequence."
				  	,  	function():MediaElement
				  	   	{
							var serialElement:SerialElement = new SerialElement();
							serialElement.addChild(new DurationElement(5, new ImageElement(new URLResource(REMOTE_SLIDESHOW_IMAGE1))));
							serialElement.addChild(new DurationElement(5, new ImageElement(new URLResource(REMOTE_SLIDESHOW_IMAGE2))));
							serialElement.addChild(new DurationElement(5, new ImageElement(new URLResource(REMOTE_SLIDESHOW_IMAGE3))));
							
							return serialElement;
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Text"
					, 	"Demonstrates a custom MediaElement that displays text."
				  	,  	function():MediaElement
				  	   	{
				  	   		return new TextElement("Hello world!"); 
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Captions"
				  	, 	"Demonstrates the use of DurationElement to present a set of text elements in sequence."
				  	,  	function():MediaElement
				  	   	{
							var serialElement:SerialElement = new SerialElement();
							serialElement.addChild(new DurationElement(3, new TextElement("War was Beginning.")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: What happen ?")));
							serialElement.addChild(new DurationElement(4, new TextElement("Mechanic: Somebody set up us the bomb.")));
							serialElement.addChild(new DurationElement(3, new TextElement("Operator: We get signal.")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: What !")));
							serialElement.addChild(new DurationElement(3, new TextElement("Operator: Main screen turn on.")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: It's you !!")));
							serialElement.addChild(new DurationElement(3, new TextElement("CATS: How are you gentlemen !!")));
							serialElement.addChild(new DurationElement(5, new TextElement("CATS: All your base are belong to us.")));
							serialElement.addChild(new DurationElement(5, new TextElement("CATS: You are on the way to destruction.")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: What you say !!")));
							serialElement.addChild(new DurationElement(4, new TextElement("CATS: You have no chance to survive make your time.")));
							serialElement.addChild(new DurationElement(3, new TextElement("CATS: Ha ha ha ha ...")));
							serialElement.addChild(new DurationElement(3, new TextElement("Operator: Captain !!")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: Take off every 'ZIG'!!")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: You know what you doing.")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: Move 'ZIG'.")));
							serialElement.addChild(new DurationElement(3, new TextElement("Captain: For great justice.")));
							
							return serialElement;
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Chromeless SWF (AS3)"
					, 	"Demonstrates playback of a chromeless, AS3 SWF.  The SWF exposes an API that a custom MediaElement uses to control the video."
				  	,  	function():MediaElement
				  	   	{
				  	   		return new ChromelessPlayerElement(new URLResource(CHROMELESS_SWF_AS3));
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Chromeless SWF (Flex)"
					, 	"Demonstrates playback of a chromeless, Flex-based SWF.  The SWF exposes an API that a custom MediaElement uses to control the video.  Note that the SWF also exposes some simple controls for playback (Play, Pause, Mute).  These buttons are included to demonstrate how the loaded SWF and the player can stay in sync."
				  	,  	function():MediaElement
				  	   	{
				  	   		return new ChromelessPlayerElement(new URLResource(CHROMELESS_SWF_FLEX));
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Video URL Changer"
					, 	"Demonstrates the use of a custom ProxyElement to perform preflight operations on a MediaElement in a non-invasive way.  In this example, the URL of the video is changed during the load operation, so that instead of playing a streaming video, we play a progressive video."
				  	,  	function():MediaElement
				  	   	{
				  	   		return new VideoProxyElement(new VideoElement(new URLResource(REMOTE_STREAM)));
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Unseekable ProxyElement (Streaming Video)"
					, 	"Demonstrates the use of a custom ProxyElement to prevent the user from seeking another MediaElement, in this case a progressive VideoElement."
					,	function():MediaElement
				  	   	{
				  	  		return new UnseekableProxyElement(new VideoElement(new URLResource(REMOTE_STREAM)));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Switching ProxyElement (Two Videos)"
					, 	"Demonstrates the use of a custom ProxyElement to provide a means to seamlessly switch between two MediaElements.  In this case, we switch from one video to another every five seconds."
					,	function():MediaElement
				  	   	{
				  	   		var firstElement:MediaElement = new VideoElement(new URLResource(REMOTE_STREAM));
				  	   		var secondElement:MediaElement = new VideoElement(new URLResource(REMOTE_PROGRESSIVE));
				  	  		return new SwitchingProxyElement(firstElement, secondElement, 5, 10);
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Proxy-based Tracing (Dynamic Streaming Video)"
					, 	"Demonstrates the use of a custom ListenerProxyElement to non-invasively listen in on the behavior of another MediaElement, in this case a VideoElement doing dynamic streaming.  All playback events are sent to the trace console."
					,	function():MediaElement
				  	   	{
							var dsResource:DynamicStreamingResource = new DynamicStreamingResource(REMOTE_MBR_STREAM_HOST);
							for (var i:int = 0; i < 5; i++)
							{
								dsResource.streamItems.push(MBR_STREAM_ITEMS[i]);
							}
				  	  		return new TraceListenerProxyElement(new VideoElement(dsResource));
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Proxy-based Tracing (SerialElement)"
					, 	"Demonstrates the use of a custom ListenerProxyElement to non-invasively listen in on the behavior of another MediaElement, in this case a SerialElement containing two VideoElements.  All playback events are sent to the trace console."
				  	,  	function():MediaElement
				  	   	{
							var serialElement:SerialElement = new SerialElement();
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_PROGRESSIVE))); 
							serialElement.addChild(new VideoElement(new URLResource(REMOTE_STREAM)));
				  	   		return new TraceListenerProxyElement(serialElement);
				  	   	}
				  	)
				);
			
			examples.push
				( new Example
					( 	"Dynamic Layouts"
					, 	"Demonstrates the use of the default OSMF layout renderer to dynamically change the spatial ordering of MediaElements within compositions."
				  	,  	function():MediaElement
				  	   	{
							var parallelElement:ParallelElement = new ParallelElement();
							
							var video1:VideoElement = new VideoElement(new URLResource(REMOTE_PROGRESSIVE));
							var video2:VideoElement = new VideoElement(new URLResource(REMOTE_STREAM)); 
							parallelElement.addChild(video1);
							parallelElement.addChild(video2);
				  	   		
				  	   		var layoutVideo1:LayoutRendererProperties = new LayoutRendererProperties(video1);
							layoutVideo1.percentWidth = 50;
							layoutVideo1.percentHeight = 50;
							
							var layoutVideo2:LayoutRendererProperties = new LayoutRendererProperties(video2);
							layoutVideo2.percentWidth = 50;
							layoutVideo2.percentHeight = 50;
							layoutVideo2.percentX = 50;
							layoutVideo2.percentY = 25;
							
							var layoutParallelElement:LayoutRendererProperties = new LayoutRendererProperties(parallelElement);
							layoutParallelElement.width = 640;
							layoutParallelElement.height = 358;
				  	   		
				  	   		var delta:int = 1;
							
							timer.delay = 20;
							timer.repeatCount = 0;
							timer.addEventListener
								( TimerEvent.TIMER
								, timerHandler = onTimer
								);
								
							function onTimer(event:Event):void
							{
								layoutVideo1.percentWidth += delta;
								layoutVideo1.percentHeight += delta;
								
								layoutVideo2.percentY += delta / 2;
									
								if 	(	layoutVideo1.percentWidth < 25
									||	layoutVideo1.percentWidth > 75
									)
								{
									delta = -delta;
								}
							}
								
							timer.start();
								  	   	
							return parallelElement;
						}
					,	function():void
						{
							timer.stop();
							timer.reset();
							timer.removeEventListener
								( TimerEvent.TIMER
								, timerHandler
								);
						}
					)
				);
				
			examples.push
				( new Example
					( 	"BeaconElement"
					, 	"Demonstrates the use of BeaconElement to fire tracking events.  Every few seconds, a \"ping\" is made.  If you run this example while sniffing HTTP traffic, you can see the requests being made."
				  	,  	function():MediaElement
				  	   	{
				  	   		var serialElement:SerialElement = new SerialElement();
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		serialElement.addChild(new DurationElement(5));
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		serialElement.addChild(new DurationElement(10));
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		serialElement.addChild(new DurationElement(2));
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		return serialElement; 
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"BeaconElement with a VideoElement"
					, 	"Demonstrates the use of BeaconElement to fire tracking events in parallel with a VideoElement."
				  	,  	function():MediaElement
				  	   	{
				  	   		var parallelElement:ParallelElement = new ParallelElement();
				  	   		parallelElement.addChild(new VideoElement(new URLResource(REMOTE_PROGRESSIVE)));
				  	   		var serialElement:SerialElement = new SerialElement();
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		serialElement.addChild(new DurationElement(5));
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		serialElement.addChild(new DurationElement(10));
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		serialElement.addChild(new DurationElement(2));
				  	   		serialElement.addChild(new BeaconElement(BEACON_URL + "?random=" + Math.random()));
				  	   		parallelElement.addChild(serialElement);
				  	   		return parallelElement; 
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Streaming Video As Subclip"
					, 	"Demonstrates playback of a subclip of a streaming video using metadata to specify the start and end times."
				  	,  	function():MediaElement
				  	   	{
				  	   		var resource:StreamingURLResource = new StreamingURLResource(REMOTE_STREAM);
				  	   		resource.clipStartTime = 10;
				  	   		resource.clipEndTime = 25;
				  	   		return new VideoElement(resource);
				  	   	}
				  	)
				);

			examples.push
				( new Example
					( 	"Serial Composition With Subclips"
					, 	"Demonstrates playback of a SerialElement that contains one video chopped up into several subclips, each separated by the 5 second display of an image."
				  	,  	function():MediaElement
				  	   	{
				  	   		var netLoader:NetLoader = new NetLoader();
				  	   		
							var serialElement:SerialElement = new SerialElement();

				  	   		var resource:StreamingURLResource = new StreamingURLResource(REMOTE_STREAM);
				  	   		resource.clipEndTime = 15;
				  	   		serialElement.addChild(new VideoElement(resource, netLoader));

							serialElement.addChild(new DurationElement(5, new ImageElement(new URLResource(REMOTE_SLIDESHOW_IMAGE1))));

				  	   		resource = new StreamingURLResource(REMOTE_STREAM);
							resource.clipStartTime = 15;
							resource.clipEndTime = 22;
				  	   		serialElement.addChild(new VideoElement(resource, netLoader));

							serialElement.addChild(new DurationElement(5, new ImageElement(new URLResource(REMOTE_SLIDESHOW_IMAGE2))));

				  	   		resource = new StreamingURLResource(REMOTE_STREAM);
							resource.clipStartTime = 22;
				  	   		serialElement.addChild(new VideoElement(resource, netLoader));
				  	   		
							return serialElement; 
				  	   	} 
				  	)
				);

			examples.push
				( new Example
					( 	"Serial Composition With Dynamic Streaming Subclips"
					, 	"Demonstrates playback of a SerialElement that contains one dynamic streaming video chopped up into several subclips, each separated by the 5 second display of an image."
				  	,  	function():MediaElement
				  	   	{
				  	   		var netLoader:NetLoader = new RTMPDynamicStreamingNetLoader();
				  	   		
							var serialElement:SerialElement = new SerialElement();

							var dsResource:DynamicStreamingResource = new DynamicStreamingResource(REMOTE_MBR_STREAM_HOST);
							for (var i:int = 0; i < 5; i++)
							{
								dsResource.streamItems.push(MBR_STREAM_ITEMS[i]);
							}
				  	   		dsResource.clipEndTime = 10;
				  	   		serialElement.addChild(new VideoElement(dsResource, netLoader));

							serialElement.addChild(new DurationElement(5, new ImageElement(new URLResource(REMOTE_SLIDESHOW_IMAGE1))));

							dsResource = new DynamicStreamingResource(REMOTE_MBR_STREAM_HOST);
							for (i = 0; i < 5; i++)
							{
								dsResource.streamItems.push(MBR_STREAM_ITEMS[i]);
							}
							dsResource.clipStartTime = 150;
							dsResource.clipEndTime = 172;
				  	   		serialElement.addChild(new VideoElement(dsResource, netLoader));

							serialElement.addChild(new DurationElement(5, new ImageElement(new URLResource(REMOTE_SLIDESHOW_IMAGE2))));

							dsResource = new DynamicStreamingResource(REMOTE_MBR_STREAM_HOST);
							for (i = 0; i < 5; i++)
							{
								dsResource.streamItems.push(MBR_STREAM_ITEMS[i]);
							}
							dsResource.clipStartTime = 640;
				  	   		serialElement.addChild(new VideoElement(dsResource, netLoader));
				  	   		
							return new TraceListenerProxyElement(serialElement); 
				  	   	} 
				  	)
				);
				
			examples.push
				( new Example
					( 	"DefaultDuration Serial"
					, 	"Demonstrates the defaultDuration feature on VideoElement, in a Serial Composition."
				  	,  	function():MediaElement
				  	   	{
				  	   		var resource:URLResource = new URLResource(REMOTE_PROGRESSIVE);
							var resource2:URLResource = new URLResource(REMOTE_PROGRESSIVE2);
							
							var serial:SerialElement = new SerialElement();
							
							var video1:VideoElement = new VideoElement(resource);
							video1.defaultDuration = 32;
							var video2:VideoElement = new VideoElement(resource2);
							video2.defaultDuration = 27;
														
							serial.addChild(video1);
							serial.addChild(video2);
																	
				  	   		return serial; 
				  	   	}
				  	)
				);
				
			examples.push
				( new Example
					( 	"Flash Media Manifest Progressive"
					, 	"Demonstrates the use of a Flash Media Manifest file (F4M) for a progressive video."
				  	,  	function():MediaElement
				  	   	{
				  	   		var elem:F4MElement = new F4MElement();
				  	   		elem.resource = new URLResource(REMOTE_MANIFEST);																
				  	   		return elem; 
				  	   	}
				  	)
				);	
						
			examples.push
				( new Example
					( 	"Flash Media Manifest Dynamic Streaming"
					, 	"Demonstrates the use of a Flash Media Manifest file (F4M) for dynamic streaming video."
				  	,  	function():MediaElement
				  	   	{
				  	   		var elem:F4MElement = new F4MElement();
				  	   		elem.resource = new URLResource(REMOTE_MBR_MANIFEST);																
				  	   		return elem; 
				  	   	}
				  	)
				);	
							
			/* TODO: Uncomment this once we have the VAST library integrated
			   with the build system.
			examples.push
				( new Example
					( 	"VASTImpressionProxyElement"
					, 	"Demonstrates the use of VASTImpressionProxyElement to record a video impression in accordance with IAB guidelines.  The IAB dictates than an impression should be recorded after the video has finished its initial buffering.  We use a custom ProxyElement that sets the VideoElement's buffer time to a large value, so that it's possible to verify that the impression isn't recorded immediately."
				  	,  	function():MediaElement
				  	   	{
				  	   		var urls:Vector.<VASTUrl> = new Vector.<VASTUrl>();
				  	   		urls.push(new VASTUrl(BEACON_URL + "?random=" + Math.random()));
				  	   		return new VASTImpressionProxyElement(urls, null, new BufferingProxyElement(20, new VideoElement(new URLResource(REMOTE_STREAM)))));
				  	   	}
				  	)
				);
			*/
				
			return examples;
		}
		
		private static const REMOTE_PROGRESSIVE:String 			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		private static const REMOTE_PROGRESSIVE2:String 		= "http://mediapm.edgesuite.net/strobe/content/test/elephants_dream_768x428_24_short.flv";
		private static const REMOTE_STREAM:String 				= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		private static const REMOTE_AUDIO_STREAM:String 		= "rtmp://cp67126.edgefcs.net/ondemand/mp3:mediapm/strobe/content/test/train_1500";
		private static const REMOTE_MBR_STREAM_HOST:String 		= "rtmp://cp67126.edgefcs.net/ondemand";
		private static const REMOTE_MP3:String 					= "http://mediapm.edgesuite.net/osmf/content/test/train_1500.mp3";
		private static const REMOTE_IMAGE:String 				= "http://mediapm.edgesuite.net/osmf/image/adobe-lq.png";
		private static const REMOTE_IMAGE2:String				= "http://mediapm.edgesuite.net/strobe/content/test/train.jpg";
		private static const REMOTE_SLIDESHOW_IMAGE1:String 	= "http://mediapm.edgesuite.net/osmf/image/flash_player_50x50.gif";
		private static const REMOTE_SLIDESHOW_IMAGE2:String 	= "http://mediapm.edgesuite.net/osmf/image/flash_cs3_48x45.jpg";
		private static const REMOTE_SLIDESHOW_IMAGE3:String 	= "http://mediapm.edgesuite.net/osmf/image/flex_48x45.gif";
		private static const REMOTE_SWF:String 					= "http://mediapm.edgesuite.net/osmf/swf/ReferenceSampleSWF.swf";
		private static const REMOTE_INVALID_PROGRESSIVE:String 	= "http://mediapm.edgesuite.net/strobe/content/test/fail.flv";
		private static const REMOTE_INVALID_STREAM:String 		= "rtmp://cp67126.fail.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		private static const REMOTE_INVALID_IMAGE:String 		= "http://mediapm.edgesuite.net/osmf/image/fail.png";
		private static const REMOTE_INVALID_MP3:String 			= "http://mediapm.edgesuite.net/osmf/content/test/fail.mp3";
		private static const LOCAL_PROGRESSIVE:String 			= "video.flv";
		private static const CHROMELESS_SWF_AS3:String			= "http://mediapm.edgesuite.net/osmf/swf/ChromelessPlayer.swf";
		private static const CHROMELESS_SWF_FLEX:String			= "http://mediapm.edgesuite.net/osmf/swf/ChromelessFlexPlayer.swf";
		private static const BEACON_URL:String					= "http://mediapm.edgesuite.net/osmf/image/adobe-lq.png";
		private static const REMOTE_MANIFEST:String				= "http://mediapm.edgesuite.net/osmf/content/test/manifest-files/progressive.f4m";
		private static const REMOTE_MBR_MANIFEST:String			= "http://mediapm.edgesuite.net/osmf/content/test/manifest-files/dynamic_Streaming.f4m";
		
		private static const MBR_STREAM_ITEMS:Array =
			[ new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_768x428_24.0fps_408kbps.mp4", 408, 768, 428)
			, new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_768x428_24.0fps_608kbps.mp4", 608, 768, 428)
			, new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1024x522_24.0fps_908kbps.mp4", 908, 1024, 522)
			, new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1024x522_24.0fps_1308kbps.mp4", 1308, 1024, 522)
			, new DynamicStreamingItem("mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1280x720_24.0fps_1708kbps.mp4", 1708, 1280, 720)
			];
	}
}