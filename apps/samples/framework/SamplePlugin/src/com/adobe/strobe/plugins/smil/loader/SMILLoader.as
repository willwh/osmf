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
			
			var url:String = urlResource.url.rawUrl;
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
			urlRequest = new URLRequest(smilResource.url.rawUrl);

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