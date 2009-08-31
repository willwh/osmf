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
	import flash.events.IEventDispatcher;

	import org.openvideoplayer.net.NetConnectionFactory;
	import org.openvideoplayer.net.NetNegotiator;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.media.IURLResource;

	/**
	 * The AkamaiNetConnectionFactory class extends NetConnectionFactory to
	 * provide the means to create a custom NetNegotiator (via the 
	 * <code>createNetNegotiator</code> method) and create a 
	 * unique key for connection sharing (via the <code>extractKey</code>
	 * method).
	 * 
	 * @see NetNegotiator
	 * 
	 */
	public class AkamaiNetConnectionFactory extends NetConnectionFactory
	{
		/**
		 * Constructor.
		 */
		public function AkamaiNetConnectionFactory(target:IEventDispatcher=null)
		{
			super(target);
		}

		/**
		 * Overrides the base class method to provide a custom NetNegotiator
		 */
		override protected function createNetNegotiator():NetNegotiator
		{
			return new AkamaiNetNegotiator();
		}
		

		/**
		 * @inheritDoc
		 */
		override protected function extractKey(resource:IURLResource):String
		{
			var fmsURL:FMSURL = resource is FMSURL ? resource as FMSURL : new FMSURL(resource.url.rawUrl);
			var authToken:String = fmsURL.getParamValue("auth");
			var aifpToken:String = fmsURL.getParamValue("aifp");
			var slistToken:String = fmsURL.getParamValue("slist");
			
			return fmsURL.protocol + fmsURL.host + fmsURL.port + fmsURL.appName + authToken + aifpToken + slistToken;
		}
		
	}
}

