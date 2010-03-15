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
	import org.osmf.elements.AudioElement;
	import org.osmf.elements.F4MElement;
	import org.osmf.elements.F4MLoader;
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.ImageLoader;
	import org.osmf.elements.SWFElement;
	import org.osmf.elements.SWFLoader;
	import org.osmf.elements.SoundLoader;
	import org.osmf.elements.VideoElement;
	import org.osmf.net.NetLoader;
	import org.osmf.net.dvr.DVRCastNetLoader;
	import org.osmf.net.rtmpstreaming.RTMPDynamicStreamingNetLoader;
	
	CONFIG::FLASH_10_1
	{
	import org.osmf.net.httpstreaming.HTTPStreamingNetLoader;
	}

	
	/**
	 * <p>Defines a default media factory.</p>
	 * <p/>
	 * <p>
         * The default media factory can construct media elements of
	 * the following types:
	 * 
	 * <ul>
	 * <li>
	 * VideoElement, using either:
	 * <ul>
	 * <li>
	 *   NetLoader (streaming or progressive)
	 * </li>
	 * <li>
	 * 	 RTMPDynamicStreamingNetLoader (MBR streaming)
	 * </li>
	 * <li>
	 * 	 HTTPStreamingNetLoader (HTTP streaming)
	 * </li>
	 * <li>
	 * 	 F4MLoader (Flash Media Manifest files)
	 * </li>
	 * </ul>
	 * </li>
	 * <li>
	 * SoundElement, using either:
	 * <ul>
	 * <li>
	 * 	 SoundLoader (progressive)
	 * </li>
	 * <li>
	 * 	 NetLoader (streaming)
	 * </li>
	 * </ul>
	 * </li>
	 * <li>
	 *  ImageElement
	 * </li>
	 * <li>
	 *  SWFElement
	 * </li>
	 * </ul>
	 * </p>
	 *   
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class DefaultMediaFactory extends MediaFactory
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function DefaultMediaFactory()
		{
			super();
			
			init();
		}
		
		// Internals
		//
		
		private function init():void
		{
			var f4mLoader:F4MLoader = new F4MLoader(this);
			addItem 
				( new MediaFactoryItem
					( "org.osmf.elements.f4m"
					, f4mLoader.canHandleResource
					, function():MediaElement
						{
							return new F4MElement(null, f4mLoader);
						}
					)
				);
			
			var dvrCastLoader:DVRCastNetLoader = new DVRCastNetLoader();
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.video.dvr.dvrcast"
					, dvrCastLoader.canHandleResource
					, function():MediaElement
						{
							return new VideoElement(null, dvrCastLoader);
						}
					)
				);
			
			CONFIG::FLASH_10_1
			{
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.video.httpstreaming"
					, new HTTPStreamingNetLoader().canHandleResource
					, function():MediaElement
						{
							return new VideoElement();
						}
					)
				);
			}
			
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.video.rtmpdynamicStreaming"
					, new RTMPDynamicStreamingNetLoader().canHandleResource
					, function():MediaElement
						{
							return new VideoElement()
						}
					)
				);
			
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.video"
					, new NetLoader().canHandleResource
					, function():MediaElement
						{
							return new VideoElement()
						}
					)
				);		
			
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.audio"
					, new SoundLoader().canHandleResource
					, function():MediaElement
						{
							return new AudioElement()
						}
					)
				);
			
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.audio.streaming"
					, new NetLoader().canHandleResource
					, function():MediaElement
						{
							return new AudioElement()
						}
					)
				);
			
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.image"
					, new ImageLoader().canHandleResource
					, function():MediaElement
						{
							return new ImageElement()
						}
					)
				);
				
			addItem
				( new MediaFactoryItem
					( "org.osmf.elements.swf"
					, new SWFLoader().canHandleResource
					, function():MediaElement
						{
							return new SWFElement()
						}
					)
				);
		}
	}
}