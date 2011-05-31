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
package org.osmf.elements.f4mClasses
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.osmf.events.ParseEvent;
	import org.osmf.net.httpstreaming.HTTPStreamingUtils;
	import org.osmf.utils.URL;

	[ExcludeClass]

	/**
	 * @private
	 *
	 * Handles the parsing of manifest XML that could contain multi-level media nodes.
	 */
	public class MultiLevelManifestParser extends ManifestParser
	{
		/**
		 * Constructor.
		 */
		public function MultiLevelManifestParser()
		{
			super();
		}

		/**
		 * @private
		 */
		override public function parse(value:String, rootUrl:String=null, manifest:Manifest=null):void
		{
			unfinishedLoads = 0;
			parsing = true;

			// If we weren't passed a manifest we need to build one.
			// Otherwise we'll use the one that was passed in and add to it.
			if (!manifest)
			{
				manifest = new Manifest();
			}

			// Now use whatever manifest we end up with.
			this.manifest = manifest;

			var root:XML = new XML(value);
			var nmsp:Namespace = root.namespace();

			// The first thing we'll need to parse is the top level XML we just received.
			queue = [];
			queue.push(root);
			
			// Save off any information we need.
			if (!baseUrls)
			{
				baseUrls = new Dictionary(true);
			}
			
			var baseUrl:String = (manifest.baseURL != null) ? manifest.baseURL : rootUrl;
			baseUrls[root] = baseUrl;

			// Check to see if we need to load any other manifests.
			// The url will be in the <media> nodes.
			for each (var media:XML in root.nmsp::media)
			{
				if (media.attribute('href').length() > 0)
				{
					unfinishedLoads++;

					// Get the link.
					var href:String = media.@href;

					// Get ready to load.
					var loader:URLLoader = new URLLoader();
					loader.addEventListener(Event.COMPLETE, onLoadComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);

					// Save off any information we need.
					if (!loadingInfo)
					{
						loadingInfo = new Dictionary(true);
					}

					var info:Info = new Info();

					info.baseUrl = URL.getRootUrl(href);

					if (media.attribute('bitrate').length() > 0)
					{
						info.bitrate = media.@bitrate;
					}

					loadingInfo[loader] = info;

					loader.load(new URLRequest(HTTPStreamingUtils.normalizeURL(href)));
				}
			}

			parsing = false;

			if (unfinishedLoads == 0)
			{
				processQueue();
			}
		}

		/**
		 * @private
		 */
		override protected function finishLoad(manifest:Manifest):void
		{
			if (!processQueue())
			{
				// The baseUrl means nothing here because each source came from someplace different.
				// The urls have already been made absolute, so just null it out.
				manifest.baseURL = null;

				// Let the parsing finish as usual.
				super.finishLoad(manifest);
			}
		}

		/**
		 * @private
		 */
		override protected function buildMediaParser():BaseParser
		{
			return new ExternalMediaParser();
		}

		/**
		 * @private
		 * @return Whether or not an item from the queue is being processed.
		 */
		private function processQueue():Boolean
		{
			// We're still parsing so just assume we're not done.
			if (parsing)
			{
				return true;
			}

			// If there's anything left to parse, process it.
			if (queue.length > 0)
			{
				var xml:XML = queue.pop() as XML;
				var baseUrl:String = baseUrls[xml];
				super.parse(xml.toXMLString(), baseUrl, manifest);
				return true;
			}
			else
			{
				return false;
			}
		}

		private function onLoadComplete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;

			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);

			// Pull out the media node from the manifest.
			var root:XML = XML(URLLoader(event.target).data);
			var nmsp:Namespace = root.namespace();

			// Get the saved information.
			var info:Info = loadingInfo[loader];
			delete loadingInfo[loader];

			for each (var media:XML in root.nmsp::media)
			{
				// Put the bitrate into the media node(s).
				// Note: There *should* only be one media node, but we'll
				// dump the bitrate in a for...each just in case.
				if (info.bitrate != null && info.bitrate.length > 0)
				{
					media.@bitrate = info.bitrate;
				}

				// Make the url absolute.
				// The streams could have come from anywhere, so we need to
				// be sure we specify where they came from.
				var url:String = media.@url;
				if (url.indexOf("http") != 0)
				{
					media.@url = info.baseUrl + '/' + url;
				}
			}

			// Save off any information we need.
			if (!baseUrls)
			{
				baseUrls = new Dictionary(true);
			}

			baseUrls[root] = info.baseUrl;

			queue.push(root);

			// Once we've finished loading we can process everything.
			unfinishedLoads--;
			if (unfinishedLoads == 0)
			{
				processQueue();
			}
		}

		private function onLoadError(event:Event):void
		{
			unfinishedLoads--;
			dispatchEvent(new ParseEvent(ParseEvent.PARSE_ERROR));
		}

		private var parsing:Boolean = false;

		private var unfinishedLoads:Number;

		private var manifest:Manifest;

		private var queue:Array;

		private var baseUrls:Dictionary;

		private var loadingInfo:Dictionary;
	}
}

class Info
{
	public var bitrate:String;

	public var baseUrl:String;
}