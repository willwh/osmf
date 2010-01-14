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
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	
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
		
		override public function canHandleResource(resource:MediaResourceBase):Boolean
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

		override public function load(loadTrait:LoadTrait):void
		{
			super.load(loadTrait);
			this.loadTrait = loadTrait;
			updateLoadTrait(loadTrait, LoadState.LOADING);
			
			var smilResource:URLResource = loadTrait.resource as URLResource;
			urlRequest = new URLRequest(smilResource.url.rawUrl);

			try
			{
				urlLoader.load(urlRequest);
			}
			catch (e:Error)
			{
				updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
			}
			
		}


		private function onURLLoadingComplete(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			var parser:SMILParser = new SMILParser();
			var mediaElement:MediaElement = parser.parse(xml);

			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					// The root element has been loaded successfully. Set *this* element as loaded as well
					// Send the Root element's loaded context as my own loaded context 
					var loadedContext:SMILLoadedContext = new SMILLoadedContext(mediaElement);
					updateLoadTrait(loadTrait, LoadState.READY, loadedContext);
				}
				else if (event.loadState == LoadState.LOAD_ERROR)
				{
					updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
				}
			}


			if (mediaElement.hasTrait(MediaTraitType.LOAD))
			{
				mediaLoadTrait = mediaElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
				mediaLoadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
				mediaLoadTrait.load();
			}
		}

		private function onURLLoadingError(event:Event):void
		{
			updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
		}


		private var loadTrait:LoadTrait;
		private var mediaLoadTrait:LoadTrait;
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
	}
}