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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved.
* 
*****************************************************/
package org.osmf.netmocker
{
	import org.osmf.net.httpstreaming.HTTPMetricsProvider;
	
	public class MockHTTPMetricsProvider extends HTTPMetricsProvider
	{
		public function MockHTTPMetricsProvider()
		{
			super(null);
		}

		public function set downloadRatio(value:Number):void
		{
			_downloadRatio = value;
		}
		
		override public function get downloadRatio():Number
		{
			return _downloadRatio;
		}
		
		override public function getBitrateForIndex(index:int):Number
		{
			return resource.streamItems[index].bitrate;
		}
		
		private var _downloadRatio:Number = 0;
		private var _bitrates:Array;
	}
}