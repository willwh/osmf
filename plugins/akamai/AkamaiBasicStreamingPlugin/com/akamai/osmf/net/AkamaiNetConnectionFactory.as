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
	
	import org.osmf.media.URLResource;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.utils.FMSURL;

	/**
	 * The AkamaiNetConnectionFactory class extends NetConnectionFactory to
	 * provide the means to create a unique key for connection sharing and
	 * support token authentication.
	 * 
	 */
	public class AkamaiNetConnectionFactory extends NetConnectionFactory
	{
		/**
		 * Constructor.
		 */
		public function AkamaiNetConnectionFactory()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function createNetConnectionKey(resource:URLResource):String
		{
			var fmsURL:FMSURL = resource is FMSURL ? resource as FMSURL : new FMSURL(resource.url.rawUrl);
			var authToken:String = fmsURL.getParamValue("auth");
			var aifpToken:String = fmsURL.getParamValue("aifp");
			var slistToken:String = fmsURL.getParamValue("slist");
			
			return super.createNetConnectionKey(resource) + authToken + aifpToken + slistToken;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createNetConnectionObject():NetConnection
		{
			return new AkamaiNetConnection();
		}
	}
}

