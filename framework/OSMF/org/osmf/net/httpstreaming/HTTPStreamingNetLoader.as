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
package org.osmf.net.httpstreaming
{
	import __AS3__.vec.Vector;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.NetLoader;
	import org.osmf.net.NetStreamSwitchManager;
	import org.osmf.net.SwitchingRuleBase;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FFileHandler;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FIndexHandler;
	import org.osmf.traits.LoadTrait;

	/**
	 * A NetLoader subclass which adds support for HTTP streaming.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class HTTPStreamingNetLoader extends NetLoader
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPStreamingNetLoader()
		{
			// Connection sharing and custom NetConnectionFactory classes are
			// irrelevant for HTTP streaming connections, hence we don't allow
			// the client to pass those params in.
			super();
		}
		
		/**
		 * @private
		 */
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			return (HTTPStreamingUtils.getHTTPStreamingMetadataFacet(resource) != null);
		}
		
		/**
		 * @private
		 */
		override protected function createNetStream(connection:NetConnection,loadTrait:LoadTrait):NetStream
		{
			var indexHandler:HTTPStreamingIndexHandlerBase = new HTTPStreamingF4FIndexHandler();
			var fileHandler:HTTPStreamingFileHandlerBase = new HTTPStreamingF4FFileHandler(indexHandler);
			var httpNetStream:HTTPNetStream = new HTTPNetStream(connection, indexHandler, fileHandler);
			httpNetStream.manualSwitchMode = true;
			httpNetStream.indexInfo = HTTPStreamingUtils.createF4FIndexInfo(loadTrait.resource as URLResource);
			return httpNetStream;
		}
		
		/**
		 * @private
		 * 
		 * Overridden to allow the creation of a NetStreamSwitchManager object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override protected function createNetStreamSwitchManager(connection:NetConnection, netStream:NetStream, loadTrait:LoadTrait):NetStreamSwitchManager
		{
			// Only generate the switching manager if the resource is truly
			// switchable.
			var dsResource:DynamicStreamingResource = loadTrait.resource as DynamicStreamingResource;
			if (dsResource != null)
			{
				var metrics:HTTPNetStreamMetrics = new HTTPNetStreamMetrics(netStream as HTTPNetStream);
				return new NetStreamSwitchManager(connection, netStream, dsResource, metrics, getDefaultSwitchingRules(metrics));
			}
			return null;
		}
		
		private function getDefaultSwitchingRules(metrics:HTTPNetStreamMetrics):Vector.<SwitchingRuleBase>
		{
			var rules:Vector.<SwitchingRuleBase> = new Vector.<SwitchingRuleBase>();
			rules.push(new DownloadRatioRule(metrics));
			return rules;
		}
	}
}