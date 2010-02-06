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
package org.osmf.utils
{
	import __AS3__.vec.Vector;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.net.dynamicstreaming.MetricsProvider;
	import org.osmf.net.dynamicstreaming.NetStreamSwitchManager;
	import org.osmf.net.dynamicstreaming.SwitchingRuleBase;
	
	public class DynamicNetStreamSwitchManager extends NetStreamSwitchManager
	{
		public function DynamicNetStreamSwitchManager
			( connection:NetConnection
			, netStream:NetStream
			, dsResource:DynamicStreamingResource
			, rules:Vector.<SwitchingRuleBase>)
		{
			super(connection, netStream, dsResource, rules);
		}

		public function get metricsProvider():MetricsProvider
		{
			return _metricsProvider;
		}
		
		public function addRule(rule:SwitchingRuleBase):void
		{
			addSwitchingRule(rule);
		}
		
		// Overrides
		//
		
		override protected function createMetricsProvider():MetricsProvider
		{
			_metricsProvider = super.createMetricsProvider();
			return _metricsProvider;
		}
		
		private var _metricsProvider:MetricsProvider;
	}
}