/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved.
* 
*  Contributor: Adobe Systems Inc.
*  
*****************************************************/
package org.osmf.net
{
	import flash.events.EventDispatcher;
	import flash.net.NetStream;
		
	/**
	 * The NetStreamMetricsBase class serves as a base class for a provider of
	 * run-time metrics to the switching rules.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class NetStreamMetricsBase extends EventDispatcher
	{		
		/**
		 * Constructor.
		 * 
		 * Note that for correct operation of this class, the caller must set the
		 * resource which the monitored stream is playing.
		 * 
		 * @param ns The NetStream instance the class will monitor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function NetStreamMetricsBase(netStream:NetStream)
		{
			super();
			
			_netStream = netStream;
			_enabled = true;
		}

		/**
		 * Indicates whether this metrics engine is enabled.
		 **/
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		/**
		 * Returns the DynamicStreamingResource which the class is referencing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get resource():DynamicStreamingResource
		{
			return _resource;
		}
		
		public function set resource(value:DynamicStreamingResource):void 
		{
			_resource = value;
			_maxAllowedIndex = value != null ? value.streamItems.length - 1 : 0;
		}

		/**
		 * The NetStream object supplied to the constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get netStream():NetStream
		{
			return _netStream;
		}
		
		/**
		 * The current stream index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function set currentIndex(i:int):void 
		{
			_currentIndex = i;
		}
		
		/**
		 * The maximum allowed index value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get maxAllowedIndex():int 
		{
			return _maxAllowedIndex;
		}
		
		public function set maxAllowedIndex(value:int):void
		{
			_maxAllowedIndex = value;
		}
		
		private var _netStream:NetStream;
		private var _resource:DynamicStreamingResource;
		private var _currentIndex:int;
		private var _maxAllowedIndex:int;
		private var _enabled:Boolean;
	}
}
