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
package com.adobe.strobe.plugins.smil.loader
{
	import com.adobe.strobe.plugins.smil.parsing.SMILParser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.loaders.LoaderBase;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * This class contains all the logic for loading a SMIL document, and creating a 'loaded' MediaElement that 
	 * represents the hierarchical structure specified in the SMIL document.
	 */
	public class SMILLoader extends LoaderBase
	{
		/**
		 * Constructor
		 */
		public function SMILLoader()
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onURLLoadingComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onURLLoadingError);
		}
		
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			var urlResource:URLResource = resource as URLResource;
			if (urlResource == null || urlResource.url == null)
			{
				return false;
			}
			
			var url:String = urlResource.url;
			if (url.substr(url.length - 4, 4) == ".smi")
			{
				return true;
			}
			else
			{
				return false;
			}
			
		}

		override public function load(loadable:ILoadable):void
		{
			super.load(loadable);
			this.loadable = loadable;
			updateLoadable(loadable, LoadState.LOADING);
			
			var smilResource:URLResource = loadable.resource as URLResource;
			urlRequest = new URLRequest(smilResource.url);

			try
			{
				urlLoader.load(urlRequest);
			}
			catch (e:Error)
			{
				updateLoadable(loadable, LoadState.LOAD_FAILED);
			}
			
		}


		private function onURLLoadingComplete(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			var parser:SMILParser = new SMILParser();
			var mediaElement:MediaElement = parser.parse(xml);

			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					// The root element has been loaded successfully. Set *this* element as loaded as well
					// Send the Root element's loaded context as my own loaded context 
					var loadedContext:SMILLoadedContext = new SMILLoadedContext(mediaElement);
					trace("Root Element Loaded Successfully");
					updateLoadable(loadable, LoadState.LOADED, loadedContext);
				}
				else if (event.newState == LoadState.LOAD_FAILED)
				{
					trace("Root Element Loading Failed");
					updateLoadable(loadable, LoadState.LOAD_FAILED);
				}
			}


			if (mediaElement.hasTrait(MediaTraitType.LOADABLE))
			{
				mediaLoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				mediaLoadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
				mediaLoadable.load();
			}
		}

		private function onURLLoadingError(event:Event):void
		{
			updateLoadable(loadable, LoadState.LOAD_FAILED);
		}


		private var loadable:ILoadable;
		private var mediaLoadable:ILoadable;
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
	}
}