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
*****************************************************/

package com.akamai.osmf.net
{
	import flash.net.NetConnection;
	
	import org.osmf.net.FMSURL;

	/**
	 * The AkamaiNetConnection class extends NetConnection to provide 
	 * Akamai CDN-specifc connection behavior such as FCSubscribe for 
	 * live streaming.
	 */
	public class AkamaiNetConnection extends NetConnection
	{	
		/**
		 * Constructor.
		 */
		public function AkamaiNetConnection()
		{
			_isLive = false;
			super();
		}
		
		/**
		 * Allows package level access to determine whether or not the
		 * connection requested is to a live stream.
		 */
		internal function get isLive():Boolean
		{
			return _isLive;
		} 
		
		/**
		 * @inheritDoc
		 */
		override public function connect(command:String, ...parameters):void
		{
			if (command != null)
			{
				var theURL:FMSURL = new FMSURL(command);
				_isLive = (theURL.appName.toLowerCase() == "live") ? true : false;	
			}
			super.connect(command, parameters);
		}
		
		private var _isLive:Boolean;
	}
}
