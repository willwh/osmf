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
package org.osmf.media
{
	import org.osmf.audio.AudioElement;
	import org.osmf.audio.SoundLoader;
	import org.osmf.image.ImageElement;
	import org.osmf.image.ImageLoader;
	import org.osmf.manifest.F4MLoader;
	import org.osmf.net.NetLoader;
	import org.osmf.net.dynamicstreaming.DynamicStreamingNetLoader;
	import org.osmf.net.httpstreaming.HTTPStreamingNetLoader;
	import org.osmf.proxies.LoadableProxyElement;
	import org.osmf.swf.SWFElement;
	import org.osmf.swf.SWFLoader;
	import org.osmf.video.VideoElement;
	
	/**
	 * Defines a default media factory.
	 * 
	 * The default media factory can construct media elements of
	 * the following types:
	 * 
	 *  - VideoElement, using either:
	 *  	- NetLoader (streaming or progressive)
	 * 		- DynamicStreamingNetLoader (MBR streaming)
	 * 		- HTTPStreamingNetLoader (HTTP streaming)
	 * 		- F4MLoader (Flash Media Manifest files)
	 *  - SoundElement, using either:
	 * 		- SoundLoader (progressive)
	 * 		- NetLoader (streaming)
	 * 	- ImageElement
	 * 	- SWFElement
	 */	
	public class DefaultMediaFactory extends MediaFactory
	{
		/**
		 * @inheritDoc
		 */		
		public function DefaultMediaFactory(handlerResolver:IMediaResourceHandlerResolver=null)
		{
			super(handlerResolver);
			
			init();
		}
		
		// Internals
		//
		
		private function init():void
		{
			var f4mLoader:F4MLoader = new F4MLoader(this);
			
			addMediaInfo     
				( new MediaInfo
					( "org.osmf.f4m"
					, f4mLoader
					, function():MediaElement
						{
							return new LoadableProxyElement(f4mLoader);
						}
					, MediaInfoType.STANDARD
					)
				);
				
			addMediaInfo     
				( new MediaInfo
					( "org.osmf.video.httpstreaming"
					, new HTTPStreamingNetLoader()
					, function():MediaElement
						{
							return new VideoElement(new HTTPStreamingNetLoader());
						}
					, MediaInfoType.STANDARD
					)
				);

			addMediaInfo            
				( new MediaInfo
					( "org.osmf.video.dynamicStreaming"
					, new DynamicStreamingNetLoader()
					, function():MediaElement
						{
							return new VideoElement(new DynamicStreamingNetLoader())
						}
					, MediaInfoType.STANDARD
					)
				);
			
			addMediaInfo
				( new MediaInfo
					( "org.omsf.video"
					, new NetLoader()
					, function():MediaElement
						{
							return new VideoElement(new NetLoader())
						}
					, MediaInfoType.STANDARD
					)
				);		
			
			addMediaInfo
				( new MediaInfo
					( "org.osmf.audio"
					, new SoundLoader()
					, function():MediaElement
						{
							return new AudioElement(new SoundLoader())
						}
					, MediaInfoType.STANDARD
					)
				);
				
			addMediaInfo
				( new MediaInfo
					( "org.osmf.audio.streaming"
					, new NetLoader()
					, function():MediaElement
						{
							return new AudioElement(new NetLoader())
						}
					, MediaInfoType.STANDARD
					)
				);
				
			addMediaInfo
				( new MediaInfo
					( "org.osmf.image"
					, new ImageLoader()
					, function():MediaElement
						{
							return new ImageElement(new ImageLoader())
						}
					, MediaInfoType.STANDARD
					)
				);
				
			addMediaInfo
				( new MediaInfo
					( "org.osmf.swf"
					, new SWFLoader()
					, function():MediaElement
						{
							return new SWFElement(new SWFLoader())
						}
					, MediaInfoType.STANDARD
					)
				);
		}
		
	}
}