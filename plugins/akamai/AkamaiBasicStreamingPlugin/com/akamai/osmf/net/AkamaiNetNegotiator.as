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
	
	import org.osmf.net.NetNegotiator;
	import org.osmf.utils.URL;
	import org.osmf.utils.FMSURL;

	/**
	 * The AkamaiNetNegotiator class is a custom <code>NetNegotiator</code> class serving
	 * two primary purposes: 1) provide a mechanism for the creation of a custom
	 * <code>NetConnection</code> via the <code>createNetConnection</code> method, and
	 * 2) Supports token authentication specific to the Akamai network via the 
	 * <code>buildConnectionAddress</code> method.
	 */
	public class AkamaiNetNegotiator extends NetNegotiator
	{
		/**
		 * @inheritDoc
		 */
		public function AkamaiNetNegotiator()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createNetConnection():NetConnection
		{
			return new AkamaiNetConnection();
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildConnectionAddress(url:URL, protocol:String, port:String):String
		{
			var fmsURL:FMSURL = url as FMSURL;
			if (fmsURL == null)
			{
				fmsURL = new FMSURL(url.toString());
			}
			
			var authToken:String = fmsURL.getParamValue("auth");
			var aifpToken:String = fmsURL.getParamValue("aifp");
			var slistToken:String = fmsURL.getParamValue("slist");
					
			var retVal:String = new String(protocol + "://" + fmsURL.host + ":" + port + "/" + fmsURL.appName);
			
			if (authToken.length > 0)
			{
				retVal += "?auth=" + authToken;
			}
			
			if (aifpToken.length > 0)
			{
				retVal += "&aifp=" + aifpToken;
			}
			
			if (slistToken.length > 0)
			{
				retVal += "&slist=" + slistToken;
			}
			
			return retVal;
		}				
	}
}
