/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.model
{
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.events.NewMediaInfoEvent;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.IMediaResourceHandler;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.netmocker.MockNetLoader;
	import org.openvideoplayer.netmocker.TracingNetLoader;
	import org.openvideoplayer.plugin.PluginFactory;
	import org.openvideoplayer.video.VideoElement;
	
	[Bindable]
	public class Model extends EventDispatcher
	{
		public var descriptors:Array;
		public var mediaElement:MediaElement;
		public var mediaFactory:MediaFactory;
		public var pluginFactory:PluginFactory;
		public var mediaIds:Array;
		
		public static function getInstance():Model
		{
			if (_model == null)
			{
				_model = new Model();
			}
			return _model;
		}
		
		/**
		 * @private
		 **/
		public function Model()
		{
			initDescriptors();
			initMediaFactory();
			initPluginFactory();
		}
		
		public function mediaInfoIdExist(id:String):Boolean
		{
			if (id == null || id.length <= 0)
			{
				return false;
			}
			
			var exist:Boolean = false;
			for (var i:int = 0; i < mediaIds.length; i++)
			{
				if (id.toLowerCase() == (mediaIds[i] as String).toLowerCase())
				{
					exist = true;
					break;
				}
			}
			
			return exist;
		}
		
		public function addMediaInfo(mediaInfo:IMediaInfo):void
		{
			mediaIds.push(mediaInfo.id);
			mediaFactory.addMediaInfo(mediaInfo);
			dispatchEvent(new NewMediaInfoEvent(NewMediaInfoEvent.NEW_MEDIA_INFO, mediaInfo));
		}
		
		private function initDescriptors():void
		{
			descriptors = new Array();

			var netLoaders:Array = new Array();
			netLoaders.push
					( new LoaderDescriptor
									( "NetLoader"
									, NetLoader
									)
					);
			netLoaders.push
					( new LoaderDescriptor
									( "TracingNetLoader"
									, TracingNetLoader
									)
					);
			netLoaders.push
					( new LoaderDescriptor
									( "MockNetLoader"
									, MockNetLoader
									)
					);
					
			descriptors.push
					( new MediaElementDescriptor
									( "VideoElement"
									, VideoElement
									, true 			// requires a resource
									, netLoaders
									)
					);

			var imageLoaders:Array = new Array();
			imageLoaders.push
					( new LoaderDescriptor
									( "ImageLoader"
									, ImageLoader
									)
					);
					
			descriptors.push
					( new MediaElementDescriptor
									( "ImageElement"
									, ImageElement
									, true 			// requires a resource
									, imageLoaders
									)
					);

			descriptors.push
					( new MediaElementDescriptor
									( "AudioElement"
									, AudioElement
									, true 			// requires a resource
									, netLoaders
									)
					);

			descriptors.push
					( new MediaElementDescriptor
									( "ParallelElement"
									, ParallelElement
									, false			// no resource required
									)
					);

			descriptors.push
					( new MediaElementDescriptor
									( "SerialElement"
									, SerialElement
									, false			// no resource required
									)
					);
		}
		
		private function initMediaFactory():void
		{
			mediaIds = new Array();
			mediaFactory = new MediaFactory();
			var loader:ILoader = new NetLoader();
			
			mediaIds.push("Standard video element");
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "Standard video element"
					, loader as IMediaResourceHandler
					, VideoElement
					, [NetLoader]
					)
				);
		}
		
		private function initPluginFactory():void
		{
			pluginFactory = new PluginFactory(mediaFactory);
		}
		
		private static var _model:Model;
	}
}